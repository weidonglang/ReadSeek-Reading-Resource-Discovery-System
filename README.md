# ReadSeek 阅读资源发现系统 / ReadSeek Reading Resource Discovery System

ReadSeek 是一个基于 Spring Boot 的阅读资源发现系统。它在传统图书馆业务流程基础上，集成了混合检索、证据驱动 RAG 问答、可解释推荐和行为分析能力。

ReadSeek is a Spring Boot based reading-resource discovery system. It combines a traditional library workflow with hybrid retrieval, evidence-grounded RAG question answering, explainable recommendations, and behavior analytics.

---

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

---

## 技术栈 / Tech Stack

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

---

## 环境要求 / Prerequisites

- Windows 10/11
- Docker Desktop
- JDK 17
- Python 3.11
- Ollama for Windows
- 至少 20 GB 可用磁盘空间，用于本地 LLM 模型。  
  At least 20 GB free disk space for local LLM models.

推荐本地模型 / Recommended local models:

```powershell
ollama pull qwen2.5:7b
ollama pull qwen3:8b
ollama pull qwen3:14b
```

`qwen3:8b` 是默认 RAG 模型，`qwen3:14b` 仅用于 expert 模式。  
`qwen3:8b` is the default RAG model. `qwen3:14b` is used only for expert mode.

---

## 快速启动 / Quick Start

从项目根目录执行 / From the project root:

```powershell
cd E:\javacode\new-book-recommendation-system
.\start-readseek.bat
```

也可以手动启动各组件 / If you prefer starting pieces manually:

```powershell
docker compose up -d

.\.venv-ai\Scripts\activate
.\start-bge-m3-ai-service.bat

.\mvnw-jdk17.cmd spring-boot:run
```

访问地址 / Open:

- 前端 / Frontend: `http://localhost:8010/readseek-service/ui/login.html`
- Swagger UI: `http://localhost:8010/readseek-service/swagger-ui/index.html`
- AI 健康检查 / AI health: `http://127.0.0.1:8001/health`
- Ollama 健康检查 / Ollama health: `http://localhost:11434/api/tags`

默认本地管理员账号 / Default local admin account:

```text
Email: admin@booknook.local
Password: Admin123!
```

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

```text
POST /api/qa/evidence
POST /api/qa/citation-click
GET  /api/qa/analytics
GET  /api/qa/events/recent
```

推荐 / Recommendation:

```text
GET  /api/resources/recommendations/overview
GET  /api/resources/{id}/recommendations/similar
POST /api/recommendation-events/click
POST /api/recommendation-events/feedback
GET  /api/recommendation-events/analytics
GET  /api/recommendation-events/recent
```

行为分析 / Behavior analytics:

```text
POST /api/behavior-log
GET  /api/behavior-log/dashboard
GET  /api/behavior-log/searches/top-keywords
GET  /api/behavior-log/books/top-clicked
GET  /api/behavior-log/books/top-borrowed
```

---

## RAG 请求示例 / RAG Request Example

```json
{
  "question": "想看关于个人成长的书，应该从哪本开始？",
  "limit": 10,
  "mode": "standard",
  "provider": "ollama"
}
```

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

```powershell
.\mvnw-jdk17.cmd test
```

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

```powershell
docker ps -a
docker rm -f readseek-db readseek-search readseek-redis
docker compose up -d
```

Ollama 模型缺失 / Ollama model missing:

```powershell
ollama pull qwen3:8b
```

AI 服务首次启动较慢 / AI service slow on first run:

- 首次启动 BGE-M3 和 reranker 会下载模型文件。  
  The first BGE-M3 and reranker startup downloads model files.
- 建议保留缓存目录 `C:\Users\<user>\.cache\readseek\huggingface`。  
  Keep the cache at `C:\Users\<user>\.cache\readseek\huggingface`.
- Hugging Face 的 Windows symlink warning 通常无害，开启 Developer Mode 可以减少重复缓存占用。  
  Windows symlink warnings from Hugging Face are harmless, but Developer Mode can reduce duplicate cache storage.

Elasticsearch 索引过期 / Elasticsearch index stale:

```powershell
.\scripts\rebuild-search-index.ps1
```

仅运行后端测试 / Run backend tests only:

```powershell
.\mvnw-jdk17.cmd test
```

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
