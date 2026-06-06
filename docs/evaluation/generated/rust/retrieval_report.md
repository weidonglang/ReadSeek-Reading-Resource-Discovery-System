# ReadSeek Rust Retrieval Evaluation

- Generated at: 2026-06-06T09:19:26
- Query count: 100
- Tool: readseek-bench-rs 0.1.0
- Metric focus: Precision@5

| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg ms | P95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 100/100 | 0.3080 | 0.1904 | 0.6440 | 0.3568 | 42.8 | 75.0 |
| hybrid | 100/100 | 0.3460 | 0.2017 | 0.7043 | 0.3922 | 110.2 | 143.7 |
| hybrid_reranker | 100/100 | 0.5040 | 0.2630 | 0.9167 | 0.5035 | 264.4 | 308.9 |
| vector | 100/100 | 0.4940 | 0.2536 | 0.8884 | 0.5078 | 64.3 | 75.3 |