#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
import sys
import threading
import time
from http import HTTPStatus
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from typing import Any

import numpy as np
from FlagEmbedding import BGEM3FlagModel, FlagReranker


class ModelHolder:
    model: BGEM3FlagModel | None = None
    model_name: str = "BAAI/bge-m3"
    dimensions: int = 1024
    max_length: int = 512
    use_fp16: bool = True
    reranker: FlagReranker | None = None
    reranker_model_name: str = "BAAI/bge-reranker-v2-m3"
    reranker_max_length: int = 512
    reranker_enabled: bool = True
    reranker_lock = threading.Lock()

    @classmethod
    def load(
        cls,
        model_name: str,
        dimensions: int,
        max_length: int,
        use_fp16: bool,
        reranker_model_name: str,
        reranker_max_length: int,
        reranker_enabled: bool,
    ) -> None:
        cls.model_name = model_name
        cls.dimensions = dimensions
        cls.max_length = max_length
        cls.use_fp16 = use_fp16
        cls.reranker_model_name = reranker_model_name
        cls.reranker_max_length = reranker_max_length
        cls.reranker_enabled = reranker_enabled

        print(
            f"Loading embedding model: {model_name}, "
            f"dimensions={dimensions}, max_length={max_length}, use_fp16={use_fp16}"
        )

        cls.model = BGEM3FlagModel(
            model_name,
            use_fp16=use_fp16,
        )

        print("Embedding model loaded successfully.")
        if reranker_enabled:
            print(f"Reranker model configured for lazy loading: {reranker_model_name}")
        else:
            print("Reranker model disabled.")

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

    @classmethod
    def ensure_reranker(cls) -> FlagReranker:
        if not cls.reranker_enabled:
            raise RuntimeError("Reranker is disabled.")

        if cls.reranker is None:
            with cls.reranker_lock:
                if cls.reranker is None:
                    print(
                        f"Loading reranker model: {cls.reranker_model_name}, "
                        f"max_length={cls.reranker_max_length}, use_fp16={cls.use_fp16}"
                    )
                    cls.reranker = FlagReranker(
                        cls.reranker_model_name,
                        use_fp16=cls.use_fp16,
                        max_length=cls.reranker_max_length,
                    )
                    print("Reranker model loaded successfully.")

        return cls.reranker

    @classmethod
    def rerank(cls, query: str, candidates: list[dict[str, Any]], top_n: int) -> list[dict[str, Any]]:
        reranker = cls.ensure_reranker()
        pairs: list[tuple[str, str]] = []
        normalized_candidates: list[dict[str, Any]] = []
        for index, candidate in enumerate(candidates):
            passage = build_candidate_passage(candidate)
            if not passage:
                continue
            normalized = dict(candidate)
            normalized["_index"] = index
            normalized["_passage"] = passage
            normalized_candidates.append(normalized)
            pairs.append((query, passage))

        if not pairs:
            return []

        raw_scores = reranker.compute_score(pairs)
        if isinstance(raw_scores, (float, int, np.floating, np.integer)):
            scores = [float(raw_scores)]
        elif isinstance(raw_scores, np.ndarray):
            scores = [float(score) for score in raw_scores.tolist()]
        else:
            scores = [float(score) for score in raw_scores]

        scored_candidates = [
            {
                "id": candidate.get("id"),
                "score": scores[index],
                "inputRank": candidate["_index"] + 1,
            }
            for index, candidate in enumerate(normalized_candidates)
            if index < len(scores)
        ]
        scored_candidates.sort(key=lambda item: (-item["score"], item["inputRank"]))

        limited = scored_candidates[: max(0, min(top_n, len(scored_candidates)))]
        for index, item in enumerate(limited, start=1):
            item["rank"] = index
        return limited


def build_candidate_passage(candidate: dict[str, Any]) -> str:
    passage = str(candidate.get("passage") or "").strip()
    if passage:
        return passage

    parts: list[str] = []
    field_names = [
        "title",
        "name",
        "isbn",
        "author",
        "authorName",
        "category",
        "categoryName",
        "publisher",
        "publisherName",
        "tags",
        "description",
    ]
    for field_name in field_names:
        value = candidate.get(field_name)
        if value is None:
            continue
        if isinstance(value, list):
            value = ", ".join(str(item) for item in value if item is not None)
        text = str(value).strip()
        if text:
            parts.append(text)
    return "\n".join(parts)


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
                    "rerankerBackend": "bge-reranker-v2-m3" if ModelHolder.reranker_enabled else "disabled",
                    "rerankerModel": ModelHolder.reranker_model_name,
                    "rerankerLoaded": ModelHolder.reranker is not None,
                },
            )
            return

        self._json_response(HTTPStatus.NOT_FOUND, {"error": "Not Found"})

    def do_POST(self) -> None:  # noqa: N802
        path = self.path.rstrip("/")
        if path not in {"/embed", "/rerank"}:
            self._json_response(HTTPStatus.NOT_FOUND, {"error": "Not Found"})
            return

        try:
            content_length = int(self.headers.get("Content-Length", "0"))
            raw_body = self.rfile.read(content_length) if content_length > 0 else b"{}"
            payload = json.loads(raw_body.decode("utf-8"))
        except Exception:
            self._json_response(HTTPStatus.BAD_REQUEST, {"error": "Invalid JSON payload."})
            return

        if path == "/rerank":
            self._handle_rerank(payload)
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

    def _handle_rerank(self, payload: dict[str, Any]) -> None:
        query = str(payload.get("query") or "").strip()
        if not query:
            self._json_response(HTTPStatus.BAD_REQUEST, {"error": "Field 'query' is required."})
            return

        raw_candidates = payload.get("candidates")
        if raw_candidates is None:
            raw_candidates = payload.get("books")
        if not isinstance(raw_candidates, list) or not raw_candidates:
            self._json_response(HTTPStatus.BAD_REQUEST, {"error": "Field 'candidates' must be a non-empty list."})
            return

        candidates = [candidate for candidate in raw_candidates if isinstance(candidate, dict)]
        if not candidates:
            self._json_response(HTTPStatus.BAD_REQUEST, {"error": "No valid candidate objects were provided."})
            return

        try:
            requested_top_n = int(payload.get("topN") or payload.get("top_n") or len(candidates))
        except Exception:
            requested_top_n = len(candidates)
        top_n = max(1, min(requested_top_n, len(candidates)))

        started = time.time()
        try:
            results = ModelHolder.rerank(query, candidates, top_n)
        except Exception as exc:
            self._json_response(
                HTTPStatus.INTERNAL_SERVER_ERROR,
                {
                    "error": "Rerank failed.",
                    "message": str(exc),
                },
            )
            return

        elapsed_ms = int((time.time() - started) * 1000)
        self._json_response(
            HTTPStatus.OK,
            {
                "results": results,
                "model": ModelHolder.reranker_model_name,
                "backend": "bge-reranker-v2-m3",
                "topN": top_n,
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
    parser.add_argument("--reranker-model", default=os.getenv("BOOK_AI_RERANKER_MODEL", "BAAI/bge-reranker-v2-m3"))
    parser.add_argument("--reranker-max-length", type=int, default=int(os.getenv("BOOK_AI_RERANKER_MAX_LENGTH", "512")))
    parser.add_argument("--disable-reranker", action="store_true")
    parser.add_argument("--no-fp16", action="store_true")
    return parser.parse_args()


def main() -> None:
    args = parse_args()

    ModelHolder.load(
        model_name=args.model,
        dimensions=args.dimensions,
        max_length=args.max_length,
        use_fp16=not args.no_fp16,
        reranker_model_name=args.reranker_model,
        reranker_max_length=args.reranker_max_length,
        reranker_enabled=not args.disable_reranker,
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
