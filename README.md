# ReadSeek: Reading Resource Discovery System

# 面向阅读资源发现的自然语言混合检索、证据驱动问答与可解释推荐关键技术研究与系统实现。

ReadSeek is a Java-based reading-resource discovery system. It uses books as the current demonstration and experimental resource type, while the system positioning is broader than a traditional library or book management system.

Current status:
- Search, recommendation, borrowing, reservation, rating, and authentication flows are available
- Frontend demo pages are included under `src/main/resources/static/ui`
- Elasticsearch-based search is integrated
- `hybrid-v2` search path is available: exact match + BM25 + vector
- A minimal local Python AI service is included for embedding integration testing

This repository is suitable for:
- Graduation project demo
- Java Web coursework
- Backend portfolio project
- A base system for further work on hybrid retrieval, RAG, and explainable recommendation

This is a local-development and demo-oriented version, not a production-hardened release.

## Features

### Core business
- User registration, login, refresh token flow, and role-based access control
- Reading-resource listing, detail, rating, borrowing, return, renewal, and reservation
- Recommendation overview, popular resources, preference-based recommendation, and collaborative filtering
- Behavior logging for search, detail click, and recommendation click

### Search
- PostgreSQL exact matching
- Elasticsearch BM25 full-text retrieval
- Hybrid search API for keyword and natural-language queries
- Chinese query expansion rules for common categories and author aliases
- Automatic resource search index sync on create, update, and logical delete

### Frontend
- Home dashboard
- Search workspace
- Resource detail page
- Recommendation page
- Borrowing page
- Profile page
- Admin page

## Tech Stack

- Java 17
- Spring Boot 3.5.7
- Spring Web
- Spring Security
- Spring Data JPA
- Spring Data Elasticsearch
- PostgreSQL
- Elasticsearch 8
- Liquibase
- MapStruct
- Lombok
- Swagger UI / springdoc OpenAPI
- Python 3 for the local AI service
- Docker / Docker Compose

## Repository Structure

```text
src/main/java/com/weidonglang/readseek/
  ReadSeekApplication.java
  config/
  controller/
  dao/
  dto/
  entity/
  enums/
  exception/
  manager/
  recommender/
  repository/
  search/
  security/
  service/
  transformer/

src/main/resources/
  application.properties
  db/
  static/ui/

ai-service/
docs/
scripts/
```

## Quick Start

### Option A: One-click local startup

On Windows, double-click:

```text
start-readseek.bat
```

Or run it from PowerShell:

```powershell
.\start-readseek.bat
```

This starts:
- PostgreSQL on `localhost:5043`
- Elasticsearch on `localhost:9200`
- Spring Boot on `http://localhost:8010/readseek-service`
- Local AI service on `http://127.0.0.1:8001`
- Browser page `http://localhost:8010/readseek-service/ui/login.html`

Useful switches:

```powershell
.\start-readseek.bat -NoAi
.\start-readseek.bat -NoBrowser
.\start-readseek.bat -StartPage home
.\start-readseek.bat -StartPage search
.\start-readseek.bat -StartPage swagger
.\start-readseek.bat -DbPassword 20041117
.\start-readseek.bat -JavaHome "C:\Users\WDL\.jdks\ms-17.0.18"
```

If startup or login looks abnormal, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\diagnose-readseek.ps1
```

### Option B: Manual local development flow

Open two terminals in the project root.

Terminal 1:

```powershell
.\start-ai-service.bat
```

Terminal 2:

```powershell
.\start-dev.bat -WithAi
```

This starts:
- PostgreSQL on `localhost:5043`
- Elasticsearch on `localhost:9200`
- Spring Boot on `http://localhost:8010/readseek-service`
- Local AI service on `http://127.0.0.1:8001`

Swagger UI:

```text
http://localhost:8010/readseek-service/swagger-ui/index.html
```

Frontend search page:

```text
http://localhost:8010/readseek-service/ui/books.html
```

### Option C: Docker app container

```powershell
docker compose up --build
```

This starts the app, PostgreSQL, and Elasticsearch inside Docker.

## Default Accounts and Local Config

Default bootstrap admin:
- Email: `admin@booknook.local`
- Password: `Admin123!`

Default Docker database:
- Database: `book_recommendation_system`
- Username: `postgres`
- Password: `postgres`

Important:
- If your local PostgreSQL volume already contains old data, your actual password may be different
- In that case, override the backend connection password when starting locally

For example:

```powershell
.\start-dev.bat -WithAi -DbPassword 20041117
```

## Search and Vector Testing

### Rebuild the search index

Run after startup:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-search-index.ps1
```

Expected result:
- successful login
- `Book search index rebuilt successfully.`
- `indexedCount > 0`

### Verify hybrid search

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-hybrid-search.ps1 -Query "Pride and Prejudice"
```

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-hybrid-search.ps1 -Query "classic romance"
```

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-hybrid-search.ps1 -Query "Jane Austen"
```

When AI mode is enabled and the index has been rebuilt, the strategy should show:

```text
hybrid-v2(exact-db+bm25+vector)
```

Resource-oriented API aliases:

```text
GET  /api/resources/{resourceId}
POST /api/resources/search
GET  /api/resources/recommended
GET  /api/resources/recommendations/popular
GET  /api/resources/recommendations/overview
GET  /api/resources/recommendations/similar/{resourceId}
GET  /api/resources/categories
GET  /api/search/resources?q=...&limit=...
GET  /api/search/resources/bm25?q=...&limit=...
POST /api/search/index/resources/rebuild
```

The older `/api/book/...` and `/api/search/books...` endpoints are still kept for compatibility.

More detailed local testing steps are in:

- [docs/vector-local-test-checklist.md](docs/vector-local-test-checklist.md)

## Python AI Service

The current local AI service is intentionally minimal.

It provides:
- `GET /health`
- `POST /embed`

Current embedding backend:
- deterministic `hash-bow`
- intended for integration and workflow testing
- not a final semantic model

Details:
- [ai-service/README.md](ai-service/README.md)
- [docs/vector-retrieval-ai-service-plan.md](docs/vector-retrieval-ai-service-plan.md)

## Current Research-Oriented Status

Implemented now:
- exact match
- BM25 retrieval
- hybrid search API
- vector retrieval skeleton and integration
- local embedding service integration
- Chinese query expansion for some common natural-language cases

Not finished yet:
- real production-grade embedding model
- final retrieval quality tuning
- RAG evidence retrieval and answer generation
- benchmark-quality retrieval evaluation

Terminology note:
- Public-facing product terminology uses "reading resource" and "resource discovery"
- Current sample data and some internal class names still use "book" for compatibility with the existing database and implemented business flow
- Resource-oriented API aliases and search DTO aliases have been added
- Full database and Liquibase renaming is intentionally deferred

## Known Limitations

- The current local embedding backend is a placeholder, so semantic quality is limited
- Natural-language retrieval works as a demo path, but ranking quality still needs improvement
- Configuration defaults are development-oriented
- The project is suitable for demo and coursework use, not direct production deployment

## Development Notes

When to restart what:
- If you change Java backend code: restart the backend
- If you change Python AI service code: restart the AI service
- If you change index structure or embedding write logic: restart backend and rebuild the search index
- If you only change frontend static resources: hard refresh the page, and restart backend only if needed

Useful commands:

```powershell
.\start-readseek.bat
```

```powershell
.\start-dev.bat -WithAi
```

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-search-index.ps1
```

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-hybrid-search.ps1 -Query "classic romance"
```

## Roadmap

Near-term priorities:
1. Replace the placeholder embedding backend with a real local embedding model
2. Improve hybrid retrieval quality and query rewrite rules
3. Build RAG evidence retrieval
4. Add answer generation with citation
5. Add evaluation for retrieval, recommendation, and QA

## Screenshots

If the image assets exist in your branch, you can use:

- `docs/images/home-dashboard.png`
- `docs/images/search-workspace.png`
- `docs/images/book-detail.png`
- `docs/images/recommendation-shelf.png`
- `docs/images/borrowing-records.png`
- `docs/images/swagger-ui.png`

## License

See the repository `LICENSE` file if present.
