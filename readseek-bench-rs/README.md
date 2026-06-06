# readseek-bench-rs

Rust CLI benchmark companion for ReadSeek. It does not replace the Python scripts in `scripts/`; it reuses the same evaluation data and the same ReadSeek HTTP APIs to provide a stricter, distributable CLI implementation.

Current scope:

- four-way retrieval evaluation;
- RAG evidence evaluation;
- recommendation offline/case evaluation;
- lightweight API load testing;
- static HTML dashboard with optional local Ollama analysis;
- shared `search_queries_100.json` input;
- login with `.env` admin credentials;
- catalog-derived relevance resolution;
- Precision@K, Recall@K, MRR, NDCG@10, average latency, P95 latency;
- JSON, CSV, Markdown, and HTML report output.

## Run

Start ReadSeek dependencies, backend, and AI service first, then rebuild the search index.

From the repository root:

```powershell
.\scripts\run_readseek_bench_rs.ps1
```

Run the full Rust suite:

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

Other subcommands:

```powershell
cargo run --release -- rag `
  --env-file ..\.env `
  --questions ..\docs\evaluation\rag_questions_60.json `
  --output-dir ..\docs\evaluation\generated\rust-suite `
  --mode standard `
  --provider ollama `
  --limit 8

cargo run --release -- recommendation `
  --env-file ..\.env `
  --queries ..\docs\evaluation\search_queries_100.json `
  --output-dir ..\docs\evaluation\generated\rust-suite

cargo run --release -- load `
  --env-file ..\.env `
  --output-dir ..\docs\evaluation\generated\rust-suite `
  --scenarios search,recommendation `
  --requests 100 `
  --concurrency 8

cargo run --release -- dashboard `
  --input-dir ..\docs\evaluation\generated\rust-suite `
  --output ..\docs\evaluation\generated\rust-suite\index.html `
  --ollama-model qwen3:7b `
  --coder-model qwen2.5-coder:7b
```

## Outputs

- `retrieval_results.json`
- `retrieval_metrics.csv`
- `retrieval_report.md`
- `retrieval_report.html`
- `search_queries_100_resolved.json`
- `rag_report.md`
- `rag_report.html`
- `recommendation_offline_report.md`
- `recommendation_offline_report.html`
- `load_test_report.md`
- `load_test_report.html`
- `index.html`

The dashboard is a static HTML file. It can use a smaller local model such as `qwen3:4b` or `qwen3:7b` for analysis, then use `qwen2.5-coder:7b` to generate a standalone HTML report preview and download. If the browser blocks `http://localhost:11434/api/chat`, start Ollama and configure local origins, for example by setting `OLLAMA_ORIGINS=*` before restarting Ollama.

Recommended way to open the dashboard:

```powershell
.\scripts\serve_readseek_report.ps1
```

Then open:

```text
http://127.0.0.1:8765/index.html
```

Opening `index.html` directly through `file://` is fine for reading the charts, but browser security rules can block local model requests from file origins.

## Why This Exists

The Python scripts remain useful for fast iteration and broader experiment coverage. This Rust CLI is useful for the project report because it demonstrates a separate engineering tool with predictable performance, typed data handling, reproducible command-line behavior, and report generation suitable for repeated benchmark runs.
