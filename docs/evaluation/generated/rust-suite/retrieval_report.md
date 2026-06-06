# ReadSeek Rust Retrieval Evaluation

- Generated at: 2026-06-06T09:36:06
- Query count: 100
- Tool: readseek-bench-rs 0.1.0
- Metric focus: Precision@5

| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg ms | P95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 100/100 | 0.3080 | 0.1904 | 0.6440 | 0.3568 | 42.6 | 78.8 |
| hybrid | 100/100 | 0.3460 | 0.2017 | 0.7043 | 0.3922 | 110.9 | 142.9 |
| hybrid_reranker | 100/100 | 0.5040 | 0.2630 | 0.9167 | 0.5035 | 266.2 | 316.9 |
| vector | 100/100 | 0.4940 | 0.2536 | 0.8884 | 0.5078 | 62.0 | 73.3 |