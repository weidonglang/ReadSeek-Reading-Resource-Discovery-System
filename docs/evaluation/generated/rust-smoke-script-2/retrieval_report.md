# ReadSeek Rust Retrieval Evaluation

- Generated at: 2026-06-06T09:18:31
- Query count: 3
- Tool: readseek-bench-rs 0.1.0
- Metric focus: Precision@5

| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg ms | P95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 31.3 | 34.0 |
| hybrid | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 96.2 | 104.8 |
| hybrid_reranker | 3/3 | 0.2667 | 0.1111 | 1.0000 | 0.3120 | 247.6 | 257.6 |
| vector | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.3473 | 120.8 | 251.0 |