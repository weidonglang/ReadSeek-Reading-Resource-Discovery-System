# ReadSeek Rust Retrieval Evaluation

- Generated at: 2026-06-06T09:33:54
- Query count: 3
- Tool: readseek-bench-rs 0.1.0
- Metric focus: Precision@5

| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg ms | P95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 34.7 | 36.8 |
| hybrid | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 118.1 | 121.2 |
| hybrid_reranker | 3/3 | 0.2667 | 0.1111 | 1.0000 | 0.3120 | 281.9 | 289.5 |
| vector | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.3473 | 120.9 | 223.8 |