# Minimal Python AI Service

This directory contains a lightweight local AI service used by the Java backend embedding provider.

## What it does

- `GET /health`
- `POST /embed`

The current implementation uses a deterministic hashed bag-of-words embedding backend:

- no external model download is required
- no third-party Python dependency is required
- dimensions default to `384`
- the service is suitable for local development and integration testing

It is not a final semantic model. It is a transition layer so the backend vector-retrieval path can be exercised end-to-end before introducing a heavier embedding model.

## Run

```powershell
python ai-service/server.py
```

Optional arguments:

```powershell
python ai-service/server.py --host 127.0.0.1 --port 8001 --dimensions 384 --model hash-bow-384
```

## Health check

```powershell
Invoke-RestMethod -Uri http://127.0.0.1:8001/health
```

## Embed example

```powershell
$body = @{
  text = "classic romance novel"
  model = "hash-bow-384"
  inputType = "query"
} | ConvertTo-Json

Invoke-RestMethod `
  -Method Post `
  -Uri http://127.0.0.1:8001/embed `
  -ContentType 'application/json' `
  -Body $body
```

## Java-side enablement

To let the Spring Boot backend call this service, set:

```text
LIBRARY_SEARCH_EMBEDDING_ENABLED=true
LIBRARY_SEARCH_VECTOR_ENABLED=true
LIBRARY_SEARCH_EMBEDDING_BASE_URL=http://127.0.0.1:8001
LIBRARY_SEARCH_EMBEDDING_DIMENSIONS=384
```

Then rebuild the book search index so document embeddings are written:

```text
POST /api/search/index/books/rebuild
```
