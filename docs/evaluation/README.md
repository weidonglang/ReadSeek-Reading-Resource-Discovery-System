# ReadSeek Evaluation Toolkit

This directory contains evaluation datasets, runnable scripts, and generated reports for ReadSeek retrieval, RAG, recommendation, and API latency experiments.

The legacy `queries.json` and `results.json` files are kept as a small UI template. The thesis-ready workflow uses:

- `search_queries_100.json`: 100 retrieval queries covering exact title, author-work, theme, natural language, comparison, reading-path, and fallback scenarios.
- `rag_questions_60.json`: 60 RAG questions covering recommendation, comparison, reading path, factual lookup, summary, and limitation scenarios.
- `generated/`: output directory for resolved relevance sets, metrics, reports, and request logs.

## 1. Generate Evaluation Sets

```powershell
.\.venv-ai\Scripts\python.exe scripts\generate_evaluation_assets.py
```

This recreates:

- `docs/evaluation/search_queries_100.json`
- `docs/evaluation/rag_questions_60.json`

## 2. Run Four-Way Retrieval Evaluation

Start PostgreSQL, Elasticsearch, Redis, the backend, and the AI service first. Rebuild the search index if needed.

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_retrieval_evaluation.py `
  --queries docs/evaluation/search_queries_100.json `
  --output-dir docs/evaluation/generated `
  --limit 10
```

Compared methods:

- `bm25`: `/api/search/resources/bm25`
- `vector`: `/api/search/resources/vector`
- `hybrid`: `/api/search/resources/hybrid-basic`
- `hybrid_reranker`: `/api/search/resources`

Outputs:

- `generated/search_queries_100_resolved.json`
- `generated/retrieval_results.json`
- `generated/retrieval_metrics.csv`
- `generated/retrieval_report.md`

## 3. Run RAG Evaluation

RAG requires login. The script reads admin credentials from `.env`.

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_rag_evaluation.py `
  --questions docs/evaluation/rag_questions_60.json `
  --output-dir docs/evaluation/generated `
  --mode standard `
  --provider ollama `
  --limit 8
```

Outputs:

- `generated/rag_results.json`
- `generated/rag_evaluation_manual_scoring.csv`
- `generated/rag_report.md`

Fill the manual scoring CSV after reviewing answers:

- `manualRelevance0to5`
- `manualCompleteness0to5`
- `manualCitationValidity0to5`
- `manualHallucinationRisk0to5`

## 4. Run Recommendation Offline / Case Evaluation

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_recommendation_offline_evaluation.py `
  --queries docs/evaluation/search_queries_100.json `
  --output-dir docs/evaluation/generated
```

Outputs:

- `generated/recommendation_offline_results.json`
- `generated/recommendation_offline_metrics.csv`
- `generated/recommendation_offline_report.md`

This is a small-scale offline/case evaluation based on catalog-derived relevance, not a large public interaction benchmark. If final thesis claims require Goodreads-style public interaction data, replace or supplement this script with that dataset.

## 5. Run Lightweight API Load Test

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_api_load_test.py `
  --scenarios search,recommendation `
  --requests 100 `
  --concurrency 8 `
  --output-dir docs/evaluation/generated
```

For RAG latency, include `rag`; it is much slower because it calls retrieval and LLM generation:

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_api_load_test.py `
  --scenarios search,recommendation,rag `
  --requests 60 `
  --concurrency 3 `
  --output-dir docs/evaluation/generated
```

Outputs:

- `generated/load_test_results.json`
- `generated/load_test_requests.csv`
- `generated/load_test_report.md`

## 6. Run Rust Benchmark CLI

The Rust CLI is an engineering companion to the Python scripts. It reuses the same evaluation data, the same ReadSeek APIs, and the same metric definitions, then emits JSON, CSV, Markdown, and static HTML reports.

```powershell
.\scripts\run_readseek_bench_rs.ps1
```

Full Rust suite:

```powershell
.\scripts\run_readseek_bench_rs_suite.ps1
```

Smoke test:

```powershell
.\scripts\run_readseek_bench_rs.ps1 `
  -OutputDir ..\docs\evaluation\generated\rust-smoke `
  -QueryLimit 3
```

Direct Cargo usage:

```powershell
cd readseek-bench-rs
cargo run --release -- retrieval `
  --env-file ..\.env `
  --queries ..\docs\evaluation\search_queries_100.json `
  --output-dir ..\docs\evaluation\generated\rust `
  --limit 10
```

Outputs:

- `generated/rust/search_queries_100_resolved.json`
- `generated/rust/retrieval_results.json`
- `generated/rust/retrieval_metrics.csv`
- `generated/rust/retrieval_report.md`
- `generated/rust/retrieval_report.html`

Full suite outputs:

- `generated/rust-suite/retrieval_report.md`
- `generated/rust-suite/retrieval_report.html`
- `generated/rust-suite/rag_report.md`
- `generated/rust-suite/rag_report.html`
- `generated/rust-suite/recommendation_offline_report.md`
- `generated/rust-suite/recommendation_offline_report.html`
- `generated/rust-suite/load_test_report.md`
- `generated/rust-suite/load_test_report.html`
- `generated/rust-suite/index.html`

The static dashboard can optionally call a local Ollama model such as `qwen3:4b`, `qwen3:7b`, or `qwen3:14b` to analyze the reports. It can then use `qwen2.5-coder:7b` to generate a standalone HTML report preview and download. Browser-side calls to `http://localhost:11434/api/chat` may require Ollama CORS/origin configuration.

Recommended dashboard launch:

```powershell
.\scripts\serve_readseek_report.ps1
```

Then open `http://127.0.0.1:8765/index.html`. Direct `file://` opening can display the static charts, but local AI analysis may be blocked by browser origin rules.

## Metrics

Retrieval:

- Precision@5
- Recall@5
- MRR
- NDCG@10
- Average latency

RAG:

- Answerable rate
- Evidence hit rate
- Evidence recall
- Citation coverage
- Latency
- Manual relevance/completeness/citation/hallucination scores

Recommendation:

- Precision@10
- Recall@10
- NDCG@10

Load test:

- Success rate
- Average latency
- P50/P90/P95/P99 latency
- Throughput

## Thesis Note

These scripts produce real measurements from the running ReadSeek system. For final thesis writing, clearly distinguish:

- demo catalog evaluation based on the current 373-book ReadSeek catalog;
- public-dataset offline recommendation evaluation if you add Goodreads-style interaction data;
- manual RAG answer scoring, which should be reviewed and filled by a human before citing final quality claims.
