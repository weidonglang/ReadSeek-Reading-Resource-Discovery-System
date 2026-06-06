#!/usr/bin/env python3
"""
Enrich ReadSeek catalog metadata through an OpenAI-compatible chat API.

Default mode is dry-run: it writes a preview JSON and does not update ReadSeek.
Use --apply after reviewing the preview.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import socket
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Any


DEFAULT_API_BASE_URL = "http://localhost:8010/readseek-service"
DEFAULT_AI_BASE_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1"
DEFAULT_AI_MODEL = "qwen3.5-omni-plus-2026-03-15"
DEFAULT_OUTPUT = "scripts/generated/catalog_ai_enrichment_preview.json"


def load_dotenv(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.exists():
        return values
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


class HttpClient:
    def __init__(self, timeout: int) -> None:
        self.timeout = timeout

    def request(
        self,
        method: str,
        url: str,
        *,
        headers: dict[str, str] | None = None,
        body: Any | None = None,
    ) -> Any:
        encoded_body = None
        request_headers = dict(headers or {})
        if body is not None:
            encoded_body = json.dumps(body, ensure_ascii=False).encode("utf-8")
            request_headers.setdefault("Content-Type", "application/json")
        req = urllib.request.Request(url, data=encoded_body, method=method, headers=request_headers)
        try:
            with urllib.request.urlopen(req, timeout=self.timeout) as response:
                text = response.read().decode("utf-8")
        except urllib.error.HTTPError as error:
            details = error.read().decode("utf-8", errors="replace")
            raise RuntimeError(f"{method} {url} failed with HTTP {error.code}: {details}") from error
        if not text:
            return None
        return json.loads(text)


def api_body(response: Any) -> Any:
    if not isinstance(response, dict):
        return response
    return response.get("body")


def normalize_base_url(value: str) -> str:
    return value.rstrip("/")


def load_provider(args: argparse.Namespace, env: dict[str, str]) -> dict[str, Any]:
    if args.provider_config:
        providers = json.loads(Path(args.provider_config).read_text(encoding="utf-8"))
        if isinstance(providers, dict) and "providers" in providers:
            providers = providers["providers"]
        if not isinstance(providers, list):
            raise ValueError("--provider-config must contain a JSON array or {'providers': [...]}")
        selected = None
        for provider in providers:
            if args.provider_name and provider.get("name") == args.provider_name:
                selected = provider
                break
            if not args.provider_name and provider.get("enabled"):
                selected = provider
                break
        if selected is None:
            raise ValueError("No enabled provider found. Pass --provider-name or set one provider enabled=true.")
        api_key = selected.get("api_key") or env.get(selected.get("api_key_env") or "") or os.environ.get(selected.get("api_key_env") or "")
        return {
            "name": selected.get("name") or "configured-provider",
            "base_url": normalize_base_url(selected.get("base_url") or DEFAULT_AI_BASE_URL),
            "api_key": api_key,
            "model": args.ai_model or selected.get("model") or DEFAULT_AI_MODEL,
            "extra_headers": selected.get("extra_headers") or {},
        }

    api_key_env = args.ai_api_key_env or "DASHSCOPE_API_KEY"
    return {
        "name": args.provider_name or "env-provider",
        "base_url": normalize_base_url(args.ai_base_url or env.get("ONLINE_AI_BASE_URL") or DEFAULT_AI_BASE_URL),
        "api_key": os.environ.get(api_key_env) or env.get(api_key_env) or env.get("ONLINE_AI_API_KEY"),
        "model": args.ai_model or env.get("ONLINE_AI_MODEL") or DEFAULT_AI_MODEL,
        "extra_headers": {},
    }


def login(client: HttpClient, api_base_url: str, env: dict[str, str], args: argparse.Namespace) -> str:
    email = args.admin_email or env.get("LIBRARY_BOOTSTRAP_ADMIN_EMAIL")
    password = args.admin_password or env.get("LIBRARY_BOOTSTRAP_ADMIN_PASSWORD")
    if not email or not password:
        raise ValueError("Admin credentials are missing. Set .env values or pass --admin-email/--admin-password.")
    response = client.request(
        "POST",
        f"{api_base_url}/api/auth/log-in",
        body={"email": email, "password": password},
    )
    token = (api_body(response) or {}).get("accessToken")
    if not token:
        raise RuntimeError("Login succeeded but accessToken was not returned.")
    return token


def auth_headers(token: str) -> dict[str, str]:
    return {"Authorization": f"Bearer {token}"}


def fetch_books(client: HttpClient, api_base_url: str, token: str, page_size: int) -> list[dict[str, Any]]:
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
        response = client.request(
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


def fetch_tags(client: HttpClient, api_base_url: str, token: str) -> dict[str, dict[str, Any]]:
    response = client.request("GET", f"{api_base_url}/api/tag", headers=auth_headers(token))
    tags = api_body(response) or []
    return {normalize_tag_name(tag.get("name")): tag for tag in tags if tag.get("name")}


def normalize_tag_name(name: str | None) -> str:
    return (name or "").strip().lower()


def has_good_description(book: dict[str, Any], min_length: int) -> bool:
    description = (book.get("description") or "").strip()
    generic_values = {
        "no description available",
        "description unavailable",
        "blank description",
        "暂无简介",
        "暂无描述",
    }
    return len(description) >= min_length and description.lower() not in generic_values


def has_tags(book: dict[str, Any], min_tags: int) -> bool:
    return len(book.get("tags") or []) >= min_tags


def needs_enrichment(book: dict[str, Any], args: argparse.Namespace) -> bool:
    if not args.only_missing:
        return True
    return not has_good_description(book, args.min_description_length) or not has_tags(book, args.min_tags)


def prompt_for_book(book: dict[str, Any], max_tags: int) -> list[dict[str, str]]:
    author = (book.get("author") or {}).get("name") or ""
    category = (book.get("category") or {}).get("name") or ""
    current_description = book.get("description") or ""
    current_tags = [tag.get("name") for tag in book.get("tags") or [] if tag.get("name")]
    system = (
        "You are a catalog metadata assistant for a reading-resource discovery system. "
        "Return strict JSON only. Do not invent ISBN, publisher, publish date, page count, price, or cover URL. "
        "Use the known title, author, category, and current description. "
        "Do not add specific plot events, character names, wars, countries, dates, or factual claims unless they are explicitly present in the current description. "
        "If metadata is thin or suspicious, write a conservative genre/theme description instead of a plot summary. "
        "If the book is not actually about AI or programming, do not force technical tags."
    )
    user = f"""
Book:
- title: {book.get("name") or ""}
- author: {author}
- category: {category}
- current_description: {current_description[:1200]}
- current_tags: {", ".join(current_tags)}

Generate metadata for search and recommendation.

JSON schema:
{{
  "description": "120-220 Chinese characters. Be conservative; summarize only genre, themes, and reading value when facts are uncertain. Include the English title/topic terms when useful for search.",
  "tags": ["4-{max_tags} concise tags, mixed Chinese/English is allowed"],
  "search_keywords": ["6-12 keywords or aliases for retrieval"],
  "difficulty": "beginner|intermediate|advanced|unknown",
  "target_audience": "short Chinese phrase",
  "recommendation_reason": "short Chinese sentence grounded in the available book metadata",
  "confidence": 0.0
}}
"""
    return [{"role": "system", "content": system}, {"role": "user", "content": user.strip()}]


def call_ai(
    client: HttpClient,
    provider: dict[str, Any],
    book: dict[str, Any],
    args: argparse.Namespace,
) -> dict[str, Any]:
    if not provider.get("api_key"):
        raise ValueError("AI API key is missing. Set DASHSCOPE_API_KEY or use --provider-config.")
    url = f"{provider['base_url']}/chat/completions"
    headers = {
        "Authorization": f"Bearer {provider['api_key']}",
        "Content-Type": "application/json",
    }
    headers.update(provider.get("extra_headers") or {})
    payload = {
        "model": provider["model"],
        "messages": prompt_for_book(book, args.max_tags),
        "temperature": args.temperature,
        "max_tokens": args.max_tokens,
    }
    response = client.request("POST", url, headers=headers, body=payload)
    choices = response.get("choices") or []
    content = (((choices[0] or {}).get("message") or {}).get("content") or "").strip() if choices else ""
    return parse_ai_json(content)


def call_ai_with_retries(
    client: HttpClient,
    provider: dict[str, Any],
    book: dict[str, Any],
    args: argparse.Namespace,
) -> dict[str, Any]:
    last_error: Exception | None = None
    attempts = max(1, args.retries + 1)
    for attempt in range(1, attempts + 1):
        try:
            return call_ai(client, provider, book, args)
        except (TimeoutError, socket.timeout, urllib.error.URLError) as exception:
            last_error = exception
            if attempt >= attempts:
                break
            wait_seconds = args.retry_sleep * attempt
            print(f"  timeout/network error, retry {attempt}/{args.retries} after {wait_seconds:.1f}s: {exception}")
            time.sleep(wait_seconds)
        except Exception:
            raise
    raise RuntimeError(str(last_error) if last_error else "AI request failed")


def parse_ai_json(content: str) -> dict[str, Any]:
    cleaned = content.strip()
    if cleaned.startswith("```"):
        cleaned = re.sub(r"^```(?:json)?", "", cleaned, flags=re.IGNORECASE).strip()
        cleaned = re.sub(r"```$", "", cleaned).strip()
    if not cleaned.startswith("{"):
        match = re.search(r"\{.*\}", cleaned, flags=re.DOTALL)
        if match:
            cleaned = match.group(0)
    data = json.loads(cleaned)
    if not isinstance(data, dict):
        raise ValueError("AI response JSON must be an object.")
    return sanitize_enrichment(data)


def sanitize_enrichment(data: dict[str, Any]) -> dict[str, Any]:
    description = str(data.get("description") or "").strip()
    tags = data.get("tags") or []
    keywords = data.get("search_keywords") or []
    if not isinstance(tags, list):
        tags = []
    if not isinstance(keywords, list):
        keywords = []
    tags = unique_clean_strings(tags, 12)
    keywords = unique_clean_strings(keywords, 16)
    difficulty = str(data.get("difficulty") or "unknown").strip().lower()
    if difficulty not in {"beginner", "intermediate", "advanced", "unknown"}:
        difficulty = "unknown"
    confidence = data.get("confidence")
    try:
        confidence = max(0.0, min(1.0, float(confidence)))
    except (TypeError, ValueError):
        confidence = 0.0
    return {
        "description": description[:1000],
        "tags": tags,
        "search_keywords": keywords,
        "difficulty": difficulty,
        "target_audience": str(data.get("target_audience") or "").strip()[:160],
        "recommendation_reason": str(data.get("recommendation_reason") or "").strip()[:240],
        "confidence": confidence,
    }


def unique_clean_strings(values: list[Any], limit: int) -> list[str]:
    seen: set[str] = set()
    result: list[str] = []
    for value in values:
        text = str(value or "").strip()
        if not text or len(text) > 40:
            continue
        key = text.lower()
        if key in seen:
            continue
        seen.add(key)
        result.append(text)
        if len(result) >= limit:
            break
    return result


def enrichment_to_tags(enrichment: dict[str, Any], max_tags: int) -> list[str]:
    raw_tags = list(enrichment.get("tags") or [])
    for keyword in enrichment.get("search_keywords") or []:
        if len(raw_tags) >= max_tags:
            break
        if len(keyword) <= 24:
            raw_tags.append(keyword)
    if enrichment.get("difficulty") and enrichment["difficulty"] != "unknown":
        raw_tags.append(f"difficulty:{enrichment['difficulty']}")
    if enrichment.get("target_audience"):
        raw_tags.append(enrichment["target_audience"])
    return unique_clean_strings(raw_tags, max_tags)


def create_tag(
    client: HttpClient,
    api_base_url: str,
    token: str,
    existing_tags: dict[str, dict[str, Any]],
    name: str,
) -> dict[str, Any]:
    key = normalize_tag_name(name)
    if key in existing_tags:
        return existing_tags[key]
    payload = {
        "name": name,
        "description": f"AI-generated catalog tag: {name}",
        "markedAsDeleted": False,
    }
    response = client.request("POST", f"{api_base_url}/api/tag", headers=auth_headers(token), body=payload)
    tag = api_body(response)
    existing_tags[key] = tag
    return tag


def update_book(
    client: HttpClient,
    api_base_url: str,
    token: str,
    book: dict[str, Any],
    enrichment: dict[str, Any],
    tag_dtos: list[dict[str, Any]],
    args: argparse.Namespace,
) -> dict[str, Any]:
    updated = dict(book)
    if args.update_description and enrichment.get("description"):
        updated["description"] = enrichment["description"]
    existing_tags = book.get("tags") or []
    tags_by_id = {tag.get("id"): tag for tag in existing_tags if tag.get("id") is not None}
    for tag in tag_dtos:
        tags_by_id[tag.get("id")] = tag
    updated["tags"] = list(tags_by_id.values())
    response = client.request("PUT", f"{api_base_url}/api/resources", headers=auth_headers(token), body=updated)
    return api_body(response)


def rebuild_index(client: HttpClient, api_base_url: str, token: str) -> Any:
    return client.request("POST", f"{api_base_url}/api/search/index/resources/rebuild", headers=auth_headers(token))


def save_preview(path: Path, records: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(records, ensure_ascii=False, indent=2), encoding="utf-8")


def load_preview(path: Path) -> list[dict[str, Any]]:
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, list):
        raise ValueError("--input-preview must point to a JSON array.")
    records = [record for record in data if isinstance(record, dict)]
    if len(records) != len(data):
        raise ValueError("--input-preview contains non-object records.")
    return records


def record_book_id(record: dict[str, Any]) -> int | None:
    try:
        return int(record.get("bookId"))
    except (TypeError, ValueError):
        return None


def resolve_output_path(args: argparse.Namespace) -> Path:
    if args.input_preview and args.output == DEFAULT_OUTPUT:
        input_path = Path(args.input_preview)
        return input_path.with_name(f"{input_path.stem}_apply_result{input_path.suffix}")
    return Path(args.output)


def build_preview_record(book: dict[str, Any], enrichment: dict[str, Any]) -> dict[str, Any]:
    return {
        "bookId": book.get("id"),
        "title": book.get("name"),
        "author": (book.get("author") or {}).get("name"),
        "category": (book.get("category") or {}).get("name"),
        "currentDescriptionLength": len(book.get("description") or ""),
        "currentTags": [tag.get("name") for tag in book.get("tags") or []],
        "enrichment": enrichment,
        "status": "preview",
    }


def build_error_record(book: dict[str, Any], exception: Exception) -> dict[str, Any]:
    return {
        "bookId": book.get("id"),
        "title": book.get("name"),
        "status": "error",
        "error": str(exception),
    }


def generate_enrichment_record(
    position: int,
    provider: dict[str, Any],
    book: dict[str, Any],
    args: argparse.Namespace,
) -> tuple[int, dict[str, Any]]:
    client = HttpClient(timeout=args.http_timeout)
    enrichment = call_ai_with_retries(client, provider, book, args)
    return position, build_preview_record(book, enrichment)


def sorted_records(records_by_position: dict[int, dict[str, Any]]) -> list[dict[str, Any]]:
    return [records_by_position[position] for position in sorted(records_by_position)]


def apply_records(
    client: HttpClient,
    api_base_url: str,
    token: str,
    records_by_position: dict[int, dict[str, Any]],
    books_by_id: dict[int, dict[str, Any]],
    args: argparse.Namespace,
    output_path: Path,
) -> None:
    existing_tags = fetch_tags(client, api_base_url, token)
    print("Applying accepted records sequentially...")
    for position in sorted(records_by_position):
        record = records_by_position[position]
        if "enrichment" not in record:
            continue
        book_id = record_book_id(record)
        book = books_by_id.get(book_id or -1)
        if not book:
            record["status"] = "apply-error"
            record["applyError"] = f"Book id {record.get('bookId')} was not found in ReadSeek."
            save_preview(output_path, sorted_records(records_by_position))
            continue

        enrichment = record["enrichment"]
        confidence = float(enrichment.get("confidence") or 0.0)
        if confidence < args.min_apply_confidence:
            record["status"] = "skipped-low-confidence"
            record["skipReason"] = (
                f"confidence {confidence:.2f} is below --min-apply-confidence "
                f"{args.min_apply_confidence:.2f}"
            )
            save_preview(output_path, sorted_records(records_by_position))
            continue
        try:
            tag_names = enrichment_to_tags(enrichment, args.max_tags)
            tag_dtos = [create_tag(client, api_base_url, token, existing_tags, name) for name in tag_names]
            updated = update_book(client, api_base_url, token, book, enrichment, tag_dtos, args)
            record["status"] = "applied"
            record["updatedTagCount"] = len(updated.get("tags") or [])
        except Exception as exception:
            record["status"] = "apply-error"
            record["applyError"] = str(exception)
            print(f"  apply error for {record.get('title')}: {exception}", file=sys.stderr)
        save_preview(output_path, sorted_records(records_by_position))


def main() -> int:
    limit_arg_provided = any(arg == "--limit" or arg.startswith("--limit=") for arg in sys.argv[1:])
    parser = argparse.ArgumentParser(description="Enrich ReadSeek catalog metadata using an OpenAI-compatible AI API.")
    parser.add_argument("--env-file", default=".env")
    parser.add_argument("--api-base-url", default=None)
    parser.add_argument("--admin-email", default=None)
    parser.add_argument("--admin-password", default=None)
    parser.add_argument("--provider-config", default=None, help="Local JSON provider config. Keep this file out of Git.")
    parser.add_argument("--provider-name", default=None)
    parser.add_argument("--ai-base-url", default=None)
    parser.add_argument("--ai-model", default=None)
    parser.add_argument("--ai-api-key-env", default="DASHSCOPE_API_KEY")
    parser.add_argument("--limit", type=int, default=20)
    parser.add_argument("--page-size", type=int, default=300)
    parser.add_argument("--only-missing", action=argparse.BooleanOptionalAction, default=True)
    parser.add_argument("--min-description-length", type=int, default=80)
    parser.add_argument("--min-tags", type=int, default=2)
    parser.add_argument("--max-tags", type=int, default=8)
    parser.add_argument("--temperature", type=float, default=0.2)
    parser.add_argument("--max-tokens", type=int, default=800)
    parser.add_argument("--http-timeout", type=int, default=150)
    parser.add_argument("--retries", type=int, default=2)
    parser.add_argument("--retry-sleep", type=float, default=2.0)
    parser.add_argument("--parallel", type=int, default=1, help="Number of concurrent AI requests. Database writes stay sequential.")
    parser.add_argument("--min-apply-confidence", type=float, default=0.65)
    parser.add_argument("--sleep", type=float, default=0.6)
    parser.add_argument("--output", default=DEFAULT_OUTPUT)
    parser.add_argument("--input-preview", default=None, help="Apply an existing reviewed preview JSON without calling AI.")
    parser.add_argument("--apply", action="store_true", help="Write descriptions and tags back through the ReadSeek API.")
    parser.add_argument("--update-description", action=argparse.BooleanOptionalAction, default=True)
    parser.add_argument("--rebuild-index", action="store_true")
    args = parser.parse_args()

    env = load_dotenv(Path(args.env_file))
    api_base_url = normalize_base_url(args.api_base_url or env.get("READSEEK_API_BASE_URL") or DEFAULT_API_BASE_URL)
    provider = load_provider(args, env)
    client = HttpClient(timeout=args.http_timeout)

    token = login(client, api_base_url, env, args)
    books = fetch_books(client, api_base_url, token, args.page_size)
    books_by_id = {int(book["id"]): book for book in books if book.get("id") is not None}
    output_path = resolve_output_path(args)

    if args.input_preview:
        input_records = load_preview(Path(args.input_preview))
        if limit_arg_provided:
            if args.limit == 0:
                input_records = []
            elif args.limit > 0:
                input_records = input_records[: args.limit]
        records_by_position = {index: record for index, record in enumerate(input_records, start=1)}

        print(f"Catalog books: {len(books)}")
        print(f"Loaded preview records: {len(input_records)}")
        print(f"Input preview: {args.input_preview}")
        print("Mode: APPLY FROM PREVIEW" if args.apply else "Mode: PREVIEW INPUT ONLY")

        if args.apply:
            apply_records(client, api_base_url, token, records_by_position, books_by_id, args, output_path)
            if args.rebuild_index:
                print("Rebuilding search index...")
                rebuild_response = rebuild_index(client, api_base_url, token)
                print(json.dumps(rebuild_response, ensure_ascii=False))
        else:
            save_preview(output_path, sorted_records(records_by_position))

        print(f"Result written to {output_path}")
        return 0

    candidates = [book for book in books if needs_enrichment(book, args)]
    if args.limit == 0:
        candidates = []
    elif args.limit > 0:
        candidates = candidates[: args.limit]

    print(f"Catalog books: {len(books)}")
    print(f"Selected for enrichment: {len(candidates)}")
    print(f"AI provider: {provider['name']} / {provider['model']}")
    print(f"Parallel AI workers: {max(1, args.parallel)}")
    print("Mode: APPLY" if args.apply else "Mode: DRY RUN")

    records_by_position: dict[int, dict[str, Any]] = {}
    worker_count = max(1, min(args.parallel, len(candidates) or 1))

    if worker_count == 1:
        for index, book in enumerate(candidates, start=1):
            title = book.get("name") or f"id={book.get('id')}"
            print(f"[{index}/{len(candidates)}] {title}")
            try:
                _, record = generate_enrichment_record(index, provider, book, args)
            except Exception as exception:
                record = build_error_record(book, exception)
                print(f"  error: {exception}", file=sys.stderr)
            records_by_position[index] = record
            save_preview(output_path, sorted_records(records_by_position))
            if args.sleep > 0 and index < len(candidates):
                time.sleep(args.sleep)
    else:
        with ThreadPoolExecutor(max_workers=worker_count) as executor:
            futures = {}
            for index, book in enumerate(candidates, start=1):
                title = book.get("name") or f"id={book.get('id')}"
                print(f"[{index}/{len(candidates)}] queued {title}")
                future = executor.submit(generate_enrichment_record, index, provider, book, args)
                futures[future] = (index, book)

            for future in as_completed(futures):
                index, book = futures[future]
                title = book.get("name") or f"id={book.get('id')}"
                try:
                    _, record = future.result()
                    print(f"[{index}/{len(candidates)}] done {title}")
                except Exception as exception:
                    record = build_error_record(book, exception)
                    print(f"[{index}/{len(candidates)}] error {title}: {exception}", file=sys.stderr)
                records_by_position[index] = record
                save_preview(output_path, sorted_records(records_by_position))

    if args.apply:
        apply_records(client, api_base_url, token, records_by_position, books_by_id, args, output_path)

    if args.apply and args.rebuild_index:
        print("Rebuilding search index...")
        rebuild_response = rebuild_index(client, api_base_url, token)
        print(json.dumps(rebuild_response, ensure_ascii=False))

    print(f"Preview written to {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
