# ReadSeek Reading Resource Discovery System

ReadSeek is a Spring Boot based reading-resource discovery system. It combines a traditional library workflow with hybrid retrieval, evidence-grounded RAG question answering, and explainable recommendations.

当前版本已经完成项目开发主线：图书业务闭环、混合检索、BGE-M3 向量召回、BGE reranker、Ollama/Qwen 本地 LLM RAG、在线 AI Provider 预留接口、可解释推荐、推荐/问答行为日志和后台统计。

## Core Features

- User registration, login, JWT authentication, role-based admin access.
- Book, author, category, publisher, tag, inventory, borrowing, renewal, return, and reservation management.
- Hybrid search strategy:
  - PostgreSQL exact match
  - Elasticsearch BM25
  - BGE-M3 dense vector retrieval
  - exact/BM25/vector hybrid merge
  - BGE reranker final ranking
  - visible query intent, source labels, ranking reasons, reranker markers
- Evidence-grounded RAG QA:
  - `/api/qa/evidence`
  - fast / standard / expert modes
  - local Ollama provider
  - OpenAI-compatible online API provider placeholder
  - retrieved evidence + rerank + citation-based answer
  - refusal when evidence is insufficient
  - deterministic fallback when LLM is unavailable
- Explainable recommendations:
  - popular, preference, collaborative, similar, same-author, same-category, cold-start shelves
  - recommendation source, reason type, strategy, rank position
  - exposure, click, and feedback logging
  - recommendation CTR and feedback-rate analytics
- Admin analytics:
  - search keywords
  - popular categories/authors/tags/publishers
  - clicked and borrowed books
  - recommendation funnel
  - QA request, answerable/refusal count, citation clicks, average latency

## Tech Stack

- Java 17
- Spring Boot 3.5.x
- Spring Security + JWT
- Spring Data JPA
- PostgreSQL
- Elasticsearch 8
- Redis
- Liquibase
- Lombok / MapStruct
- Static HTML/CSS/JavaScript frontend
- Python 3.11 local AI service
- FlagEmbedding / BGE-M3 / BGE reranker
- Ollama local LLM
- Docker Compose

## Runtime Architecture

```text
Browser UI
  -> Spring Boot API :8010/readseek-service
      -> PostgreSQL :5043
      -> Redis :6379
      -> Elasticsearch :9200
      -> Python AI service :8001
          -> BGE-M3 embedding
          -> BGE reranker
      -> Ollama :11434
          -> qwen2.5:7b / qwen3:8b / qwen3:14b
      -> Optional online OpenAI-compatible API
```

## Prerequisites

- Windows 10/11
- Docker Desktop
- JDK 17
- Python 3.11
- Ollama for Windows
- At least 20 GB free disk space for local LLM models

Recommended local models:

```powershell
ollama pull qwen2.5:7b
ollama pull qwen3:8b
ollama pull qwen3:14b
```

`qwen3:8b` is the default RAG model. `qwen3:14b` is used only for expert mode.

## Quick Start

From the project root:

```powershell
cd E:\javacode\new-book-recommendation-system
.\start-readseek.bat
```

If you prefer starting pieces manually:

```powershell
docker compose up -d

.\.venv-ai\Scripts\activate
.\start-bge-m3-ai-service.bat

.\mvnw-jdk17.cmd spring-boot:run
```

Open:

- Frontend: `http://localhost:8010/readseek-service/ui/login.html`
- Swagger UI: `http://localhost:8010/readseek-service/swagger-ui/index.html`
- AI health: `http://127.0.0.1:8001/health`
- Ollama health: `http://localhost:11434/api/tags`

Default local admin account:

```text
Email: admin@booknook.local
Password: Admin123!
```

## Local AI Service

The Python AI service provides embedding and reranking:

- embedding model: `BAAI/bge-m3`
- reranker model: `BAAI/bge-reranker-v2-m3`
- service URL: `http://127.0.0.1:8001`

Main backend config:

```properties
library.search.embedding.enabled=true
library.search.embedding.base-url=http://127.0.0.1:8001
library.search.embedding.model=BAAI/bge-m3
library.search.embedding.dimensions=1024

library.search.reranker.enabled=true
library.search.reranker.base-url=http://127.0.0.1:8001
library.search.reranker.model=BAAI/bge-reranker-v2-m3
```

## RAG LLM Configuration

Default local LLM provider:

```env
LLM_PROVIDER=ollama
OLLAMA_BASE_URL=http://localhost:11434
OLLAMA_CHAT_ENDPOINT=http://localhost:11434/api/chat
OLLAMA_STREAM=false
OLLAMA_THINK=false

RAG_DEFAULT_MODE=standard
RAG_FAST_MODEL=qwen2.5:7b
RAG_STANDARD_MODEL=qwen3:8b
RAG_EXPERT_MODEL=qwen3:14b
```

Mode defaults:

```text
fast:
  model: qwen2.5:7b
  top_k: 5
  rerank_top_k: 3
  timeout: 60s

standard:
  model: qwen3:8b
  top_k: 10
  rerank_top_k: 5
  timeout: 120s

expert:
  model: qwen3:14b
  top_k: 20
  rerank_top_k: 8
  timeout: 240s
```

Optional online AI provider. It uses an OpenAI-compatible `/chat/completions` API and is disabled by default:

```env
ONLINE_AI_ENABLED=true
ONLINE_AI_BASE_URL=https://api.example.com/v1
ONLINE_AI_CHAT_COMPLETIONS_ENDPOINT=/chat/completions
ONLINE_AI_API_KEY=your_api_key
ONLINE_AI_MODEL=gpt-4o-mini
LLM_PROVIDER=online
```

The online provider is intentionally generic. It can be wired to OpenAI-compatible services by setting the base URL, API key, and model.

## Important API Endpoints

Search:

```text
GET  /api/search/books?q=...&limit=10
POST /api/resources/search
POST /api/search/rebuild-index
```

Evidence QA:

```text
POST /api/qa/evidence
POST /api/qa/citation-click
GET  /api/qa/analytics
GET  /api/qa/events/recent
```

Recommendation:

```text
GET  /api/resources/recommendations/overview
GET  /api/resources/{id}/recommendations/similar
POST /api/recommendation-events/click
POST /api/recommendation-events/feedback
GET  /api/recommendation-events/analytics
GET  /api/recommendation-events/recent
```

Behavior analytics:

```text
POST /api/behavior-log
GET  /api/behavior-log/dashboard
GET  /api/behavior-log/searches/top-keywords
GET  /api/behavior-log/books/top-clicked
GET  /api/behavior-log/books/top-borrowed
```

## RAG Request Example

```json
{
  "question": "想看关于个人成长的书，应该从哪本开始？",
  "limit": 10,
  "mode": "standard",
  "provider": "ollama"
}
```

Response includes:

- `answer`
- `answerable`
- `answerMode`
- `ragMode`
- `llmProvider`
- `model`
- `generationBackend`
- `evidence`
- `citations`
- `confidence`
- `retrievalLatencyMs`
- `generationLatencyMs`
- `totalLatencyMs`
- `llmFallbackApplied`

## Testing

Run the full automated test suite:

```powershell
.\mvnw-jdk17.cmd test
```

Current result:

```text
Tests run: 92
Failures: 0
Errors: 0
Skipped: 0
```

The tests cover controllers, search, RAG answer generation, QA logging, recommendation events, recommendation analytics, borrowing, reservation, rating, security rate limiting, and application context startup.

## Smoke Test Checklist

After startup:

1. Log in as admin.
2. Open the search page and run a natural-language query.
3. Confirm search results show source, reason, strategy, and reranker marker.
4. Open the QA page and ask a question in `standard` mode with provider `Ollama`.
5. Confirm the answer has citations and evidence cards.
6. Click a QA citation and verify admin analytics records a citation click.
7. Open recommendations and click a recommendation.
8. Send interested/not-interested feedback.
9. Open admin analytics and verify recommendation funnel and QA quality panels.
10. Stop Ollama and ask again; the answer should fall back instead of crashing.

## Troubleshooting

Container name conflict:

```powershell
docker ps -a
docker rm -f readseek-db readseek-search readseek-redis
docker compose up -d
```

Ollama model missing:

```powershell
ollama pull qwen3:8b
```

AI service slow on first run:

- The first BGE-M3 and reranker startup downloads model files.
- Keep the cache at `C:\Users\<user>\.cache\readseek\huggingface`.
- Windows symlink warnings from Hugging Face are harmless, but Developer Mode can reduce duplicate cache storage.

Elasticsearch index stale:

```powershell
.\scripts\rebuild-search-index.ps1
```

Run backend tests only:

```powershell
.\mvnw-jdk17.cmd test
```

## Project Status

Development status: feature-complete for the current ReadSeek graduation/course-project scope.

Completed:

- Core library workflows
- Hybrid retrieval
- Vector retrieval
- Reranker
- RAG QA with local LLM and fallback
- Online AI Provider interface
- Explainable recommendation
- Recommendation exposure/click/feedback logs
- QA request/citation logs
- Admin analytics
- Automated regression tests
- Local startup documentation

Remaining work outside development scope:

- Formal experiment datasets and reports
- Thesis writing
- Defense PPT
- Optional deployment hardening for production environments
