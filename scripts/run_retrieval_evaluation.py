#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from datetime import datetime
from pathlib import Path
from typing import Any

from readseek_eval_common import (
    HttpClient,
    api_body,
    encode_query,
    ensure_dir,
    extract_hit_ids,
    fetch_catalog,
    load_dotenv,
    login,
    mean,
    mrr,
    ndcg_at_k,
    normalize_base_url,
    precision_at_k,
    recall_at_k,
    resolve_relevant_ids,
    write_csv,
    write_json,
)


METHODS = {
    "bm25": "/api/search/resources/bm25",
    "vector": "/api/search/resources/vector",
    "hybrid": "/api/search/resources/hybrid-basic",
    "hybrid_reranker": "/api/search/resources",
}


def call_search(client: HttpClient, api_base_url: str, endpoint: str, query: str, limit: int) -> tuple[dict[str, Any], float]:
    url = f"{api_base_url}{endpoint}?{encode_query({'q': query, 'limit': limit})}"
    response, latency_ms = client.request("GET", url)
    return api_body(response) or {}, latency_ms


def evaluate_query_result(ranked_ids: list[int], relevant_ids: list[int], k: int) -> dict[str, float]:
    return {
        f"precisionAt{k}": precision_at_k(ranked_ids, relevant_ids, k),
        f"recallAt{k}": recall_at_k(ranked_ids, relevant_ids, k),
        "mrr": mrr(ranked_ids, relevant_ids),
        "ndcgAt10": ndcg_at_k(ranked_ids, relevant_ids, 10),
    }


def aggregate(method_results: list[dict[str, Any]], k: int) -> dict[str, Any]:
    valid = [row for row in method_results if not row.get("error")]
    return {
        "queryCount": len(method_results),
        "successfulQueries": len(valid),
        f"precisionAt{k}": mean([row["metrics"][f"precisionAt{k}"] for row in valid]),
        f"recallAt{k}": mean([row["metrics"][f"recallAt{k}"] for row in valid]),
        "mrr": mean([row["metrics"]["mrr"] for row in valid]),
        "ndcgAt10": mean([row["metrics"]["ndcgAt10"] for row in valid]),
        "avgLatencyMs": mean([row["latencyMs"] for row in valid]),
    }


def write_report(output_dir: Path, summary: dict[str, Any], k: int) -> None:
    lines = [
        "# ReadSeek Retrieval Evaluation",
        "",
        f"- Generated at: {summary['generatedAt']}",
        f"- Query count: {summary['queryCount']}",
        f"- Metric focus: Precision@{k}, Recall@{k}, MRR, NDCG@10, average latency",
        "",
        "| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg latency ms |",
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: |",
    ]
    for method, metrics in summary["metrics"].items():
        lines.append(
            "| {method} | {successfulQueries}/{queryCount} | {precision:.4f} | {recall:.4f} | {mrr:.4f} | {ndcg:.4f} | {latency:.1f} |".format(
                method=method,
                successfulQueries=metrics["successfulQueries"],
                queryCount=metrics["queryCount"],
                precision=metrics[f"precisionAt{k}"],
                recall=metrics[f"recallAt{k}"],
                mrr=metrics["mrr"],
                ndcg=metrics["ndcgAt10"],
                latency=metrics["avgLatencyMs"],
            )
        )
    (output_dir / "retrieval_report.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Run ReadSeek four-way retrieval evaluation.")
    parser.add_argument("--env-file", default=".env")
    parser.add_argument("--api-base-url", default=None)
    parser.add_argument("--admin-email", default=None)
    parser.add_argument("--admin-password", default=None)
    parser.add_argument("--queries", default="docs/evaluation/search_queries_100.json")
    parser.add_argument("--output-dir", default="docs/evaluation/generated")
    parser.add_argument("--limit", type=int, default=10)
    parser.add_argument("--query-limit", type=int, default=-1, help="Run only the first N queries when positive.")
    parser.add_argument("--metric-k", type=int, default=5)
    parser.add_argument("--timeout", type=int, default=90)
    parser.add_argument("--methods", default="bm25,vector,hybrid,hybrid_reranker")
    args = parser.parse_args()

    env = load_dotenv(args.env_file)
    api_base_url = normalize_base_url(args.api_base_url, env)
    client = HttpClient(timeout=args.timeout)
    token = login(client, api_base_url, env, args.admin_email, args.admin_password)
    query_data = json.loads(Path(args.queries).read_text(encoding="utf-8"))
    queries = query_data.get("queries") or []
    if args.query_limit == 0:
        queries = []
    elif args.query_limit > 0:
        queries = queries[: args.query_limit]
    catalog = fetch_catalog(client, api_base_url, token)
    output_dir = ensure_dir(args.output_dir)
    selected_methods = [method.strip() for method in args.methods.split(",") if method.strip()]

    results: dict[str, list[dict[str, Any]]] = {method: [] for method in selected_methods}
    resolved_queries: list[dict[str, Any]] = []

    for index, query in enumerate(queries, start=1):
        relevant_ids = resolve_relevant_ids(query, catalog)
        resolved_query = dict(query)
        resolved_query["resolvedRelevantResourceIds"] = relevant_ids
        resolved_queries.append(resolved_query)
        print(f"[{index}/{len(queries)}] {query['id']} {query['query']} relevant={len(relevant_ids)}")

        for method in selected_methods:
            endpoint = METHODS.get(method)
            if not endpoint:
                results[method].append({"queryId": query["id"], "error": f"Unknown method {method}"})
                continue
            try:
                body, latency_ms = call_search(client, api_base_url, endpoint, query["query"], args.limit)
                ranked_ids = extract_hit_ids(body)
                results[method].append({
                    "queryId": query["id"],
                    "query": query["query"],
                    "intent": query.get("intent"),
                    "method": method,
                    "strategy": body.get("strategy"),
                    "queryIntent": body.get("queryIntent"),
                    "rerankerApplied": body.get("rerankerApplied"),
                    "fallbackApplied": body.get("fallbackApplied"),
                    "candidateCount": body.get("candidateCount"),
                    "latencyMs": latency_ms,
                    "rankedResourceIds": ranked_ids,
                    "relevantResourceIds": relevant_ids,
                    "metrics": evaluate_query_result(ranked_ids, relevant_ids, args.metric_k),
                })
            except Exception as exception:
                results[method].append({
                    "queryId": query["id"],
                    "query": query["query"],
                    "intent": query.get("intent"),
                    "method": method,
                    "error": str(exception),
                })

    summary = {
        "dataset": query_data.get("dataset"),
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "queryCount": len(queries),
        "metricK": args.metric_k,
        "methods": selected_methods,
        "metrics": {method: aggregate(rows, args.metric_k) for method, rows in results.items()},
    }
    flat_rows = [row for method_rows in results.values() for row in method_rows]
    csv_rows = []
    for row in flat_rows:
        metrics = row.get("metrics") or {}
        csv_rows.append({
            "queryId": row.get("queryId"),
            "method": row.get("method"),
            "intent": row.get("intent"),
            "strategy": row.get("strategy"),
            "latencyMs": row.get("latencyMs"),
            f"precisionAt{args.metric_k}": metrics.get(f"precisionAt{args.metric_k}"),
            f"recallAt{args.metric_k}": metrics.get(f"recallAt{args.metric_k}"),
            "mrr": metrics.get("mrr"),
            "ndcgAt10": metrics.get("ndcgAt10"),
            "relevantCount": len(row.get("relevantResourceIds") or []),
            "error": row.get("error"),
        })

    write_json(output_dir / "search_queries_100_resolved.json", {"queries": resolved_queries})
    write_json(output_dir / "retrieval_results.json", {"summary": summary, "results": results})
    write_csv(output_dir / "retrieval_metrics.csv", csv_rows, [
        "queryId", "method", "intent", "strategy", "latencyMs",
        f"precisionAt{args.metric_k}", f"recallAt{args.metric_k}", "mrr", "ndcgAt10", "relevantCount", "error",
    ])
    write_report(output_dir, summary, args.metric_k)
    print(f"Retrieval evaluation written to {output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
