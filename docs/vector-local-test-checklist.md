# Vector Retrieval Local Test Checklist

## 1. Start dependencies

```powershell
docker compose up -d db elasticsearch
```

## 2. Start local AI service

```powershell
.\start-ai-service.bat
```

Optional health check:

```powershell
Invoke-RestMethod -Uri http://127.0.0.1:8001/health
```

## 3. Start backend with AI mode enabled

```powershell
.\start-dev.bat -Mode app -WithAi
```

Or start everything together:

```powershell
.\start-dev.bat -WithAi
```

## 4. Rebuild the book search index

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-search-index.ps1
```

Expected:

- indexedCount is returned
- no backend exception is thrown

## 5. Verify hybrid retrieval response

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-hybrid-search.ps1 -Query "classic romance"
```

Expected:

- `strategy` contains `hybrid-v2`
- `returnedCount` is greater than `0`

## 6. Browser checks

Open:

```text
http://localhost:8010/book-service/ui/books.html
```

Verify:

- text-only input uses smart search mode
- search summary shows strategy / intent
- results render normally
- advanced filters still switch back to paginated filter mode

## 7. Suggested manual queries

- `Pride and Prejudice`
- `Jane Austen`
- `classic romance`
- `romantic classic novel`
- `爱情小说`

## 8. Notes

- The current AI service uses a deterministic `hash-bow` embedding backend.
- This stage validates the vector retrieval path and integration flow, not final semantic quality.
- If AI mode is disabled, search should fall back safely to BM25 and exact-db retrieval.
