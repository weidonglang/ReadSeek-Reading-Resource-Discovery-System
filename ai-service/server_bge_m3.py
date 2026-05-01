#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
import time
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any

import numpy as np
from FlagEmbedding import BGEM3FlagModel


class ModelHolder:
    model: BGEM3FlagModel | None = None
    model_name: str = "BAAI/bge-m3"
    dimensions: int = 1024
    max_length: int = 512
    use_fp16: bool = True

    @classmethod
    def load(
        cls,
        model_name: str,
        dimensions: int,
        max_length: int,
        use_fp16: bool,
    ) -> None:
        cls.model_name = model_name
        cls.dimensions = dimensions
        cls.max_length = max_length
        cls.use_fp16 = use_fp16

        print(
            f"Loading embedding model: {model_name}, "
            f"dimensions={dimensions}, max_length={max_length}, use_fp16={use_fp16}"
        )

        cls.model = BGEM3FlagModel(
            model_name,
            use_fp16=use_fp16,
        )

        print("Embedding model loaded successfully.")

    @classmethod
    def embed(cls, text: str) -> list[float]:
        if cls.model is None:
            raise RuntimeError("Embedding model is not loaded.")

        output = cls.model.encode(
            [text],
            batch_size=1,
            max_length=cls.max_length,
            return_dense=True,
            return_sparse=False,
            return_colbert_vecs=False,
        )

        vector = output["dense_vecs"][0]

        if isinstance(vector, np.ndarray):
            vector = vector.astype(float).tolist()
        else:
            vector = [float(x) for x in vector]

        if len(vector) != cls.dimensions:
            raise ValueError(
                f"Embedding dimension mismatch: expected {cls.dimensions}, got {len(vector)}"
            )

        return vector


class EmbeddingHandler(BaseHTTPRequestHandler):
    server_version = "ReadSeekAiService/1.0"

    def _json_response(self, status: int, payload: dict[str, Any]) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self) -> None:  # noqa: N802
        if self.path.rstrip("/") == "/health":
            self._json_response(
                HTTPStatus.OK,
                {
                    "status": "ok",
                    "service": "readseek-ai-service",
                    "embeddingBackend": "bge-m3",
                    "dimensions": ModelHolder.dimensions,
                    "model": ModelHolder.model_name,
                    "maxLength": ModelHolder.max_length,
                    "useFp16": ModelHolder.use_fp16,
                },
            )
            return

        self._json_response(HTTPStatus.NOT_FOUND, {"error": "Not Found"})

    def do_POST(self) -> None:  # noqa: N802
        if self.path.rstrip("/") != "/embed":
            self._json_response(HTTPStatus.NOT_FOUND, {"error": "Not Found"})
            return

        try:
            content_length = int(self.headers.get("Content-Length", "0"))
            raw_body = self.rfile.read(content_length) if content_length > 0 else b"{}"
            payload = json.loads(raw_body.decode("utf-8"))
        except Exception:
            self._json_response(HTTPStatus.BAD_REQUEST, {"error": "Invalid JSON payload."})
            return

        text = str(payload.get("text") or "").strip()
        if not text:
            self._json_response(HTTPStatus.BAD_REQUEST, {"error": "Field 'text' is required."})
            return

        input_type = str(payload.get("inputType") or "query").strip() or "query"
        started = time.time()
        try:
            vector = ModelHolder.embed(text)
        except Exception as exc:
            self._json_response(
                HTTPStatus.INTERNAL_SERVER_ERROR,
                {
                    "error": "Embedding failed.",
                    "message": str(exc),
                },
            )
            return

        elapsed_ms = int((time.time() - started) * 1000)

        self._json_response(
            HTTPStatus.OK,
            {
                "vector": vector,
                "model": ModelHolder.model_name,
                "dimensions": ModelHolder.dimensions,
                "backend": "bge-m3",
                "inputType": input_type,
                "elapsedMs": elapsed_ms,
            },
        )

    def log_message(self, format: str, *args) -> None:  # noqa: A003
        sys.stdout.write(
            "%s - - [%s] %s\n"
            % (
                self.address_string(),
                self.log_date_time_string(),
                format % args,
            )
        )


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="ReadSeek local BGE-M3 embedding service.")
    parser.add_argument("--host", default=os.getenv("BOOK_AI_HOST", "127.0.0.1"))
    parser.add_argument("--port", type=int, default=int(os.getenv("BOOK_AI_PORT", "8001")))
    parser.add_argument("--model", default=os.getenv("BOOK_AI_MODEL", "BAAI/bge-m3"))
    parser.add_argument("--dimensions", type=int, default=int(os.getenv("BOOK_AI_EMBED_DIMENSIONS", "1024")))
    parser.add_argument("--max-length", type=int, default=int(os.getenv("BOOK_AI_MAX_LENGTH", "512")))
    parser.add_argument("--no-fp16", action="store_true")
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    ModelHolder.load(
        model_name=args.model,
        dimensions=args.dimensions,
        max_length=args.max_length,
        use_fp16=not args.no_fp16,
    )

    server = ThreadingHTTPServer((args.host, args.port), EmbeddingHandler)
    print(f"ReadSeek AI service listening on http://{args.host}:{args.port}")

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down ReadSeek AI service...")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
