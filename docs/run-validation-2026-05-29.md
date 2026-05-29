# ReadSeek Local Run Validation - 2026-05-29

## Runtime

- PostgreSQL container: `readseek-db`, healthy, `localhost:5043`
- Redis container: `readseek-redis`, healthy, `localhost:6379`
- Elasticsearch container: `readseek-search`, healthy, `localhost:9200`
- Spring Boot backend: `http://localhost:8010/readseek-service`, health `UP`
- Swagger UI: `http://localhost:8010/readseek-service/swagger-ui/index.html`, HTTP 200
- AI service: `http://127.0.0.1:8001`
  - embedding backend: `bge-m3`
  - embedding model: `BAAI/bge-m3`
  - embedding dimensions: `1024`
  - reranker backend: `bge-reranker-v2-m3`
  - reranker model: `BAAI/bge-reranker-v2-m3`
  - reranker loaded: `true`

## Index Rebuild

Command:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-search-index.ps1
```

Result:

- success: `true`
- indexed count: `373`
- Elasticsearch index: `readseek-resource-search-v1`
- document count: `373`
- vector field: `embedding`
- vector type: `dense_vector`
- dimensions: `1024`
- similarity: `cosine`

## Hybrid Search Samples

| Query | Intent | Strategy | Fallback | First hit | First match type |
| --- | --- | --- | --- | --- | --- |
| `Pride and Prejudice` | `KEYWORD` | `hybrid-v3(exact-db+bm25+vector+reranker)` | `false` | `Pride and Prejudice` | `EXACT_DB` |
| `science fiction with big ideas but easy to read` | `NATURAL_LANGUAGE` | `hybrid-v3(exact-db+bm25+vector+reranker)` | `false` | `The War of the Worlds` | `VECTOR+RERANK` |
| `books like The Alchemist about personal growth` | `KEYWORD` | `hybrid-v3(exact-db+bm25+vector+reranker)` | `false` | `The Lion, the Witch and the Wardrobe` | `BM25+RERANK` |
| `recommend an easy fantasy book for beginners` | `NATURAL_LANGUAGE` | `hybrid-v3(exact-db+bm25+vector+reranker)` | `false` | `The Lord of the Rings` | `VECTOR+RERANK` |
| `psychology book for beginners` | `KEYWORD` | `hybrid-v3(exact-db+bm25+vector+reranker)` | `false` | `The Principles of Psychology (Vol. 1&2)` | `BM25+RERANK` |
| `想找类似三体但更容易读的英文科幻小说` | `NATURAL_LANGUAGE` | `hybrid-v3(exact-db+bm25+vector+reranker)` | `false` | `Harry Potter and the Chamber of Secrets` | `VECTOR+RERANK` |
| `适合入门的心理学书 不要太学术` | `NATURAL_LANGUAGE` | `hybrid-v3(exact-db+bm25+vector+reranker)` | `false` | `The Interpretation Of Dreams` | `VECTOR+RERANK` |

## Notes

- A short keyword query, `classic romance`, returned `hybrid-v2(exact-db+bm25+vector)` in one script-level run. Other keyword and natural-language queries used `hybrid-v3`.
- Spring Boot's built-in Elasticsearch health indicator was disabled for local startup because it misdecoded the Elasticsearch 8.18.x cluster health response. Elasticsearch itself was green, and search APIs were verified directly.
