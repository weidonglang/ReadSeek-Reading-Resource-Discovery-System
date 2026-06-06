# ReadSeek Rust Retrieval Evaluation

- Generated at: 2026-06-06T09:16:44
- Query count: 3
- Tool: readseek-bench-rs 0.1.0
- Metric focus: Precision@5

| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg ms | P95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 34.6 | 42.2 |
| hybrid | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 112.8 | 144.5 |
| hybrid_reranker | 3/3 | 0.2667 | 0.1111 | 1.0000 | 0.3120 | 249.5 | 265.2 |
| vector | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.3473 | 134.3 | 279.8 |