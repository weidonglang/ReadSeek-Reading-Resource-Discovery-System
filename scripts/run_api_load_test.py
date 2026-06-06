#!/usr/bin/env python3
from __future__ import annotations

import argparse
import concurrent.futures
import itertools
import json
import random
import time
from datetime import datetime
from pathlib import Path
from typing import Any

from readseek_eval_common import (
    HttpClient,
    api_body,
    auth_headers,
    encode_query,
    ensure_dir,
    load_dotenv,
    login,
    mean,
    normalize_base_url,
    percentile,
    write_csv,
    write_json,
)


SEARCH_QUERIES = [
    "爱情小说", "科幻小说 入门", "Jane Austen", "H. G. Wells", "The Power of Habit",
    "人工智能", "恐怖悬疑", "数学史", "The Every", "Pride and Prejudice",
]

RAG_QUESTIONS = [
    "帮我推荐几本爱情小说。",
    "我想从经典科幻入门，先读哪几本？",
    "The Every 和 Player Piano 有什么区别？",
    "帮我找几本自我管理相关的书。",
    "如果没有 Java 书，系统应该如何回答？",
]


def run_request(
    api_base_url: str,
    token: str | None,
    scenario: str,
    timeout: int,
    sequence: int,
) -> dict[str, Any]:
    client = HttpClient(timeout=timeout)
    started = time.perf_counter()
    try:
        if scenario == "search":
            query = SEARCH_QUERIES[sequence % len(SEARCH_QUERIES)]
            url = f"{api_base_url}/api/search/resources?{encode_query({'q': query, 'limit': 8})}"
            response, latency_ms = client.request("GET", url, headers=auth_headers(token))
            body = api_body(response) or {}
            count = len(body.get("hits") or [])
        elif scenario == "rag":
            question = RAG_QUESTIONS[sequence % len(RAG_QUESTIONS)]
            response, latency_ms = client.request(
                "POST",
                f"{api_base_url}/api/qa/evidence",
                headers=auth_headers(token),
                body={"question": question, "mode": "fast", "provider": "ollama", "limit": 5},
            )
            body = api_body(response) or {}
            count = len(body.get("evidence") or [])
        elif scenario == "recommendation":
            response, latency_ms = client.request(
                "GET",
                f"{api_base_url}/api/resources/recommendations/overview",
                headers=auth_headers(token),
            )
            body = api_body(response) or {}
            count = len(body.get("shelves") or [])
        else:
            raise ValueError(f"Unknown scenario {scenario}")
        return {
            "scenario": scenario,
            "sequence": sequence,
            "success": True,
            "latencyMs": latency_ms,
            "resultCount": count,
            "error": "",
        }
    except Exception as exception:
        return {
            "scenario": scenario,
            "sequence": sequence,
            "success": False,
            "latencyMs": (time.perf_counter() - started) * 1000,
            "resultCount": 0,
            "error": str(exception),
        }


def summarize(rows: list[dict[str, Any]]) -> dict[str, Any]:
    latencies = [float(row["latencyMs"]) for row in rows]
    successes = [row for row in rows if row.get("success")]
    return {
        "requests": len(rows),
        "successes": len(successes),
        "failures": len(rows) - len(successes),
        "successRate": len(successes) / len(rows) if rows else 0.0,
        "avgLatencyMs": mean(latencies),
        "p50LatencyMs": percentile(latencies, 50),
        "p90LatencyMs": percentile(latencies, 90),
        "p95LatencyMs": percentile(latencies, 95),
        "p99LatencyMs": percentile(latencies, 99),
        "maxLatencyMs": max(latencies) if latencies else 0.0,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Run lightweight ReadSeek API load tests.")
    parser.add_argument("--env-file", default=".env")
    parser.add_argument("--api-base-url", default=None)
    parser.add_argument("--admin-email", default=None)
    parser.add_argument("--admin-password", default=None)
    parser.add_argument("--output-dir", default="docs/evaluation/generated")
    parser.add_argument("--scenarios", default="search,recommendation")
    parser.add_argument("--requests", type=int, default=100)
    parser.add_argument("--concurrency", type=int, default=8)
    parser.add_argument("--timeout", type=int, default=180)
    parser.add_argument("--login", action=argparse.BooleanOptionalAction, default=True)
    args = parser.parse_args()

    env = load_dotenv(args.env_file)
    api_base_url = normalize_base_url(args.api_base_url, env)
    token = None
    if args.login:
        token = login(HttpClient(timeout=args.timeout), api_base_url, env, args.admin_email, args.admin_password)

    scenarios = [item.strip() for item in args.scenarios.split(",") if item.strip()]
    work_items = list(itertools.islice(itertools.cycle(scenarios), args.requests))
    random.shuffle(work_items)
    started_at = time.perf_counter()
    rows: list[dict[str, Any]] = []
    with concurrent.futures.ThreadPoolExecutor(max_workers=args.concurrency) as executor:
        futures = [
            executor.submit(run_request, api_base_url, token, scenario, args.timeout, index)
            for index, scenario in enumerate(work_items, start=1)
        ]
        for future in concurrent.futures.as_completed(futures):
            row = future.result()
            rows.append(row)
            print(f"{row['scenario']} #{row['sequence']} success={row['success']} latency={row['latencyMs']:.1f}ms")
    elapsed_seconds = time.perf_counter() - started_at

    by_scenario = {
        scenario: summarize([row for row in rows if row["scenario"] == scenario])
        for scenario in scenarios
    }
    summary = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "apiBaseUrl": api_base_url,
        "requests": args.requests,
        "concurrency": args.concurrency,
        "elapsedSeconds": elapsed_seconds,
        "throughputRps": args.requests / elapsed_seconds if elapsed_seconds else 0.0,
        "overall": summarize(rows),
        "byScenario": by_scenario,
    }

    output_dir = ensure_dir(args.output_dir)
    write_json(output_dir / "load_test_results.json", {"summary": summary, "requests": rows})
    write_csv(output_dir / "load_test_requests.csv", rows, ["scenario", "sequence", "success", "latencyMs", "resultCount", "error"])
    lines = [
        "# ReadSeek API Load Test",
        "",
        f"- Generated at: {summary['generatedAt']}",
        f"- Requests: {summary['requests']}",
        f"- Concurrency: {summary['concurrency']}",
        f"- Throughput: {summary['throughputRps']:.2f} req/s",
        "",
        "| Scope | Success rate | Avg ms | P50 | P90 | P95 | P99 | Max |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    scopes = {"overall": summary["overall"], **summary["byScenario"]}
    for scope, metrics in scopes.items():
        lines.append(
            f"| {scope} | {metrics['successRate']:.4f} | {metrics['avgLatencyMs']:.1f} | "
            f"{metrics['p50LatencyMs']:.1f} | {metrics['p90LatencyMs']:.1f} | "
            f"{metrics['p95LatencyMs']:.1f} | {metrics['p99LatencyMs']:.1f} | {metrics['maxLatencyMs']:.1f} |"
        )
    (output_dir / "load_test_report.md").write_text("\n".join(lines), encoding="utf-8")
    print(f"Load test written to {output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
