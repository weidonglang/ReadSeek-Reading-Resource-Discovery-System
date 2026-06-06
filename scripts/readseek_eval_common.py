#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import math
import os
import statistics
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path
from typing import Any


DEFAULT_API_BASE_URL = "http://localhost:8010/readseek-service"


def load_dotenv(path: str | Path = ".env") -> dict[str, str]:
    env: dict[str, str] = {}
    file_path = Path(path)
    if not file_path.exists():
        return env
    for raw_line in file_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        env[key.strip()] = value.strip().strip('"').strip("'")
    return env


def normalize_base_url(value: str | None, env: dict[str, str] | None = None) -> str:
    env = env or {}
    return (value or env.get("READSEEK_API_BASE_URL") or DEFAULT_API_BASE_URL).rstrip("/")


class HttpClient:
    def __init__(self, timeout: int = 60) -> None:
        self.timeout = timeout

    def request(
        self,
        method: str,
        url: str,
        *,
        headers: dict[str, str] | None = None,
        body: Any | None = None,
    ) -> tuple[Any, float]:
        request_headers = dict(headers or {})
        encoded_body = None
        if body is not None:
            encoded_body = json.dumps(body, ensure_ascii=False).encode("utf-8")
            request_headers.setdefault("Content-Type", "application/json")
        req = urllib.request.Request(url, data=encoded_body, headers=request_headers, method=method)
        started_at = time.perf_counter()
        try:
            with urllib.request.urlopen(req, timeout=self.timeout) as response:
                text = response.read().decode("utf-8")
        except urllib.error.HTTPError as error:
            details = error.read().decode("utf-8", errors="replace")
            raise RuntimeError(f"{method} {url} failed with HTTP {error.code}: {details}") from error
        elapsed_ms = (time.perf_counter() - started_at) * 1000
        return (json.loads(text) if text else None), elapsed_ms


def api_body(response: Any) -> Any:
    if isinstance(response, dict) and "body" in response:
        return response.get("body")
    return response


def login(client: HttpClient, api_base_url: str, env: dict[str, str], email: str | None = None, password: str | None = None) -> str:
    resolved_email = email or env.get("LIBRARY_BOOTSTRAP_ADMIN_EMAIL")
    resolved_password = password or env.get("LIBRARY_BOOTSTRAP_ADMIN_PASSWORD")
    if not resolved_email or not resolved_password:
        raise ValueError("Missing admin credentials. Set .env or pass --admin-email/--admin-password.")
    response, _ = client.request(
        "POST",
        f"{api_base_url}/api/auth/log-in",
        body={"email": resolved_email, "password": resolved_password},
    )
    token = (api_body(response) or {}).get("accessToken")
    if not token:
        raise RuntimeError("Login succeeded but accessToken was not returned.")
    return token


def auth_headers(token: str | None) -> dict[str, str]:
    return {"Authorization": f"Bearer {token}"} if token else {}


def fetch_catalog(client: HttpClient, api_base_url: str, token: str | None = None, page_size: int = 500) -> list[dict[str, Any]]:
    books: list[dict[str, Any]] = []
    page_number = 1
    while True:
        payload = {
            "criteria": {"name": None},
            "pageNumber": page_number,
            "pageSize": page_size,
            "deletedRecords": False,
            "sortingByList": [{"fieldName": "id", "direction": "ASC", "isNumber": True}],
        }
        response, _ = client.request(
            "POST",
            f"{api_base_url}/api/resources/search",
            headers=auth_headers(token),
            body=payload,
        )
        body = api_body(response) or {}
        page_books = body.get("result") or body.get("list") or body.get("content") or []
        books.extend(page_books)
        total = int(body.get("totalNumberOfElements") or len(books))
        if len(books) >= total or not page_books:
            break
        page_number += 1
    return books


def text_of_book(book: dict[str, Any]) -> str:
    tags = " ".join(tag.get("name", "") for tag in book.get("tags") or [] if isinstance(tag, dict))
    author = ((book.get("author") or {}).get("name") or "")
    category = ((book.get("category") or {}).get("name") or "")
    publisher = ((book.get("publisher") or {}).get("name") or "")
    return " ".join([
        str(book.get("name") or ""),
        author,
        category,
        publisher,
        tags,
        str(book.get("isbn") or ""),
        str(book.get("description") or ""),
    ]).lower()


def resolve_relevant_ids(query: dict[str, Any], catalog: list[dict[str, Any]]) -> list[int]:
    explicit_ids = query.get("relevantResourceIds") or []
    ids: list[int] = []
    for value in explicit_ids:
        try:
            ids.append(int(value))
        except (TypeError, ValueError):
            pass
    if ids:
        return unique_ints(ids)

    relevance = query.get("relevance") or {}
    title_hints = normalize_terms(relevance.get("titleHints"))
    author_hints = normalize_terms(relevance.get("authorHints"))
    category_hints = normalize_terms(relevance.get("categoryHints"))
    tag_hints = normalize_terms(relevance.get("tagHints"))
    keyword_hints = normalize_terms(relevance.get("keywordHints"))
    max_ids = int(relevance.get("maxRelevantIds") or query.get("maxRelevantIds") or 12)

    scored: list[tuple[int, int]] = []
    for book in catalog:
        book_id = book.get("id")
        if book_id is None:
            continue
        title = str(book.get("name") or "").lower()
        author = str((book.get("author") or {}).get("name") or "").lower()
        category = str((book.get("category") or {}).get("name") or "").lower()
        tags = " ".join(str((tag or {}).get("name") or "").lower() for tag in book.get("tags") or [])
        full_text = text_of_book(book)
        score = 0
        score += 8 * count_matches(title, title_hints)
        score += 6 * count_matches(author, author_hints)
        score += 5 * count_matches(category, category_hints)
        score += 4 * count_matches(tags, tag_hints)
        score += 2 * count_matches(full_text, keyword_hints)
        if score > 0:
            scored.append((int(book_id), score))

    scored.sort(key=lambda item: (-item[1], item[0]))
    return [book_id for book_id, _ in scored[:max_ids]]


def normalize_terms(value: Any) -> list[str]:
    if value is None:
        return []
    if isinstance(value, str):
        values = [value]
    else:
        values = list(value)
    return [str(item).strip().lower() for item in values if str(item).strip()]


def count_matches(text: str, terms: list[str]) -> int:
    return sum(1 for term in terms if term and term in text)


def unique_ints(values: list[int]) -> list[int]:
    seen: set[int] = set()
    result: list[int] = []
    for value in values:
        if value not in seen:
            seen.add(value)
            result.append(value)
    return result


def extract_hit_ids(search_body: dict[str, Any]) -> list[int]:
    ids: list[int] = []
    for hit in search_body.get("hits") or []:
        book = hit.get("book") or {}
        book_id = book.get("id")
        if book_id is not None:
            ids.append(int(book_id))
    return ids


def precision_at_k(ranked_ids: list[int], relevant_ids: list[int], k: int) -> float:
    if k <= 0:
        return 0.0
    relevant = set(relevant_ids)
    if not relevant:
        return 0.0
    return sum(1 for book_id in ranked_ids[:k] if book_id in relevant) / k


def recall_at_k(ranked_ids: list[int], relevant_ids: list[int], k: int) -> float:
    relevant = set(relevant_ids)
    if not relevant:
        return 0.0
    return sum(1 for book_id in ranked_ids[:k] if book_id in relevant) / len(relevant)


def mrr(ranked_ids: list[int], relevant_ids: list[int]) -> float:
    relevant = set(relevant_ids)
    for index, book_id in enumerate(ranked_ids, start=1):
        if book_id in relevant:
            return 1.0 / index
    return 0.0


def ndcg_at_k(ranked_ids: list[int], relevant_ids: list[int], k: int) -> float:
    relevant = set(relevant_ids)
    dcg = 0.0
    for index, book_id in enumerate(ranked_ids[:k], start=1):
        if book_id in relevant:
            dcg += 1.0 / math.log2(index + 1)
    ideal_hits = min(len(relevant), k)
    idcg = sum(1.0 / math.log2(index + 1) for index in range(1, ideal_hits + 1))
    return dcg / idcg if idcg else 0.0


def mean(values: list[float]) -> float:
    return statistics.fmean(values) if values else 0.0


def percentile(values: list[float], percent: float) -> float:
    if not values:
        return 0.0
    ordered = sorted(values)
    index = min(len(ordered) - 1, max(0, math.ceil(len(ordered) * percent / 100) - 1))
    return ordered[index]


def ensure_dir(path: str | Path) -> Path:
    directory = Path(path)
    directory.mkdir(parents=True, exist_ok=True)
    return directory


def write_json(path: str | Path, data: Any) -> None:
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: str | Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    target = Path(path)
    target.parent.mkdir(parents=True, exist_ok=True)
    with target.open("w", encoding="utf-8", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def encode_query(params: dict[str, Any]) -> str:
    return urllib.parse.urlencode(params, doseq=True)
