<<<<<<< HEAD
# ReadSeek

> AI 驱动的阅读资源发现系统：图书馆藏管理、混合检索、向量召回、重排序、RAG 问答、智能找书、可解释推荐、行为分析、离线评测与 Rust 基准测试工具。

ReadSeek 不是传统图书管理系统，而是一个面向“阅读资源发现”的完整 AI 应用。系统以 Spring Boot 后端为核心，结合 PostgreSQL、Elasticsearch、Redis、BGE-M3 向量模型、BGE reranker、本地 Ollama 大模型、Vue 3 前端和 Rust 评测 CLI，实现从馆藏数据补全、搜索推荐、RAG 问答到评测报告展示的完整闭环。

当前版本已经完成：

- 373 本演示馆藏的 AI 元数据补全与搜索索引重建。
- 精确匹配、BM25、BGE-M3 向量召回、混合召回、BGE reranker 四路检索。
- 基于馆藏证据的 RAG QA 和 AI 阅读助手。
- 智能找书、自然语言推荐、引用证据卡片、推荐理由和限制说明。
- 推荐货架、相似推荐、用户行为日志、点击和反馈分析。
- 100 条检索评测、60 个 RAG 问题集、推荐离线评测、API 压测。
- Rust 版 `readseek-bench-rs` 基准测试工具。
- 静态 HTML 评测 Dashboard，可调用本地模型分析并使用 `qwen2.5-coder:7b` 生成独立 HTML 报告。

## Screenshots

| Home | Search | Recommendation |
| --- | --- | --- |
| ![Home dashboard](home-dashboard.png) | ![Search workspace](search-workspace.png) | ![Recommendation shelf](recommendation-shelf.png) |

| Book Detail | Borrowing Records | Swagger |
| --- | --- | --- |
| ![Book detail](book-detail.png) | ![Borrowing records](borrowing-records.png) | ![Swagger UI](swagger-ui.png) |
=======
# ReadSeek 阅读资源发现系统 / ReadSeek Reading Resource Discovery System

ReadSeek 是一个基于 Spring Boot 的阅读资源发现系统。它在传统图书馆业务流程基础上，集成了混合检索、证据驱动 RAG 问答、可解释推荐和行为分析能力。

ReadSeek is a Spring Boot based reading-resource discovery system. It combines a traditional library workflow with hybrid retrieval, evidence-grounded RAG question answering, explainable recommendations, and behavior analytics.
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

---

<<<<<<< HEAD
### 1. Hybrid Retrieval

ReadSeek 的检索链路不是单一关键词搜索，而是完整的多阶段召回与排序：

- PostgreSQL 精确匹配和基础字段兜底。
- Elasticsearch BM25 全文检索。
- BGE-M3 embedding 向量召回。
- exact / BM25 / vector 候选合并。
- BGE reranker 重排序。
- 查询意图识别、候选数、召回来源、是否 fallback、排序理由可视化。

已暴露的对比接口：

```text
GET /api/search/resources/bm25
GET /api/search/resources/vector
GET /api/search/resources/hybrid-basic
GET /api/search/resources
```

### 2. Evidence-grounded RAG QA

RAG 问答严格基于当前馆藏元数据、简介、标签、分类、作者和检索证据：

- `fast / standard / expert` 三种模式。
- 引用编号、证据卡片、证据来源、reranker 标识。
- answerable 判断、limitations、follow-up suggestions。
- 检索耗时、生成耗时、总耗时记录。
- 证据不足时不编造馆藏外事实。

### 3. AI Reading Assistant

AI 阅读助手支持类似 ChatGPT 的多轮体验，但回答优先受馆藏证据约束：

- 多轮 session。
- 每轮记录证据、推荐图书和策略。
- 支持阅读建议、找书、比较、阅读路径规划。
- 可切换本地 Ollama 模型。

### 4. Explainable Recommendation

推荐模块强调“为什么推荐”：

- 首页推荐货架。
- 相似图书推荐。
- 基于分类、标签、作者、简介和行为数据的解释。
- 曝光、点击、反馈日志。
- 推荐漏斗、CTR、反馈率等管理端分析。

### 5. AI Catalog Enrichment

项目提供本地脚本，支持调用 OpenAI-compatible API 批量补全馆藏信息：

- 简介。
- 标签。
- 搜索关键词。
- 目标读者。
- 难度。
- 推荐理由。
- 置信度。

已经完成一次全量补全、人工校正并写入数据库，随后重建搜索索引：

```text
Indexed catalog resources: 373
```

### 6. Evaluation and Benchmark

项目内置完整评测资产：

- `docs/evaluation/search_queries_100.json`
- `docs/evaluation/rag_questions_60.json`
- Python 评测脚本。
- Rust 评测 CLI。
- Markdown、CSV、JSON、HTML 报告。
- 静态 Dashboard 和本地 AI 辅助分析。

## Final Benchmark Snapshot

以下指标来自 `readseek-bench-rs` 对当前 373 本馆藏和真实运行服务的评测。

### Retrieval: 100 Queries

| Method | Success | Precision@5 | Recall@5 | MRR | NDCG@10 | Avg ms | P95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| BM25 | 100/100 | 0.3080 | 0.1904 | 0.6440 | 0.3568 | 42.6 | 78.8 |
| Hybrid | 100/100 | 0.3460 | 0.2017 | 0.7043 | 0.3922 | 110.9 | 142.9 |
| Vector | 100/100 | 0.4940 | 0.2536 | 0.8884 | 0.5078 | 62.0 | 73.3 |
| Hybrid + Reranker | 100/100 | 0.5040 | 0.2630 | 0.9167 | 0.5035 | 266.2 | 316.9 |

结论：`hybrid_reranker` 的 Precision@5 和 MRR 最优，适合正式推荐与高质量检索场景；`vector` 速度和排序质量均衡，适合快速检索档。

### RAG: 60 Questions

| Metric | Value |
| --- | ---: |
| Answerable rate | 1.0000 |
| Evidence hit rate | 0.8167 |
| Mean evidence recall | 0.6444 |
| Mean citation coverage | 0.7933 |
| Average total latency | 25555.0 ms |

### Recommendation Offline Evaluation

| Metric | Value |
| --- | ---: |
| Overview cases | 120 |
| Similar recommendation cases | 25 |
| Precision@10 | 0.1731 |
| Recall@10 | 0.1039 |
| NDCG@10 | 0.1939 |

### API Load Test

| Scope | Success rate | Avg ms | P50 | P90 | P95 | P99 | Max |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Overall | 1.0000 | 630.0 | 103.5 | 1269.7 | 1405.3 | 1562.8 | 1694.8 |
| Recommendation | 1.0000 | 67.2 | 65.1 | 75.3 | 102.1 | 103.5 | 103.5 |
| Search | 1.0000 | 1192.8 | 1202.6 | 1405.3 | 1492.3 | 1694.8 | 1694.8 |

## Architecture

```text
Vue 3 Frontend :5173
        |
        v
Spring Boot API :8010/readseek-service
        |
        +--> PostgreSQL :5043
        |       catalog, users, borrowing, ratings, behavior logs
        |
        +--> Elasticsearch :9200
        |       BM25 retrieval and indexed catalog documents
        |
        +--> Redis :6379
        |       cache and runtime support
        |
        +--> Python AI Service :8001
        |       BGE-M3 embeddings
        |       BGE reranker
        |
        +--> Ollama :11434
                qwen2.5:7b
                qwen3:8b
                qwen3:14b
                qwen2.5-coder:7b
```
=======
## 项目状态 / Project Status

当前状态：面向毕业设计答辩的功能完整原型系统。

Current status: feature-complete prototype for graduation-project defense.

已实现功能 / Implemented:

- 核心图书馆业务流程：图书、作者、分类、出版社、标签、库存、借阅、续借、归还、预约、评分和后台管理。
  Core library workflows: book, author, category, publisher, tag, inventory, borrowing, renewal, return, reservation, rating, and admin management.
- 混合检索：PostgreSQL 精确匹配、Elasticsearch BM25、BGE-M3 稠密向量召回和 BGE reranker 重排。
  Hybrid retrieval: PostgreSQL exact match, Elasticsearch BM25, BGE-M3 dense-vector retrieval, and BGE reranker.
- 证据驱动 RAG 问答：本地 Ollama/Qwen Provider、OpenAI-compatible 在线 Provider 接口、检索证据、引用来源、证据不足拒答和确定性降级回答。
  Evidence-grounded RAG QA: local Ollama/Qwen provider, OpenAI-compatible online provider interface, retrieved evidence, citations, refusal on insufficient evidence, and deterministic fallback.
- 可解释推荐：热门推荐、偏好推荐、协同过滤、行为推荐、相似图书、同分类、共享标签和冷启动推荐。
  Explainable recommendations: popular, preference-based, collaborative filtering, activity-based, similar-book, same-category, shared-tag, and cold-start shelves.
- 行为分析：搜索日志、推荐曝光/点击/反馈日志、QA 日志、引用点击日志、CTR 和反馈率统计。
  Behavior analytics: search logs, recommendation exposure/click/feedback logs, QA logs, citation-click logs, CTR and feedback-rate analytics.
- 本地开发栈：PostgreSQL、Elasticsearch、Redis、Python BGE-M3 AI service、Ollama 和 Docker Compose。
  Local development stack: PostgreSQL, Elasticsearch, Redis, Python BGE-M3 AI service, Ollama, and Docker Compose.

当前原型范围外的工作 / Out of scope for the current prototype:

- 正式的检索、推荐和 RAG 基准实验报告。
  Formal retrieval/recommendation/RAG benchmark report.
- 生产环境安全加固。
  Production security hardening.
- 云端部署和生产规模压力测试。
  Cloud deployment and production-scale load testing.

---

## 核心功能 / Core Features

- 用户注册、登录、JWT 认证和基于角色的管理员权限控制。  
  User registration, login, JWT authentication, and role-based admin access.
- 图书、作者、分类、出版社、标签、库存、借阅、续借、归还和预约管理。  
  Book, author, category, publisher, tag, inventory, borrowing, renewal, return, and reservation management.
- 混合检索策略 / Hybrid search strategy:
  - PostgreSQL 精确匹配 / PostgreSQL exact match
  - Elasticsearch BM25
  - BGE-M3 稠密向量召回 / BGE-M3 dense vector retrieval
  - 精确匹配、BM25 与向量结果融合 / exact/BM25/vector hybrid merge
  - BGE reranker 最终重排 / BGE reranker final ranking
  - 可见的查询意图、来源标签、排序理由和重排标记 / visible query intent, source labels, ranking reasons, and reranker markers
- 证据驱动 RAG 问答 / Evidence-grounded RAG QA:
  - `/api/qa/evidence`
  - fast / standard / expert 三种模式 / fast, standard, and expert modes
  - 本地 Ollama Provider / local Ollama provider
  - OpenAI-compatible 在线 API Provider 接口 / OpenAI-compatible online API provider interface
  - 检索证据、重排和基于引用的回答 / retrieved evidence, rerank, and citation-based answer
  - 证据不足时拒答 / refusal when evidence is insufficient
  - LLM 不可用时确定性降级 / deterministic fallback when LLM is unavailable
- 可解释推荐 / Explainable recommendations:
  - 热门、偏好、协同过滤、相似、同作者、同分类和冷启动推荐货架 / popular, preference, collaborative, similar, same-author, same-category, and cold-start shelves
  - 推荐来源、理由类型、策略和排序位置 / recommendation source, reason type, strategy, and rank position
  - 曝光、点击和反馈日志 / exposure, click, and feedback logging
  - 推荐 CTR 和反馈率分析 / recommendation CTR and feedback-rate analytics
- 管理员分析 / Admin analytics:
  - 搜索关键词 / search keywords
  - 热门分类、作者、标签和出版社 / popular categories, authors, tags, and publishers
  - 点击和借阅最多的图书 / clicked and borrowed books
  - 推荐漏斗 / recommendation funnel
  - QA 请求数、可回答/拒答数、引用点击数和平均延迟 / QA request count, answerable/refusal count, citation clicks, and average latency
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

---

## 技术栈 / Tech Stack

<<<<<<< HEAD
| Layer | Stack |
| --- | --- |
| Backend | Java 17, Spring Boot 3.5, Spring Security JWT, Spring Data JPA, Spring Data Elasticsearch, Redis, Liquibase |
| Database | PostgreSQL 16 |
| Search | Elasticsearch 8, BM25, BGE-M3 vector recall, BGE reranker |
| AI Service | Python 3.11, FlagEmbedding, BGE-M3, BGE reranker |
| LLM | Ollama local models, optional OpenAI-compatible provider |
| Frontend | Vue 3, Vite, TypeScript, Pinia, Vue Router, Element Plus, ECharts |
| Benchmark | Python scripts, Rust CLI, CSV/JSON/Markdown/HTML reports |
| DevOps | Docker Compose, Maven Wrapper, GitHub Actions |

## Repository Layout
=======
- Java 17
- Spring Boot 3.5.x
- Spring Security + JWT
- Spring Data JPA
- PostgreSQL
- Elasticsearch 8
- Redis
- Liquibase
- Lombok / MapStruct
- 静态 HTML/CSS/JavaScript 前端 / Static HTML/CSS/JavaScript frontend
- Python 3.11 本地 AI 服务 / Python 3.11 local AI service
- FlagEmbedding / BGE-M3 / BGE reranker
- Ollama 本地 LLM / Ollama local LLM
- Docker Compose

---

## 运行架构 / Runtime Architecture
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```text
.
├── src/                         # Spring Boot backend
├── frontend/                    # Vue 3 frontend
├── ai-service/                  # Python BGE-M3 embedding/reranker service
├── scripts/                     # startup, enrichment, evaluation, report scripts
├── docs/evaluation/             # 100 queries, 60 RAG questions, generated reports
├── readseek-bench-rs/           # Rust benchmark CLI
├── docker-compose.yml           # PostgreSQL, Elasticsearch, Redis, app
├── pom.xml                      # backend build
└── README.md
```

---

## 环境要求 / Prerequisites

Recommended environment:

- Windows 10/11
- Docker Desktop
- JDK 17
- Python 3.11
<<<<<<< HEAD
- Node.js 22+
- Rust toolchain, for `readseek-bench-rs`
- Ollama

Recommended local Ollama models:
=======
- Ollama for Windows
- 至少 20 GB 可用磁盘空间，用于本地 LLM 模型。  
  At least 20 GB free disk space for local LLM models.

推荐本地模型 / Recommended local models:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```powershell
ollama pull qwen2.5:7b
ollama pull qwen3:8b
ollama pull qwen3:14b
ollama pull qwen2.5-coder:7b
```

<<<<<<< HEAD
The dashboard can also use these models if installed:

```text
llama3.2:3b
phi4-mini-reasoning
openbmb/minicpm-v4.6
```
=======
`qwen3:8b` 是默认 RAG 模型，`qwen3:14b` 仅用于 expert 模式。  
`qwen3:8b` is the default RAG model. `qwen3:14b` is used only for expert mode.
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

---

<<<<<<< HEAD
### 1. Clone

```powershell
git clone https://github.com/<your-name>/<your-repo>.git
cd new-book-recommendation-system
```

### 2. Prepare Local Configuration

The repository includes `.env.example`. Real `.env` is ignored by Git.

```powershell
Copy-Item .env.example .env
notepad .env
```

Important values:

```env
POSTGRES_PASSWORD=your-local-password
SPRING_DATASOURCE_PASSWORD=your-local-password
LIBRARY_SECURITY_JWT_SECRET=replace-with-a-long-random-secret
LIBRARY_BOOTSTRAP_ADMIN_EMAIL=admin@booknook.local
LIBRARY_BOOTSTRAP_ADMIN_PASSWORD=your-admin-password
LIBRARY_BOOTSTRAP_ADMIN_RESET_PASSWORD=true
```

Do not commit `.env`.

### 3. Start Everything
=======
## 快速启动 / Quick Start

从项目根目录执行 / From the project root:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```powershell
.\start-readseek.bat
```

<<<<<<< HEAD
The launcher starts:
=======
也可以手动启动各组件 / If you prefer starting pieces manually:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

- Docker dependencies: PostgreSQL, Elasticsearch, Redis.
- Python AI service.
- Spring Boot backend.
- Vue frontend.

访问地址 / Open:

<<<<<<< HEAD
```text
Frontend:       http://127.0.0.1:5173/
Search page:    http://127.0.0.1:5173/search
Swagger UI:     http://localhost:8010/readseek-service/swagger-ui/index.html
Backend health: http://localhost:8010/readseek-service/actuator/health
AI health:      http://127.0.0.1:8001/health
```

### 4. Rebuild Search Index

After importing or enriching catalog data:

```powershell
.\scripts\rebuild-search-index.ps1
```

Expected successful result:

```json
{
  "success": true,
  "message": "Book search index rebuilt successfully.",
  "body": {
    "indexedCount": 373
  }
}
```

## Frontend Routes

| Route | Purpose |
| --- | --- |
| `/login` | Login |
| `/register` | Register |
| `/` | Home dashboard |
| `/books` | Catalog browsing |
| `/books/:id` | Book detail |
| `/search` | Hybrid search and intelligent book finding |
| `/rag` | Evidence-grounded RAG QA |
| `/ai-chat` | Multi-turn AI reading assistant |
| `/recommendations` | Recommendation shelves |
| `/borrowings` | Borrowing records |
| `/planning` | Reading plan |
| `/profile` | User profile and preferences |
| `/management` | Resource management |
| `/admin` | Analytics and admin dashboard |
| `/evaluation` | Evaluation report page |

## Important APIs

### Search
=======
- 前端 / Frontend: `http://localhost:8010/readseek-service/ui/login.html`
- Swagger UI: `http://localhost:8010/readseek-service/swagger-ui/index.html`
- AI 健康检查 / AI health: `http://127.0.0.1:8001/health`
- Ollama 健康检查 / Ollama health: `http://localhost:11434/api/tags`

默认本地管理员账号 / Default local admin account:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```text
GET  /api/search/resources
GET  /api/search/resources/bm25
GET  /api/search/resources/vector
GET  /api/search/resources/hybrid-basic
POST /api/search/index/books/rebuild
```

<<<<<<< HEAD
### RAG QA
=======
> 注意：默认账号和默认密码仅用于本地开发和答辩演示，生产部署前必须改为安全配置。  
> Note: the default account and password are intended for local development and defense demonstration only. They must be replaced before production deployment.

---

## 本地 AI 服务 / Local AI Service

Python AI 服务提供 embedding 和 reranking 能力。  
The Python AI service provides embedding and reranking:

- embedding 模型 / embedding model: `BAAI/bge-m3`
- reranker 模型 / reranker model: `BAAI/bge-reranker-v2-m3`
- 服务地址 / service URL: `http://127.0.0.1:8001`

主要后端配置 / Main backend config:

```properties
library.search.embedding.enabled=true
library.search.embedding.base-url=http://127.0.0.1:8001
library.search.embedding.model=BAAI/bge-m3
library.search.embedding.dimensions=1024

library.search.reranker.enabled=true
library.search.reranker.base-url=http://127.0.0.1:8001
library.search.reranker.model=BAAI/bge-reranker-v2-m3
```

---

## RAG LLM 配置 / RAG LLM Configuration

默认本地 LLM Provider / Default local LLM provider:

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

模式默认参数 / Mode defaults:

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

可选在线 AI Provider 使用 OpenAI-compatible `/chat/completions` API，默认关闭。  
The optional online AI provider uses an OpenAI-compatible `/chat/completions` API and is disabled by default:

```env
ONLINE_AI_ENABLED=true
ONLINE_AI_BASE_URL=https://api.example.com/v1
ONLINE_AI_CHAT_COMPLETIONS_ENDPOINT=/chat/completions
ONLINE_AI_API_KEY=your_api_key
ONLINE_AI_MODEL=gpt-4o-mini
LLM_PROVIDER=online
```

在线 Provider 设计为通用接口，可通过 base URL、API key 和 model 接入 OpenAI-compatible 服务。  
The online provider is intentionally generic. It can be wired to OpenAI-compatible services by setting the base URL, API key, and model.

---

## 重要 API 接口 / Important API Endpoints

搜索 / Search:

```text
GET  /api/search/books?q=...&limit=10
POST /api/resources/search
POST /api/search/rebuild-index
```

证据问答 / Evidence QA:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```text
POST /api/qa/evidence
POST /api/qa/citation-click
GET  /api/qa/analytics
GET  /api/qa/events/recent
```

<<<<<<< HEAD
### AI Chat

```text
POST   /api/ai-chat/message
GET    /api/ai-chat/sessions
GET    /api/ai-chat/sessions/{id}
DELETE /api/ai-chat/sessions/{id}
```

### Recommendation
=======
推荐 / Recommendation:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```text
GET  /api/resources/recommendations/overview
GET  /api/resources/recommendations/similar/{id}
POST /api/recommendation-events/click
POST /api/recommendation-events/feedback
GET  /api/recommendation-events/analytics
```

<<<<<<< HEAD
## AI Catalog Enrichment

The enrichment script can call an OpenAI-compatible API to generate catalog metadata.

Preview mode:

```powershell
.\.venv-ai\Scripts\python.exe scripts\enrich_catalog_ai.py `
  --ai-base-url https://dashscope.aliyuncs.com/compatible-mode/v1 `
  --ai-model qwen3.5-omni-plus-2026-03-15 `
  --ai-api-key-env DASHSCOPE_API_KEY `
  --limit 5
```

Apply from a corrected preview:

```powershell
.\.venv-ai\Scripts\python.exe scripts\enrich_catalog_ai.py `
  --input-preview scripts\generated\catalog_ai_enrichment_all_preview_corrected.json `
  --output scripts\generated\catalog_ai_enrichment_all_apply_result.json `
  --min-apply-confidence 0.0 `
  --apply `
  --rebuild-index
```

The script intentionally supports dry-run and preview correction before writing to the database.

## Python Evaluation Scripts

Generate evaluation assets:

```powershell
.\.venv-ai\Scripts\python.exe scripts\generate_evaluation_assets.py
```

Run four-way retrieval evaluation:

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_retrieval_evaluation.py `
  --queries docs/evaluation/search_queries_100.json `
  --output-dir docs/evaluation/generated `
  --limit 10
```

Run RAG evaluation:

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_rag_evaluation.py `
  --questions docs/evaluation/rag_questions_60.json `
  --output-dir docs/evaluation/generated `
  --mode standard `
  --provider ollama `
  --limit 8
```

Run recommendation evaluation:

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_recommendation_offline_evaluation.py `
  --queries docs/evaluation/search_queries_100.json `
  --output-dir docs/evaluation/generated
```

Run API load test:

```powershell
.\.venv-ai\Scripts\python.exe scripts\run_api_load_test.py `
  --scenarios search,recommendation `
  --requests 100 `
  --concurrency 8 `
  --output-dir docs/evaluation/generated
```

## Rust Benchmark CLI

`readseek-bench-rs` is a standalone Rust CLI. It reuses the same evaluation data and APIs as the Python scripts, but provides a typed, distributable benchmark tool.

Run the full suite:

```powershell
.\scripts\run_readseek_bench_rs_suite.ps1
```

Run retrieval only:

```powershell
.\scripts\run_readseek_bench_rs.ps1
```

Open the static benchmark dashboard:

```powershell
.\scripts\serve_readseek_report.ps1
```

Then open:
=======
行为分析 / Behavior analytics:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```text
http://127.0.0.1:8765/index.html
```

<<<<<<< HEAD
Dashboard capabilities:
=======
---

## RAG 请求示例 / RAG Request Example
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

- Shows retrieval, RAG, recommendation and load-test metrics.
- Displays quality bars, latency charts, RAG circular indicators and quality-first modeling score.
- Can call a local analysis model such as `qwen2.5:7b`, `qwen3:8b` or `qwen3:14b`.
- Can call `qwen2.5-coder:7b` to generate a standalone HTML report.
- Provides live preview and download for the generated HTML.

If the browser blocks direct access to Ollama, configure local origins and restart Ollama:

```powershell
$env:OLLAMA_ORIGINS="*"
ollama serve
```

<<<<<<< HEAD
## Testing

Backend tests:
=======
响应包含 / Response includes:

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

---

## 测试 / Testing

运行完整自动化测试套件 / Run the full automated test suite:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```powershell
.\mvnw-jdk17.cmd test
```

<<<<<<< HEAD
Frontend build:
=======
当前结果 / Current result:

```text
Tests run: 92
Failures: 0
Errors: 0
Skipped: 0
```

测试覆盖 controller、搜索、RAG 回答生成、QA 日志、推荐事件、推荐分析、借阅、预约、评分、安全限流和应用上下文启动。  
The tests cover controllers, search, RAG answer generation, QA logging, recommendation events, recommendation analytics, borrowing, reservation, rating, security rate limiting, and application context startup.

---

## 冒烟测试清单 / Smoke Test Checklist

启动后 / After startup:

1. 使用管理员账号登录。  
   Log in as admin.
2. 打开搜索页面并执行一次自然语言查询。  
   Open the search page and run a natural-language query.
3. 确认搜索结果显示来源、理由、策略和 reranker 标记。  
   Confirm search results show source, reason, strategy, and reranker marker.
4. 打开 QA 页面，使用 `standard` 模式和 `Ollama` Provider 提问。  
   Open the QA page and ask a question in `standard` mode with provider `Ollama`.
5. 确认回答包含 citations 和 evidence cards。  
   Confirm the answer has citations and evidence cards.
6. 点击 QA 引用，并验证管理员分析中记录了 citation click。  
   Click a QA citation and verify admin analytics records a citation click.
7. 打开推荐页面并点击一个推荐项。  
   Open recommendations and click a recommendation.
8. 提交 interested / not-interested 反馈。  
   Send interested/not-interested feedback.
9. 打开管理员分析页面，查看推荐漏斗和 QA 质量面板。  
   Open admin analytics and verify recommendation funnel and QA quality panels.
10. 停止 Ollama 后再次提问，确认系统会降级回答而不是崩溃。  
    Stop Ollama and ask again; the answer should fall back instead of crashing.

---

## 故障排查 / Troubleshooting

容器名称冲突 / Container name conflict:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```powershell
cd frontend
npm install
npm run build
```

<<<<<<< HEAD
Rust benchmark tests:
=======
Ollama 模型缺失 / Ollama model missing:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```powershell
cd readseek-bench-rs
cargo test
```

<<<<<<< HEAD
Docker Compose validation:
=======
AI 服务首次启动较慢 / AI service slow on first run:

- 首次启动 BGE-M3 和 reranker 会下载模型文件。  
  The first BGE-M3 and reranker startup downloads model files.
- 建议保留缓存目录 `C:\Users\<user>\.cache\readseek\huggingface`。  
  Keep the cache at `C:\Users\<user>\.cache\readseek\huggingface`.
- Hugging Face 的 Windows symlink warning 通常无害，开启 Developer Mode 可以减少重复缓存占用。  
  Windows symlink warnings from Hugging Face are harmless, but Developer Mode can reduce duplicate cache storage.

Elasticsearch 索引过期 / Elasticsearch index stale:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```powershell
docker compose config --quiet
```

<<<<<<< HEAD
## Stop Local Services

If started with the project scripts, close the spawned terminals or stop by port/process. Docker dependencies can be stopped with:

```powershell
docker compose stop db elasticsearch redis
```

If the static report server is running, stop the terminal running:

```powershell
.\scripts\serve_readseek_report.ps1
```

## GitHub Notes

Before publishing:

1. Ensure `.env` is not committed.
2. Remove or ignore runtime logs such as `*.log`.
3. Keep `docs/evaluation/generated/` only if you want to publish measured benchmark artifacts.
4. Keep screenshots in the repository root if you want them displayed in this README.
5. Run backend, frontend and Rust tests once before pushing.

Useful checks:
=======
仅运行后端测试 / Run backend tests only:
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce

```powershell
.\mvnw-jdk17.cmd test
cd frontend
npm run build
cd ..
cd readseek-bench-rs
cargo test
```

<<<<<<< HEAD
## Current Scope and Boundaries

ReadSeek is designed around catalog-level reading resources, not full-book text ingestion.

Currently included:

- Catalog metadata, descriptions, tags, categories, authors and publisher fields.
- Search and RAG over resource metadata and summaries.
- Evidence-grounded answers and recommendations.
- Evaluation on the current 373-book demo catalog.

Currently not included:

- Full PDF/EPUB chapter ingestion.
- Chapter-level QA.
- Copyrighted full-text indexing.
- Large public recommendation datasets such as Goodreads.
- Production multi-node deployment.

## Project Status

This version is a complete portfolio/course-project release:

- Full-stack application.
- AI-enhanced catalog.
- Hybrid retrieval and RAG.
- Explainable recommendation.
- Admin analytics.
- Modern Vue UI.
- Python and Rust evaluation toolchains.
- Reproducible reports and static benchmark dashboard.

ReadSeek can be presented as a mature AI reading-resource discovery system and as an engineering case study for retrieval, recommendation, RAG and evaluation.
=======
---

## 开发范围总结 / Development Scope Summary

当前开发状态：已完成 ReadSeek 毕业设计/课程设计范围内的核心功能。  
Development status: feature-complete for the current ReadSeek graduation/course-project scope.

已完成 / Completed:

- 核心图书馆业务流程 / Core library workflows
- 混合检索 / Hybrid retrieval
- 向量召回 / Vector retrieval
- BGE reranker 重排 / Reranker
- 基于本地 LLM 和 fallback 的 RAG QA / RAG QA with local LLM and fallback
- 在线 AI Provider 接口 / Online AI Provider interface
- 可解释推荐 / Explainable recommendation
- 推荐曝光、点击和反馈日志 / Recommendation exposure/click/feedback logs
- QA 请求和引用日志 / QA request/citation logs
- 管理员分析 / Admin analytics
- 自动化回归测试 / Automated regression tests
- 本地启动文档 / Local startup documentation

当前开发范围外的后续工作 / Remaining work outside development scope:

- 正式实验数据集和评测报告 / Formal experiment datasets and reports
- 毕业论文撰写 / Thesis writing
- 答辩 PPT / Defense PPT
- 生产环境部署加固 / Optional deployment hardening for production environments
>>>>>>> 6054fd47ead630e750de5f082723a02a2dee97ce
