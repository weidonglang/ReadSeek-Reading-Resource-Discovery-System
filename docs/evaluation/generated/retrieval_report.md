# ReadSeek Retrieval Evaluation

- Generated at: 2026-06-06T08:33:13
- Query count: 100
- Metric focus: Precision@5, Recall@5, MRR, NDCG@10, average latency

| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg latency ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 100/100 | 0.3080 | 0.1904 | 0.6440 | 0.3568 | 59.5 |
| vector | 100/100 | 0.4940 | 0.2536 | 0.8884 | 0.5078 | 79.8 |
| hybrid | 100/100 | 0.3460 | 0.2017 | 0.7043 | 0.3922 | 125.7 |
| hybrid_reranker | 100/100 | 0.5040 | 0.2630 | 0.9167 | 0.5035 | 287.3 |