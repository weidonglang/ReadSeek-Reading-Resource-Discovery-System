# ReadSeek Retrieval Evaluation

- Generated at: 2026-06-06T08:31:07
- Query count: 3
- Metric focus: Precision@5, Recall@5, MRR, NDCG@10, average latency

| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg latency ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 157.5 |
| vector | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.3473 | 170.4 |
| hybrid | 3/3 | 0.3333 | 0.1389 | 1.0000 | 0.2980 | 157.2 |
| hybrid_reranker | 3/3 | 0.2667 | 0.1111 | 1.0000 | 0.3120 | 960.6 |