# ReadSeek Local AI Service

This directory contains the local embedding and reranking service used by the Java backend.

There are two implementations in this directory. They are intentionally kept for different development scenarios.

| File | Role | Model | Dimensions | Rerank | Recommended use |
| --- | --- | --- | ---: | --- | --- |
| `server_bge_m3.py` | Main semantic AI service | `BAAI/bge-m3` + `BAAI/bge-reranker-v2-m3` | 1024 | Yes | Normal ReadSeek search, RAG, benchmark, and demo |
| `server.py` | Lightweight fallback service | deterministic hashed bag-of-words | 384 | No | Fast local smoke tests when model download is unavailable |

For the final ReadSeek demo and benchmark reports, use `server_bge_m3.py`.

## Main Service: BGE-M3 + Reranker

Endpoints:

- `GET /health`
- `POST /embed`
- `POST /rerank`

Install dependencies:

```powershell
.\.venv-ai\Scripts\python.exe -m pip install -r ai-service\requirements-bge-m3.txt
```

Run:

```powershell
.\.venv-ai\Scripts\python.exe ai-service\server_bge_m3.py --host 127.0.0.1 --port 8001
```

The project also provides a launcher:

```powershell
.\start-bge-m3-ai-service.bat
```

Backend configuration:

```text
LIBRARY_SEARCH_EMBEDDING_ENABLED=true
LIBRARY_SEARCH_VECTOR_ENABLED=true
LIBRARY_SEARCH_EMBEDDING_BASE_URL=http://127.0.0.1:8001
LIBRARY_SEARCH_EMBEDDING_MODEL=BAAI/bge-m3
LIBRARY_SEARCH_EMBEDDING_DIMENSIONS=1024
LIBRARY_SEARCH_RERANKER_ENABLED=true
LIBRARY_SEARCH_RERANKER_BASE_URL=http://127.0.0.1:8001
LIBRARY_SEARCH_RERANKER_MODEL=BAAI/bge-reranker-v2-m3
```

After switching embedding dimensions or service implementation, rebuild the resource search index:

```text
POST /api/search/index/resources/rebuild
```

## Lightweight Fallback: hash-bow

`server.py` is kept for quick integration tests and machines that cannot download BGE models.

Run:

```powershell
.\.venv-ai\Scripts\python.exe ai-service\server.py --host 127.0.0.1 --port 8001 --dimensions 384 --model hash-bow-384
```

Backend configuration for this fallback:

```text
LIBRARY_SEARCH_EMBEDDING_DIMENSIONS=384
LIBRARY_SEARCH_RERANKER_ENABLED=false
```

This fallback is deterministic and useful for exercising the vector retrieval code path, but it is not the semantic model used for the final ReadSeek benchmark results.

## Health Check

```powershell
Invoke-RestMethod -Uri http://127.0.0.1:8001/health
```

## Embed Example

```powershell
$body = @{
  text = "classic romance novel"
  model = "BAAI/bge-m3"
  inputType = "query"
} | ConvertTo-Json

Invoke-RestMethod `
  -Method Post `
  -Uri http://127.0.0.1:8001/embed `
  -ContentType 'application/json' `
  -Body $body
```

## Rerank Example

```powershell
$body = @{
  query = "适合入门的爱情小说"
  passages = @(
    "Pride and Prejudice is a classic romantic novel by Jane Austen.",
    "The Art of Computer Programming is a computer science classic."
  )
  model = "BAAI/bge-reranker-v2-m3"
} | ConvertTo-Json

Invoke-RestMethod `
  -Method Post `
  -Uri http://127.0.0.1:8001/rerank `
  -ContentType 'application/json' `
  -Body $body
```
