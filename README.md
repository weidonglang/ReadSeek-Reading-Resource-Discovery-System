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

## 项目定位 / Positioning

ReadSeek 的定位是“工程型 AI 阅读资源发现系统”，不是单一算法论文项目。

本项目的创新重点不在于提出新的深度学习模型，而在于围绕图书和阅读资源发现任务，打通以下完整链路：

```text
馆藏数据补全 -> 混合检索 -> reranker 精排 -> RAG 问答 -> 可解释推荐 -> 行为分析 -> 离线评测 -> HTML 报告
```

因此，项目更适合从工程完整性、模块集成、可解释性、可评测性和系统可运行性角度评价。若按“算法原创性”评价，本项目属于工程集成创新；若按“课程项目或应用型毕设”评价，它展示的是一个可运行、可验证、可扩展的 AI 阅读系统。

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

## 模块深度说明 / Module Depth

ReadSeek 覆盖范围较大，因此各模块深度并不完全相同。当前版本的重点和深度如下：

| 模块 | 当前深度 | 说明 |
| --- | --- | --- |
| 搜索检索 | 最强 | 已实现 exact、BM25、vector、hybrid、reranker 对比，并有 100 条查询评测和多指标报告。 |
| RAG 问答 | 较强 | 已实现证据召回、引用编号、证据卡片、可回答判断、限制说明和 60 问题集评测。 |
| 推荐系统 | 中等 | 已实现热门、相似、可解释推荐和行为日志，但受限于真实用户行为较少，个性化模型仍偏基础。 |
| 行为分析 | 中等 | 已有曝光、点击、反馈、搜索日志和管理端统计，重点是支撑解释与评测。 |
| 部署安全 | 演示级 | Docker Compose 和本地脚本可运行，但默认密码、ES 安全、AI 服务容器化仍按开发演示环境处理。 |

这个取舍是有意的：项目优先保证完整闭环和可展示效果，再通过评测报告说明各模块能力边界。

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

推荐评测目前更适合证明“系统具备推荐、解释、记录和离线评估能力”，不能夸大为已经超过生产级推荐系统。后续若要进一步增强说服力，应补充：

- `popular baseline`、`category/tag content-based`、`hybrid recommendation` 三组对照实验。
- 人工标注相关性样本，统一评估 Precision@K、Recall@K、MRR、NDCG@K。
- 引入真实用户借阅、点击、收藏和反馈行为，降低演示数据稀疏带来的偏差。
- 增加冷启动、新书推荐和长期兴趣建模实验。

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

## 实验可信度说明 / Evaluation Notes

当前评测已经覆盖检索、RAG、推荐和压测，但仍属于课程项目规模的离线评测，不等同于大规模线上 A/B 实验。

| 评测项 | 已完成 | 当前边界 |
| --- | --- | --- |
| 检索评测 | 100 条查询，四组检索方法对比，多指标输出 | 查询集规模有限，相关性主要基于项目数据构造和人工检查 |
| RAG 评测 | 60 条问题，证据命中、引用覆盖、延迟统计 | 仍需要更系统的人工打分，包括正确性、完整性和幻觉风险 |
| 推荐评测 | 推荐 overview 与相似推荐离线指标 | 缺少真实用户长期行为和线上反馈闭环 |
| 压测 | search 与 recommendation 场景并发请求 | 本地机器环境测试，不能直接代表生产集群性能 |

答辩时可以这样概括：

> 本项目已经具备完整的离线评测能力，并通过 Rust 工具输出了检索、RAG、推荐和压测报告。由于数据集和真实用户行为规模有限，实验重点是验证系统链路和模块差异，而不是证明模型达到工业级推荐系统效果。

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

## 前端与报告说明 / Frontend Organization

项目中存在两类前端页面，它们职责不同：

| 类型 | 位置 | 作用 |
| --- | --- | --- |
| Vue 业务前端 | `frontend/` | 用户登录、图书浏览、搜索、推荐、RAG 问答、AI Chat、管理端分析 |
| 静态评测报告 | `docs/evaluation/generated/rust-suite/index.html` | 展示 Rust 评测结果、图表、指标解释和本地 AI 分析 |

Vue 前端是主系统界面；静态 HTML 是评测报告 Dashboard，不承担业务操作。这样保留两套页面是为了让系统功能展示和实验结果展示彼此独立。

---

## 安全与部署说明 / Security and Deployment Notes

当前配置以本地开发和课程答辩演示为主，不应直接作为生产环境部署。

| 项目 | 当前状态 | 生产化建议 |
| --- | --- | --- |
| 默认密码 | `.env.example` 提供开发默认值 | 生产环境必须使用强密码和密钥管理 |
| Elasticsearch | 本地开发关闭安全认证 | 生产环境开启认证、TLS 和访问控制 |
| JWT Secret | 开发环境可由 `.env` 配置 | 生产环境使用长随机密钥并定期轮换 |
| AI Service | 本地脚本启动 | 生产环境应容器化并加入健康检查、限流和日志 |
| Ollama | 本地模型服务 | 生产环境需控制模型访问、超时和资源隔离 |
| CORS | 允许本地前端地址 | 生产环境只允许可信域名 |

这些安全限制不影响课程演示，但需要在答辩或文档中明确说明。本项目当前目标是证明系统链路、AI 功能和评测能力，而不是交付生产级安全部署方案。

---

## 项目边界 / Scope

ReadSeek 当前版本已经覆盖课程项目需要展示的完整链路，但仍保留一些合理边界：

- 当前馆藏是演示规模数据，不等同于大规模真实图书馆生产数据。
- 系统创新属于工程集成创新，不主张提出新的原创检索或推荐算法。
- 搜索模块深度最完整，RAG 模块具备证据约束和引用能力，推荐模块偏可解释和演示级个性化。
- 推荐评测受限于真实用户行为数量，个性化指标还有提升空间。
- 当前离线实验可说明模块差异和系统可用性，但不能替代真实用户 A/B 测试。
- 当前部署配置是本地演示环境，生产环境需要进一步加强安全、容器编排、监控和密钥管理。
- 本地 RAG 延迟主要取决于 Ollama 模型大小和机器性能。
- 静态报告的 AI 分析依赖本地浏览器、报告服务和 Ollama 可访问性。

---

## 答辩说明 / Defense Notes

如果评审关注“为什么模块很多但深度不同”，可以这样解释：

> 本项目采用工程集成路线，目标是构建一个完整可运行的阅读资源发现系统。搜索模块作为基础能力做得最深入，RAG 和推荐建立在搜索证据之上，重点展示证据约束、引用、解释和评测闭环。推荐模块目前更强调可解释和行为记录，后续可以继续引入更复杂的个性化模型。

如果评审关注“智能推荐到底比传统方法强多少”，可以这样解释：

> 当前系统已经具备推荐离线评测能力，但演示数据规模和真实用户行为有限。因此本版本更谨慎地展示 Precision@10、Recall@10、NDCG@10 等指标，不夸大为工业级推荐效果。下一步会补充热门推荐、基于分类标签推荐和混合推荐的对照实验，以更直接证明改进幅度。

如果评审关注“部署和安全是否生产可用”，可以这样解释：

> 当前部署方案面向本地开发和课程答辩演示，重点是可复现运行和功能闭环。生产环境还需要开启 Elasticsearch 安全认证、替换默认密码、容器化 AI 服务、配置 HTTPS、日志审计、限流和监控。

如果评审关注“创新性在哪里”，可以这样解释：

> 本项目的创新性主要体现在应用场景和工程闭环：把馆藏数据补全、混合检索、reranker、RAG 问答、可解释推荐、行为分析和离线评测整合到同一个阅读资源发现系统中。它不是算法原创型项目，而是面向真实应用流程的工程集成创新。

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
