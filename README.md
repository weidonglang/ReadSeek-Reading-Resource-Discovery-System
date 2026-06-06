# ReadSeek 阅读资源发现系统 / ReadSeek Reading Resource Discovery System

> 一个面向“图书检索、智能推荐、RAG 问答和离线评测”的完整 Java 课程项目。

ReadSeek 不是普通的图书管理系统。它在传统图书馆业务流程之上，加入了 PostgreSQL 精确匹配、Elasticsearch BM25、BGE-M3 向量召回、BGE reranker、馆藏证据约束的 RAG 问答、可解释推荐、用户行为分析、AI 馆藏补全，以及 Rust 离线评测工具。

ReadSeek is a Spring Boot based reading-resource discovery system. It combines library management, hybrid retrieval, evidence-grounded RAG QA, explainable recommendation, behavior analytics, and an independent Rust benchmark suite.

---

## 项目状态 / Project Status

当前版本已经进入收官状态，适合作为课程设计、答辩展示和 GitHub 作品集项目。

- 已完成 373 本演示馆藏的 AI 元数据补全、人工校正和索引重建。
- 已实现 exact、BM25、vector、hybrid、hybrid + reranker 多路检索链路。
- 已实现“智能问答与找书”和类 ChatGPT 的 AI 阅读助手。
- 已实现推荐货架、相似图书推荐、推荐理由、证据卡片和行为分析。
- 已实现 100 条检索评测、60 条 RAG 问题集、推荐评测和 API 压测。
- 已实现 Rust CLI `readseek-bench-rs`，可输出 Markdown、CSV、JSON 和静态 HTML 报告。
- 已实现本地报告 Dashboard，可调用 Ollama 小模型分析结果，并调用代码模型生成更美观的独立 HTML 分析页。

---

## 核心亮点 / Highlights

| 模块 | 已实现能力 |
| --- | --- |
| 馆藏管理 | 图书、作者、分类、出版社、标签、借阅、预约、评分、管理员账户 |
| 混合检索 | PostgreSQL 精确匹配、Elasticsearch BM25、BGE-M3 embedding、混合召回、BGE reranker |
| 智能问答 | 基于馆藏证据回答，支持引用编号、证据卡片、可回答判断、限制说明、追问建议 |
| 智能找书 | 支持按书名、作者、主题、分类、标签、简介和自然语言意图推荐图书 |
| 推荐系统 | 热门推荐、相似推荐、可解释推荐、曝光、点击、反馈和推荐漏斗分析 |
| 数据补全 | OpenAI-compatible API 批量生成简介、标签、搜索关键词、难度、目标读者和推荐理由 |
| 前端体验 | Vue 3 + Element Plus 管理端与用户端，包含搜索页、RAG 页、AI Chat 页、评测页和分析页 |
| 离线评测 | Python 原有脚本继续保留，Rust 版本用于更快、更稳定地生成正式报告 |
| 静态报告 | 展示检索、RAG、推荐、压测结果，支持图表、指标解释、本地 AI 辅助分析和 HTML 导出 |

---

## 技术栈 / Tech Stack

| 层级 | 技术 |
| --- | --- |
| Backend | Java 17, Spring Boot 3.5.7, Spring Security, JWT, Spring Data JPA, Liquibase |
| Database | PostgreSQL 16 |
| Search | Elasticsearch 8.15.3, BM25, dense vector field |
| Cache | Redis 7 |
| AI Service | Python, FastAPI style local service, BAAI/bge-m3, BAAI/bge-reranker-v2-m3 |
| LLM | Ollama, qwen2.5:7b, qwen3:8b, qwen3:14b, qwen2.5-coder:7b |
| Frontend | Vue 3, TypeScript, Vite, Pinia, Vue Router, Element Plus, ECharts |
| Evaluation | Python scripts, Rust CLI, Markdown, CSV, JSON, static HTML dashboard |
| DevOps | Docker Compose, Maven, npm, PowerShell startup scripts |

---

## 运行架构 / Runtime Architecture

```text
Vue 3 Frontend              http://127.0.0.1:5173
        |
        v
Spring Boot API             http://localhost:8010/readseek-service
        |
        +-- PostgreSQL       localhost:5043
        +-- Elasticsearch    localhost:9200
        +-- Redis            localhost:6379
        +-- Local AI Service http://127.0.0.1:8001
        +-- Ollama           http://localhost:11434

Rust Evaluation Dashboard   http://127.0.0.1:8765/index.html
```

---

## 目录结构 / Repository Layout

```text
.
├── src/main/java/com/weidonglang/readseek
│   ├── controller          # REST API
│   ├── service             # 检索、推荐、RAG、行为分析等业务逻辑
│   ├── repository          # JPA 数据访问
│   ├── document            # Elasticsearch document
│   └── config              # 安全、CORS、AI、搜索配置
├── src/main/resources
│   ├── application*.properties
│   └── db                  # Liquibase schema 与演示数据
├── frontend                # Vue 3 前端
├── scripts                 # 启动、AI 补全、评测和报告服务脚本
├── docs/evaluation         # 评测数据集、报告和生成结果
├── readseek-bench-rs       # Rust 评测 CLI
├── docker-compose.yml
├── start-readseek.bat
└── README.md
```

---

## 环境要求 / Prerequisites

推荐本地环境：

- JDK 17
- Maven 3.9+
- Node.js 20+
- Python 3.10+
- Docker Desktop
- Rust toolchain，可通过 `rustup` 安装
- Ollama，本地 RAG 与报告分析需要

推荐 Ollama 模型：

```powershell
ollama pull qwen2.5:7b
ollama pull qwen3:8b
ollama pull qwen3:14b
ollama pull qwen2.5-coder:7b
```

---

## 快速启动 / Quick Start

Windows 下最简单的方式：

```powershell
.\start-readseek.bat
```

该脚本会自动处理：

- 创建或读取 `.env`
- 启动 PostgreSQL、Elasticsearch、Redis
- 启动 Spring Boot 后端
- 启动本地 embedding/reranker AI 服务
- 启动 Vue 前端
- 打开默认页面

常用入口：

```text
前端首页:     http://127.0.0.1:5173
后端健康检查: http://localhost:8010/readseek-service/actuator/health
Swagger:      http://localhost:8010/readseek-service/swagger-ui/index.html
```

默认本地管理员账号由 `.env` 控制。开发环境默认邮箱通常是：

```text
admin@booknook.local
```

请不要把真实 `.env`、真实密码或真实 API Key 上传到 GitHub。

---

## 本地 AI 与 RAG 配置 / Local AI and RAG

RAG 支持三档模式：

| 模式 | 默认模型 | 适用场景 |
| --- | --- | --- |
| fast | qwen2.5:7b | 快速回答、普通找书 |
| standard | qwen3:8b | 默认问答、推荐解释 |
| expert | qwen3:14b | 更复杂的阅读规划、对比分析 |

相关配置位于 `src/main/resources/application.properties`，也可以通过 `.env` 覆盖：

```properties
RAG_LLM_ENABLED=true
LLM_PROVIDER=ollama
OLLAMA_BASE_URL=http://localhost:11434
RAG_FAST_MODEL=qwen2.5:7b
RAG_STANDARD_MODEL=qwen3:8b
RAG_EXPERT_MODEL=qwen3:14b
```

系统的回答策略是“优先基于馆藏证据”。当证据不足时，系统会给出限制说明，而不是直接编造馆藏外事实。

---

## 混合检索 / Hybrid Retrieval

ReadSeek 的检索链路包含：

- PostgreSQL 基础字段兜底：书名、作者、分类、标签、出版社、ISBN。
- Elasticsearch BM25 全文检索：适合关键词匹配和标题、简介检索。
- BGE-M3 向量召回：适合语义相近但关键词不同的查询。
- hybrid 合并：合并 exact、BM25、vector 候选。
- BGE reranker 重排序：对候选结果做相关性精排。
- 前端展示：查询意图、候选数、召回来源、是否 fallback、排序理由和证据详情。

对比接口：

```text
GET  /api/search/resources/bm25
GET  /api/search/resources/vector
GET  /api/search/resources/hybrid-basic
GET  /api/search/resources
POST /api/search/index/resources/rebuild
```

---

## 智能问答与找书 / RAG QA and Book Discovery

主要接口：

```text
POST /api/qa/evidence
POST /api/ai-chat/message
GET  /api/ai-chat/sessions
GET  /api/ai-chat/sessions/{id}
```

能力说明：

- 支持“找书”和“问问题”两种使用方式。
- 支持 fast、standard、expert 模式。
- 返回答案、证据卡片、引用编号、推荐书籍、策略、模型、耗时和限制说明。
- 支持多轮 AI Chat，每轮记录证据、引用和推荐结果。
- 当搜索索引暂时不可用时，会回退到数据库基础字段。

---

## 推荐与行为分析 / Recommendation and Analytics

主要接口：

```text
GET  /api/resources/recommended
GET  /api/resources/recommendations/popular
GET  /api/resources/recommendations/overview
GET  /api/resources/recommendations/similar/{resourceId}
POST /api/recommendation-events/click
POST /api/recommendation-events/feedback
GET  /api/recommendation-events/analytics
GET  /api/behavior-log/dashboard
```

推荐模块不仅返回“推荐了什么”，也返回“为什么推荐”：

- 基于分类、标签、作者、简介、关键词和用户行为。
- 支持热门推荐、相似图书推荐和个性化推荐入口。
- 记录曝光、点击、反馈和搜索行为。
- 管理端可查看推荐漏斗、CTR、反馈率、热门关键词和热门图书。

---

## AI 馆藏补全 / Catalog Enrichment

项目提供 `scripts/enrich_catalog_ai.py`，可调用 OpenAI-compatible API 批量补全馆藏元数据。

补全字段包括：

- description
- tags
- search_keywords
- difficulty
- target_audience
- recommendation_reason
- confidence

推荐流程：

```powershell
# 1. 小批量预览
.\.venv-ai\Scripts\python.exe scripts\enrich_catalog_ai.py `
  --ai-base-url https://dashscope.aliyuncs.com/compatible-mode/v1 `
  --ai-model qwen3.5-omni-plus-2026-03-15 `
  --ai-api-key-env DASHSCOPE_API_KEY `
  --limit 5

# 2. 人工检查生成的 preview JSON

# 3. 从人工校正后的 preview 写入数据库并重建索引
.\.venv-ai\Scripts\python.exe scripts\enrich_catalog_ai.py `
  --input-preview scripts\generated\catalog_ai_enrichment_all_preview_corrected.json `
  --output scripts\generated\catalog_ai_enrichment_all_apply_result.json `
  --min-apply-confidence 0.0 `
  --apply `
  --rebuild-index
```

当前项目已经完成一次全量补全并重建索引：

```text
Indexed catalog resources: 373
```

---

## 最终评测结果 / Final Benchmark Snapshot

以下结果来自 `readseek-bench-rs` 对当前 373 本馆藏和本地运行服务的评测。

### Retrieval

100 条检索查询，指标重点为 Precision@5。

| Method | Success | Precision@5 | Recall@5 | MRR | NDCG@10 | Avg ms | P95 ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm25 | 100/100 | 0.3080 | 0.1904 | 0.6440 | 0.3568 | 42.6 | 78.8 |
| hybrid | 100/100 | 0.3460 | 0.2017 | 0.7043 | 0.3922 | 110.9 | 142.9 |
| vector | 100/100 | 0.4940 | 0.2536 | 0.8884 | 0.5078 | 62.0 | 73.3 |
| hybrid_reranker | 100/100 | 0.5040 | 0.2630 | 0.9167 | 0.5035 | 266.2 | 316.9 |

结论：`hybrid_reranker` 的 Precision@5 和 MRR 最强，说明重排序对结果相关性提升明显；`vector` 的 NDCG@10 略高且延迟更低，适合对速度更敏感的语义搜索。

### RAG

60 条 RAG 问题，模式为 `standard / ollama`。

| Metric | Value |
| --- | ---: |
| Answerable rate | 1.0000 |
| Evidence hit rate | 0.8167 |
| Mean evidence recall | 0.6444 |
| Mean citation coverage | 0.7933 |
| Average total latency ms | 25555.0 |

结论：RAG 能覆盖全部问题，证据命中和引用覆盖较稳定；主要短板是本地大模型生成耗时较高。

### Recommendation

| Metric | Value |
| --- | ---: |
| Overview samples | 120 |
| Similar anchor samples | 25 |
| Precision@10 | 0.1731 |
| Recall@10 | 0.1039 |
| NDCG@10 | 0.1939 |

结论：推荐模块已经有完整的可解释与行为闭环，但由于演示数据规模较小、真实用户行为较少，个性化推荐指标仍有提升空间。

### Load Test

| Metric | Value |
| --- | ---: |
| Overall success rate | 1.0000 |
| Overall avg ms | 630.0 |
| Overall p50 ms | 103.5 |
| Overall p90 ms | 1269.7 |
| Overall p95 ms | 1405.3 |
| Overall p99 ms | 1562.8 |
| Max ms | 1694.8 |

分场景：

| Scenario | Avg ms | P95 ms |
| --- | ---: | ---: |
| recommendation | 67.2 | 102.1 |
| search | 1192.8 | 1492.3 |

---

## 评测与报告 / Evaluation and Reports

完整评测数据集：

```text
docs/evaluation/search_queries_100.json
docs/evaluation/rag_questions_60.json
```

运行 Rust 全量评测：

```powershell
.\scripts\run_readseek_bench_rs_suite.ps1
```

快速调小评测规模：

```powershell
.\scripts\run_readseek_bench_rs_suite.ps1 `
  -RetrievalQueryLimit 10 `
  -RagQuestionLimit 8 `
  -LoadRequests 40 `
  -LoadConcurrency 4 `
  -OllamaModel qwen2.5:7b `
  -CoderModel qwen2.5-coder:7b
```

启动静态报告服务：

```powershell
.\scripts\serve_readseek_report.ps1
```

打开：

```text
http://127.0.0.1:8765/index.html
```

注意：不要直接用 `file://` 打开报告页。浏览器会因为 file origin 限制拦截本地模型请求。

---

## Rust 评测 CLI / readseek-bench-rs

`readseek-bench-rs` 是独立 Rust CLI，用来补齐项目的工程证据。

它可以：

- 读取检索查询和 RAG 问题集。
- 调用 ReadSeek 后端 API。
- 对比 bm25、vector、hybrid、hybrid_reranker。
- 计算 Precision@K、Recall@K、MRR、NDCG、p50、p95、p99。
- 输出 Markdown、CSV、JSON。
- 生成静态 HTML Dashboard。
- 调用本地 Ollama 模型分析报告。
- 调用 `qwen2.5-coder:7b` 生成更精美的独立 HTML 分析页。

单独运行：

```powershell
cd readseek-bench-rs
cargo run --release -- --help
```

---

## 测试 / Testing

后端单元测试：

```powershell
mvn test
```

前端类型检查与构建：

```powershell
cd frontend
npm install
npm run build
```

Rust CLI 测试：

```powershell
cd readseek-bench-rs
cargo test
```

建议在提交 GitHub 前至少执行：

```powershell
mvn test
cd frontend
npm run build
cd ..\readseek-bench-rs
cargo test
```

---

## 常见问题 / Troubleshooting

### README 中文在 PowerShell 里乱码

这是 PowerShell 控制台编码显示问题，不一定是文件损坏。GitHub 和 UTF-8 编辑器通常能正常显示。

可用下面命令检查：

```powershell
python -c "from pathlib import Path; print(Path('README.md').read_text(encoding='utf-8')[:200])"
```

### 天气一直显示正在刷新

天气依赖浏览器定位、网络定位和后端代理配置。若精确定位不可用，系统会尝试网络位置；仍失败时应检查浏览器定位权限、网络访问和后端天气配置。

### AI 问答没有结果

优先检查：

- 数据库是否已有补全后的 description、tags、search_keywords。
- Elasticsearch 索引是否重建。
- 本地 AI 服务 `http://127.0.0.1:8001/health` 是否正常。
- Ollama `http://localhost:11434` 是否运行。

重建资源索引：

```text
POST /api/search/index/resources/rebuild
```

### 静态报告的 AI 分析按钮没反应

不要用 `file://` 打开报告。请启动本地报告服务器：

```powershell
.\scripts\serve_readseek_report.ps1
```

然后访问：

```text
http://127.0.0.1:8765/index.html
```

### 14B 模型太慢

报告分析和 RAG 都可以选择更小模型。推荐：

- 快速分析：`qwen2.5:7b`
- 默认分析：`qwen3:8b`
- 深度分析：`qwen3:14b`
- HTML 代码生成：`qwen2.5-coder:7b`

---

## 上传 GitHub 前 / Before Publishing

建议上传：

- `src/`
- `frontend/`
- `scripts/`
- `docs/evaluation/`
- `readseek-bench-rs/`
- `docker-compose.yml`
- `Dockerfile`
- `pom.xml`
- `README.md`
- `.env.example`

不要上传：

- `.env`
- 真实 API Key
- 数据库本地卷
- `.venv-ai/`
- `target/`
- `frontend/node_modules/`
- `frontend/dist/`
- `readseek-bench-rs/target/`
- 本地日志和临时文件

如果之前误把密钥写进仓库，应该立即作废旧 Key，并重新生成。

---

## 项目边界 / Scope

ReadSeek 当前版本已经覆盖课程项目需要展示的完整链路，但仍保留一些合理边界：

- 当前馆藏是演示规模数据，不等同于大规模真实图书馆生产数据。
- 推荐评测受限于真实用户行为数量，个性化指标还有提升空间。
- 本地 RAG 延迟主要取决于 Ollama 模型大小和机器性能。
- 静态报告的 AI 分析依赖本地浏览器、报告服务和 Ollama 可访问性。

---

## 总结 / Summary

ReadSeek 的最终版本形成了一个完整闭环：

```text
馆藏数据补全
  -> 检索索引重建
  -> 混合搜索和智能推荐
  -> 证据约束 RAG 问答
  -> 用户行为记录和管理端分析
  -> Python / Rust 离线评测
  -> Markdown / HTML 报告展示
  -> 本地 AI 辅助解释和报告生成
```

这使它不只是一个“能借书还书”的管理系统，而是一个具备 AI 检索、推荐、问答、评测和工程展示能力的阅读资源发现平台。
