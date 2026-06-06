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
    auth_headers,
    ensure_dir,
    fetch_catalog,
    load_dotenv,
    login,
    mean,
    ndcg_at_k,
    normalize_base_url,
    precision_at_k,
    recall_at_k,
    resolve_relevant_ids,
    write_csv,
    write_json,
)


def recommendation_ids_from_overview(overview: dict[str, Any]) -> dict[str, list[int]]:
    shelves: dict[str, list[int]] = {}
    for shelf in overview.get("shelves") or []:
        key = shelf.get("key") or shelf.get("source") or shelf.get("title") or "unknown"
        ids: list[int] = []
        for book in shelf.get("books") or []:
            book_id = book.get("id")
            if book_id is not None:
                ids.append(int(book_id))
        shelves[str(key)] = ids
    return shelves


def call_get(client: HttpClient, api_base_url: str, token: str, path: str) -> tuple[Any, float]:
    response, latency_ms = client.request("GET", f"{api_base_url}{path}", headers=auth_headers(token))
    return api_body(response), latency_ms


def metrics_for_ids(ranked_ids: list[int], relevant_ids: list[int], k: int) -> dict[str, float]:
    return {
        f"precisionAt{k}": precision_at_k(ranked_ids, relevant_ids, k),
        f"recallAt{k}": recall_at_k(ranked_ids, relevant_ids, k),
        "ndcgAt10": ndcg_at_k(ranked_ids, relevant_ids, 10),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Run ReadSeek recommendation offline/case evaluation.")
    parser.add_argument("--env-file", default=".env")
    parser.add_argument("--api-base-url", default=None)
    parser.add_argument("--admin-email", default=None)
    parser.add_argument("--admin-password", default=None)
    parser.add_argument("--queries", default="docs/evaluation/search_queries_100.json")
    parser.add_argument("--output-dir", default="docs/evaluation/generated")
    parser.add_argument("--query-limit", type=int, default=-1, help="Run only the first N theme queries when positive.")
    parser.add_argument("--metric-k", type=int, default=10)
    parser.add_argument("--timeout", type=int, default=90)
    parser.add_argument("--similar-anchor-limit", type=int, default=25)
    args = parser.parse_args()

    env = load_dotenv(args.env_file)
    api_base_url = normalize_base_url(args.api_base_url, env)
    client = HttpClient(timeout=args.timeout)
    token = login(client, api_base_url, env, args.admin_email, args.admin_password)
    catalog = fetch_catalog(client, api_base_url, token)
    query_data = json.loads(Path(args.queries).read_text(encoding="utf-8"))
    output_dir = ensure_dir(args.output_dir)

    overview, overview_latency = call_get(client, api_base_url, token, "/api/resources/recommendations/overview")
    shelves = recommendation_ids_from_overview(overview or {})

    theme_queries = [
        query for query in query_data.get("queries") or []
        if query.get("intent") in {"theme-cn", "theme-en", "natural-cn", "reading-path", "comparison", "multi-condition"}
    ]
    if args.query_limit == 0:
        theme_queries = []
    elif args.query_limit > 0:
        theme_queries = theme_queries[: args.query_limit]
    case_rows: list[dict[str, Any]] = []
    for query in theme_queries:
        relevant_ids = resolve_relevant_ids(query, catalog)
        if not relevant_ids:
            continue
        for shelf_key, ranked_ids in shelves.items():
            metric = metrics_for_ids(ranked_ids, relevant_ids, args.metric_k)
            case_rows.append({
                "caseType": "overview-shelf",
                "queryId": query.get("id"),
                "query": query.get("query"),
                "shelf": shelf_key,
                "rankedIds": ranked_ids,
                "relevantIds": relevant_ids,
                **metric,
            })

    similar_rows: list[dict[str, Any]] = []
    anchors = [book for book in catalog if book.get("id") is not None][: args.similar_anchor_limit]
    for book in anchors:
        book_id = int(book["id"])
        category = ((book.get("category") or {}).get("name") or "").strip()
        tags = [tag.get("name") for tag in book.get("tags") or [] if isinstance(tag, dict) and tag.get("name")]
        relevant = []
        for candidate in catalog:
            candidate_id = candidate.get("id")
            if candidate_id is None or int(candidate_id) == book_id:
                continue
            candidate_category = ((candidate.get("category") or {}).get("name") or "").strip()
            candidate_tags = [tag.get("name") for tag in candidate.get("tags") or [] if isinstance(tag, dict) and tag.get("name")]
            if category and candidate_category == category:
                relevant.append(int(candidate_id))
            elif set(tags) & set(candidate_tags):
                relevant.append(int(candidate_id))
        try:
            similar, latency = call_get(client, api_base_url, token, f"/api/resources/recommendations/similar/{book_id}")
            similar_ids: list[int] = []
            for ids in recommendation_ids_from_overview(similar or {}).values():
                similar_ids.extend(ids)
            metric = metrics_for_ids(similar_ids, relevant, args.metric_k)
            similar_rows.append({
                "caseType": "similar-recommendation",
                "anchorBookId": book_id,
                "anchorTitle": book.get("name"),
                "category": category,
                "rankedIds": similar_ids,
                "relevantIds": relevant[:50],
                "latencyMs": latency,
                **metric,
            })
        except Exception as exception:
            similar_rows.append({
                "caseType": "similar-recommendation",
                "anchorBookId": book_id,
                "anchorTitle": book.get("name"),
                "error": str(exception),
            })

    all_rows = case_rows + similar_rows
    metric_rows = [row for row in all_rows if not row.get("error")]
    summary = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "overviewLatencyMs": overview_latency,
        "overviewShelfCount": len(shelves),
        "overviewCaseCount": len(case_rows),
        "similarCaseCount": len(similar_rows),
        f"precisionAt{args.metric_k}": mean([float(row.get(f"precisionAt{args.metric_k}") or 0.0) for row in metric_rows]),
        f"recallAt{args.metric_k}": mean([float(row.get(f"recallAt{args.metric_k}") or 0.0) for row in metric_rows]),
        "ndcgAt10": mean([float(row.get("ndcgAt10") or 0.0) for row in metric_rows]),
    }

    csv_rows = []
    for row in all_rows:
        csv_rows.append({
            "caseType": row.get("caseType"),
            "queryId": row.get("queryId"),
            "query": row.get("query"),
            "shelf": row.get("shelf"),
            "anchorBookId": row.get("anchorBookId"),
            "anchorTitle": row.get("anchorTitle"),
            "latencyMs": row.get("latencyMs"),
            f"precisionAt{args.metric_k}": row.get(f"precisionAt{args.metric_k}"),
            f"recallAt{args.metric_k}": row.get(f"recallAt{args.metric_k}"),
            "ndcgAt10": row.get("ndcgAt10"),
            "error": row.get("error"),
        })

    write_json(output_dir / "recommendation_offline_results.json", {
        "summary": summary,
        "overviewShelves": shelves,
        "overviewCases": case_rows,
        "similarCases": similar_rows,
    })
    write_csv(output_dir / "recommendation_offline_metrics.csv", csv_rows, [
        "caseType", "queryId", "query", "shelf", "anchorBookId", "anchorTitle", "latencyMs",
        f"precisionAt{args.metric_k}", f"recallAt{args.metric_k}", "ndcgAt10", "error",
    ])
    lines = [
        "# ReadSeek Recommendation Offline Evaluation",
        "",
        f"- Generated at: {summary['generatedAt']}",
        f"- Overview shelves: {summary['overviewShelfCount']}",
        f"- Overview cases: {summary['overviewCaseCount']}",
        f"- Similar recommendation cases: {summary['similarCaseCount']}",
        "",
        "| Metric | Value |",
        "| --- | ---: |",
        f"| Precision@{args.metric_k} | {summary[f'precisionAt{args.metric_k}']:.4f} |",
        f"| Recall@{args.metric_k} | {summary[f'recallAt{args.metric_k}']:.4f} |",
        f"| NDCG@10 | {summary['ndcgAt10']:.4f} |",
    ]
    (output_dir / "recommendation_offline_report.md").write_text("\n".join(lines), encoding="utf-8")
    print(f"Recommendation evaluation written to {output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
