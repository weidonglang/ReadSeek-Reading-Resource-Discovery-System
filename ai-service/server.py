#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
import json
import math
import os
import re
import sys
from collections import Counter
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Iterable


WORD_PATTERN = re.compile(r"[A-Za-z0-9]+(?:['_-][A-Za-z0-9]+)?")


def contains_cjk(text: str) -> bool:
    return any("\u4e00" <= char <= "\u9fff" for char in text)


def tokenize(text: str) -> list[str]:
    normalized = (text or "").strip().lower()
    if not normalized:
        return []

    tokens: list[str] = []
    tokens.extend(WORD_PATTERN.findall(normalized))

    cjk_chars = [char for char in normalized if "\u4e00" <= char <= "\u9fff"]
    tokens.extend(cjk_chars)
    tokens.extend(
        "".join(cjk_chars[index:index + 2])
        for index in range(len(cjk_chars) - 1)
    )

    if not tokens:
        tokens.append(normalized)

    return tokens


def stable_token_vector(token: str, dimensions: int) -> list[float]:
    vector = [0.0] * dimensions
    digest = hashlib.sha256(token.encode("utf-8")).digest()
    lanes = max(4, min(12, dimensions // 32 or 4))
    for lane in range(lanes):
        start = (lane * 4) % len(digest)
        chunk = digest[start:start + 4]
        if len(chunk) < 4:
            chunk = (chunk + digest)[:4]
        value = int.from_bytes(chunk, "big", signed=False)
        index = value % dimensions
        sign = 1.0 if ((value >> 31) & 1) == 0 else -1.0
        magnitude = 0.5 + (((value >> 16) & 0x7FFF) / 0x7FFF)
        vector[index] += sign * magnitude
    return vector


def l2_normalize(vector: Iterable[float]) -> list[float]:
    values = list(vector)
    norm = math.sqrt(sum(value * value for value in values))
    if norm == 0:
        return values
    return [value / norm for value in values]


def hash_embed(text: str, dimensions: int) -> list[float]:
    tokens = tokenize(text)
    if not tokens:
        return [0.0] * dimensions

    counts = Counter(tokens)
    vector = [0.0] * dimensions
    for token, count in counts.items():
        token_weight = 1.0 + math.log1p(count)
        token_vector = stable_token_vector(token, dimensions)
        for index, value in enumerate(token_vector):
            vector[index] += value * token_weight
    return l2_normalize(vector)


class EmbeddingHandler(BaseHTTPRequestHandler):
    server_version = "BookAiService/0.1"

    def _json_response(self, status: int, payload: dict) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:  # noqa: N802
        if self.path.rstrip("/") == "/health":
            self._json_response(HTTPStatus.OK, {
                "status": "ok",
                "service": "book-ai-service",
                "embeddingBackend": self.server.embedding_backend,
                "dimensions": self.server.embedding_dimensions,
                "model": self.server.default_model,
            })
            return

        self._json_response(HTTPStatus.NOT_FOUND, {
            "error": "Not Found"
        })

    def do_POST(self) -> None:  # noqa: N802
        if self.path.rstrip("/") != "/embed":
            self._json_response(HTTPStatus.NOT_FOUND, {
                "error": "Not Found"
            })
            return

        try:
            content_length = int(self.headers.get("Content-Length", "0"))
            raw_body = self.rfile.read(content_length) if content_length > 0 else b"{}"
            payload = json.loads(raw_body.decode("utf-8"))
        except Exception:
            self._json_response(HTTPStatus.BAD_REQUEST, {
                "error": "Invalid JSON payload."
            })
            return

        text = str(payload.get("text") or "").strip()
        if not text:
            self._json_response(HTTPStatus.BAD_REQUEST, {
                "error": "Field 'text' is required."
            })
            return

        model = str(payload.get("model") or self.server.default_model).strip() or self.server.default_model
        input_type = str(payload.get("inputType") or "query").strip() or "query"
        vector = hash_embed(text, self.server.embedding_dimensions)
        self._json_response(HTTPStatus.OK, {
            "vector": vector,
            "model": model,
            "dimensions": self.server.embedding_dimensions,
            "backend": self.server.embedding_backend,
            "inputType": input_type,
            "tokenCount": len(tokenize(text)),
            "containsCjk": contains_cjk(text),
        })

    def log_message(self, format: str, *args) -> None:  # noqa: A003
        sys.stdout.write("%s - - [%s] %s\n" % (
            self.address_string(),
            self.log_date_time_string(),
            format % args,
        ))


class EmbeddingServer(ThreadingHTTPServer):
    def __init__(self, server_address: tuple[str, int], handler_class: type[BaseHTTPRequestHandler],
                 embedding_dimensions: int, default_model: str, embedding_backend: str) -> None:
        super().__init__(server_address, handler_class)
        self.embedding_dimensions = embedding_dimensions
        self.default_model = default_model
        self.embedding_backend = embedding_backend


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Minimal local AI embedding service for book retrieval.")
    parser.add_argument("--host", default=os.getenv("BOOK_AI_HOST", "127.0.0.1"))
    parser.add_argument("--port", type=int, default=int(os.getenv("BOOK_AI_PORT", "8001")))
    parser.add_argument("--dimensions", type=int, default=int(os.getenv("BOOK_AI_EMBED_DIMENSIONS", "384")))
    parser.add_argument("--model", default=os.getenv("BOOK_AI_MODEL", "hash-bow-384"))
    parser.add_argument("--backend", default=os.getenv("BOOK_AI_BACKEND", "hash-bow"))
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    server = EmbeddingServer(
        (args.host, args.port),
        EmbeddingHandler,
        embedding_dimensions=args.dimensions,
        default_model=args.model,
        embedding_backend=args.backend,
    )
    print(
        f"Book AI service listening on http://{args.host}:{args.port} "
        f"(backend={args.backend}, model={args.model}, dimensions={args.dimensions})"
    )
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down Book AI service...")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
