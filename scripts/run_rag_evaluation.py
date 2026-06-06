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
    normalize_base_url,
    recall_at_k,
    resolve_relevant_ids,
    write_csv,
    write_json,
)


def call_rag(client: HttpClient, api_base_url: str, token: str, question: str, mode: str, provider: str, limit: int) -> tuple[dict[str, Any], float]:
    response, latency_ms = client.request(
        "POST",
        f"{api_base_url}/api/qa/evidence",
        headers=auth_headers(token),
        body={"question": question, "mode": mode, "provider": provider, "limit": limit},
    )
    return api_body(response) or {}, latency_ms


def evidence_ids(body: dict[str, Any]) -> list[int]:
    ids: list[int] = []
    for item in body.get("evidence") or []:
        resource_id = item.get("resourceId")
        if resource_id is not None:
            ids.append(int(resource_id))
    return ids


def citation_coverage(body: dict[str, Any]) -> float:
    answer = body.get("answer") or ""
    citations = body.get("citations") or []
    if not citations:
        return 0.0
    evidence_count = len(body.get("evidence") or [])
    if evidence_count <= 0:
        return 0.0
    used = 0
    for index in range(1, evidence_count + 1):
        if f"[{index}]" in answer:
            used += 1
    return used / evidence_count


def write_report(output_dir: Path, summary: dict[str, Any]) -> None:
    lines = [
        "# ReadSeek RAG Evaluation",
        "",
        f"- Generated at: {summary['generatedAt']}",
        f"- Question count: {summary['questionCount']}",
        f"- Mode/provider: {summary['mode']} / {summary['provider']}",
        "",
        "| Metric | Value |",
        "| --- | ---: |",
        f"| Answerable rate | {summary['answerableRate']:.4f} |",
        f"| Evidence hit rate | {summary['evidenceHitRate']:.4f} |",
        f"| Mean evidence recall | {summary['meanEvidenceRecall']:.4f} |",
        f"| Mean citation coverage | {summary['meanCitationCoverage']:.4f} |",
        f"| Average total latency ms | {summary['avgTotalLatencyMs']:.1f} |",
        "",
        "Manual scoring columns are left blank in `rag_evaluation_manual_scoring.csv` for relevance, completeness, citation validity, and hallucination risk.",
    ]
    (output_dir / "rag_report.md").write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Run ReadSeek 60-question RAG evaluation.")
    parser.add_argument("--env-file", default=".env")
    parser.add_argument("--api-base-url", default=None)
    parser.add_argument("--admin-email", default=None)
    parser.add_argument("--admin-password", default=None)
    parser.add_argument("--questions", default="docs/evaluation/rag_questions_60.json")
    parser.add_argument("--output-dir", default="docs/evaluation/generated")
    parser.add_argument("--mode", default="standard")
    parser.add_argument("--provider", default="ollama")
    parser.add_argument("--limit", type=int, default=8)
    parser.add_argument("--question-limit", type=int, default=-1, help="Run only the first N questions when positive.")
    parser.add_argument("--timeout", type=int, default=180)
    args = parser.parse_args()

    env = load_dotenv(args.env_file)
    api_base_url = normalize_base_url(args.api_base_url, env)
    client = HttpClient(timeout=args.timeout)
    token = login(client, api_base_url, env, args.admin_email, args.admin_password)
    catalog = fetch_catalog(client, api_base_url, token)
    question_data = json.loads(Path(args.questions).read_text(encoding="utf-8"))
    questions = question_data.get("questions") or []
    if args.question_limit == 0:
        questions = []
    elif args.question_limit > 0:
        questions = questions[: args.question_limit]
    output_dir = ensure_dir(args.output_dir)

    results: list[dict[str, Any]] = []
    scoring_rows: list[dict[str, Any]] = []
    for index, item in enumerate(questions, start=1):
        expected_ids = resolve_relevant_ids(item, catalog)
        print(f"[{index}/{len(questions)}] {item['id']} expected={len(expected_ids)}")
        try:
            body, request_latency_ms = call_rag(client, api_base_url, token, item["question"], args.mode, args.provider, args.limit)
            ids = evidence_ids(body)
            expected_hit = bool(set(ids) & set(expected_ids)) if expected_ids else bool(ids)
            result = {
                "id": item["id"],
                "question": item["question"],
                "answerModeExpected": item.get("answerMode"),
                "answerModeActual": body.get("answerMode"),
                "answerable": bool(body.get("answerable")),
                "strategy": body.get("strategy"),
                "model": body.get("model"),
                "fallbackApplied": body.get("fallbackApplied"),
                "llmFallbackApplied": body.get("llmFallbackApplied"),
                "evidenceCount": len(ids),
                "evidenceIds": ids,
                "expectedResourceIds": expected_ids,
                "expectedEvidenceHit": expected_hit,
                "evidenceRecall": recall_at_k(ids, expected_ids, len(ids)) if expected_ids else 0.0,
                "citationCoverage": citation_coverage(body),
                "requestLatencyMs": request_latency_ms,
                "totalLatencyMs": body.get("totalLatencyMs"),
                "retrievalLatencyMs": body.get("retrievalLatencyMs"),
                "generationLatencyMs": body.get("generationLatencyMs"),
                "answer": body.get("answer"),
                "limitations": body.get("limitations") or [],
                "error": None,
            }
        except Exception as exception:
            result = {
                "id": item["id"],
                "question": item["question"],
                "expectedResourceIds": expected_ids,
                "error": str(exception),
            }
        results.append(result)
        scoring_rows.append({
            "id": result["id"],
            "question": result["question"],
            "answerable": result.get("answerable"),
            "evidenceCount": result.get("evidenceCount"),
            "expectedEvidenceHit": result.get("expectedEvidenceHit"),
            "citationCoverage": result.get("citationCoverage"),
            "totalLatencyMs": result.get("totalLatencyMs"),
            "manualRelevance0to5": "",
            "manualCompleteness0to5": "",
            "manualCitationValidity0to5": "",
            "manualHallucinationRisk0to5": "",
            "notes": "",
        })

    valid = [row for row in results if not row.get("error")]
    summary = {
        "dataset": question_data.get("dataset"),
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "questionCount": len(questions),
        "successfulQuestions": len(valid),
        "mode": args.mode,
        "provider": args.provider,
        "answerableRate": mean([1.0 if row.get("answerable") else 0.0 for row in valid]),
        "evidenceHitRate": mean([1.0 if row.get("expectedEvidenceHit") else 0.0 for row in valid]),
        "meanEvidenceRecall": mean([float(row.get("evidenceRecall") or 0.0) for row in valid]),
        "meanCitationCoverage": mean([float(row.get("citationCoverage") or 0.0) for row in valid]),
        "avgTotalLatencyMs": mean([float(row.get("totalLatencyMs") or row.get("requestLatencyMs") or 0.0) for row in valid]),
    }

    write_json(output_dir / "rag_results.json", {"summary": summary, "results": results})
    write_csv(output_dir / "rag_evaluation_manual_scoring.csv", scoring_rows, [
        "id", "question", "answerable", "evidenceCount", "expectedEvidenceHit", "citationCoverage", "totalLatencyMs",
        "manualRelevance0to5", "manualCompleteness0to5", "manualCitationValidity0to5", "manualHallucinationRisk0to5", "notes",
    ])
    write_report(output_dir, summary)
    print(f"RAG evaluation written to {output_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
