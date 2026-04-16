# Book Discovery and Recommendation System

Java-based book discovery, recommendation, and circulation project for graduation design, coursework, and local demo use.

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
- Book listing, detail, rating, borrowing, return, renewal, and reservation
- Recommendation overview, popular books, preference-based recommendation, and collaborative filtering
- Behavior logging for search, detail click, and recommendation click

### Search
- PostgreSQL exact matching
- Elasticsearch BM25 full-text retrieval
- Hybrid search API for keyword and natural-language queries
- Chinese query expansion rules for common categories and author aliases
- Automatic book search index sync on create, update, and logical delete

### Frontend
- Home dashboard
- Search workspace
- Book detail page
- Recommendation page
- Borrowing page
- Profile page
- Admin page

## Tech Stack

An intelligent backend-oriented system for book discovery, recommendation, and circulation management, designed for graduation projects, coursework, and portfolio demonstrations. It includes backend APIs, authentication, book circulation workflows, recommendation capabilities, and directly accessible frontend pages.

一个面向图书发现、推荐与图书流通管理的智能后端项目，适用于毕业设计、课程设计和作品集展示场景。项目包含后端 API、权限认证、图书流通业务、推荐能力，以及可直接访问的前端页面。

This project is currently better suited for **undergraduate graduation projects, coursework, and portfolio demonstrations**, with a focus on:

本项目当前更适合作为**本科毕业设计 / 课程设计 / 作品集项目**来展示，重点包括：

- Book search, details, rating, recommendation, and behavior tracking  
  图书检索、详情、评分、推荐与行为记录
- Borrowing, returning, renewal, reservation, and queue handling  
  图书借阅、归还、续借、预约与排队
- User registration, login, token refresh, and access control  
  用户注册、登录、令牌刷新与权限控制
- PostgreSQL persistence and database version management  
  PostgreSQL 持久化与数据库版本管理
- Elasticsearch-based search enhancement and hybrid retrieval groundwork  
  基于 Elasticsearch 的搜索增强与混合检索能力铺垫
- An integrated frontend-backend experience suitable for demos and defense presentations  
  适合答辩演示的前后端一体化体验

---

## Screenshots / 实际效果展示

### Home Dashboard / 首页阅读看板
![Home Dashboard](docs/images/home-dashboard.png)

### Search Workspace / 图书检索工作台
![Search Workspace](docs/images/search-workspace.png)

### Book Detail Page / 图书详情页
![Book Detail](docs/images/book-detail.png)

### Recommendation Shelf / 推荐书架页
![Recommendation Shelf](docs/images/recommendation-shelf.png)

### Borrowing Records / 借阅记录页
![Borrowing Records](docs/images/borrowing-records.png)

### Swagger API Docs / Swagger 接口文档
![Swagger UI](docs/images/swagger-ui.png)

---

## 1. Overview / 项目简介

This system is designed around two main directions: **book discovery/recommendation** and **book circulation management**. It combines a complete business workflow with recommendation and behavior tracking capabilities, and has now entered the stage of evolving from traditional search toward more intelligent retrieval.

本系统围绕 **图书发现 / 推荐** 与 **图书流通管理** 两条主线进行设计与实现，既具备完整业务闭环，也具备推荐与行为记录能力，并且当前已经进入从传统搜索向智能检索逐步演进的阶段。

It is suitable for:

适合用于：

- Graduation project defense demonstrations  
  毕业设计答辩展示
- Java backend project practice and portfolio building  
  Java 后端项目练手与作品集沉淀
- Coursework in book recommendation or library circulation management  
  图书推荐 / 图书借阅管理方向课程设计
- Future extension into a more advanced intelligent book discovery system  
  后续扩展为更完整的智能图书发现系统

The project currently targets **local development and demonstration environments**. Its configuration is more suitable for learning, development, demonstrations, and milestone reports, and it is **not recommended for direct production use without further hardening**.

项目当前默认面向**本地开发和演示环境**。当前配置更适合学习、开发、演示和阶段性汇报，**未经进一步改造不建议直接投入生产环境**。

---

## 2. Features Implemented / 当前已实现功能

### 2.1 User and Authentication / 用户与认证
- User registration, login, and logout  
  用户注册、登录、退出登录
- Access Token / Refresh Token authentication flow  
  Access Token / Refresh Token 认证流程
- Role-based access control with Spring Security  
  基于 Spring Security 的权限控制
- Guided creation of the default administrator account  
  默认管理员账号自动引导创建

### 2.2 Books and Search / 图书与检索
- Book listing with multi-condition filtering  
  图书列表与多条件筛选
- Filtering by author, category, tag, publisher, and more  
  作者、分类、标签、出版社等维度筛选
- Book detail page  
  图书详情查看
- Book rating  
  图书评分
- User behavior tracking and search logs  
  用户行为记录与搜索日志
- Elasticsearch integration for book search  
  已接入 Elasticsearch 图书搜索
- BM25 retrieval  
  已实现 BM25 检索
- Query intent classification  
  已增加查询意图分类
- First version of hybrid retrieval  
  已实现第一版混合检索
- Chinese rule-based query expansion bridging partial Chinese intents to the English corpus  
  已增加中文规则扩展，可将部分中文查询意图桥接到英文书库
- Automatic search index synchronization after book creation, update, and logical deletion  
  图书新增、修改、逻辑删除后可自动同步搜索索引
- Frontend `books.html` connected to the new search API  
  前端 `books.html` 已接入新搜索接口
- Plain text search uses the intelligent search flow, while advanced filtering still follows the original paginated filtering path  
  纯文本搜索走智能搜索链路，高级筛选继续走原有分页筛选逻辑

### 2.3 Recommendation / 推荐能力
- Popular book recommendation  
  热门图书推荐
- Preference-based recommendation  
  基于阅读偏好的推荐
- Recommendation based on rating and borrowing behavior  
  基于评分和借阅行为的推荐
- Similar book recommendation  
  相似图书推荐
- Recommendation overview shelf  
  推荐总览书架
- Homepage reading dashboard and recommendation preview  
  首页阅读看板与推荐预览
- Recommendation click tracking  
  推荐点击埋点已补齐

### 2.4 Circulation Workflow / 借阅流转
- Borrow  
  借阅
- Return  
  归还
- Renew  
  续借
- Reserve  
  预约
- Reservation queue and head-of-line borrowing priority  
  预约排队与队首优先借阅
- Borrowing status and due-date reminder display  
  借阅状态与到期提醒展示

### 2.5 Frontend Pages / 前端页面
The frontend static pages are located in `src/main/resources/static/ui`, including but not limited to:

前端静态页面位于 `src/main/resources/static/ui`，包含但不限于：

- Home dashboard  
  首页阅读看板
- Search workspace  
  图书检索工作台
- Book detail page  
  图书详情页
- Recommendation shelf page  
  推荐书架页
- Login, registration, profile center, borrowing records, and more  
  登录、注册、个人中心、借阅记录等页面

In this update, the search page usability was also improved:

在本次更新中，搜索页可用性也进一步优化，包括：

- Scrollable area refinement  
  滚动区域优化
- Overlay adjustment  
  遮罩效果优化
- Margin and layout refinement  
  边距与布局细节优化

### 2.6 Engineering and Runtime Improvements / 工程与运行能力补充
- `Dockerfile`
- `docker-compose.yml`
- Local startup scripts:
  - `start-dev.bat`
  - `scripts/start-dev.ps1`
- Improved exception handling  
  异常处理进一步收口
- Fixed some query performance issues  
  部分查询性能问题已优化
- Fixed collaborative filtering N+1 issue  
  协同过滤中的 N+1 问题已收口

### 2.7 Vector Retrieval Stage-2 Skeleton / 向量检索第二阶段骨架
The following backend groundwork has already been added for the next-stage intelligent retrieval:

为后续智能检索演进，当前已提前补齐以下后端骨架：

- Vector retrieval configuration entries  
  向量检索配置项
- Embedding request/response DTOs  
  embedding 请求/响应 DTO
- `EmbeddingProvider` abstraction  
  `EmbeddingProvider` 抽象
- Local AI service client skeleton  
  本地 AI 服务客户端骨架
- `VectorBookSearchService`  
  `VectorBookSearchService`
- Elasticsearch vector retrieval implementation  
  Elasticsearch 向量检索实现
- Reserved merge capability for `BM25 + vector` in hybrid retrieval  
  在混合检索中预留 `BM25 + vector` 合并能力
- Reserved vector fields in search documents  
  搜索文档中已预留向量字段

> **Important / 说明：**  
> Vector retrieval is currently only a backend skeleton and is **disabled by default**. It has **not yet been connected to the actual Python embedding service**, so the current production-ready search path is still mainly based on **BM25 + exact match + Chinese rule expansion**.  
> 向量检索目前仍只是后端骨架，**默认关闭**，**尚未真正接上 Python embedding 服务**，因此当前系统实际可用的搜索能力仍以 **BM25 + exact match + 中文规则扩展** 为主。

---

## 3. Tech Stack / 技术栈

### Backend / 后端
- Java 17
- Spring Boot 3.5.7
- Spring Web
- Spring Security
- Spring Data JPA
- Spring Data Elasticsearch
- Spring Validation

### Search and Retrieval / 检索与搜索
- Elasticsearch
- BM25 retrieval
- Hybrid retrieval (phase 1)
- Vector retrieval skeleton (phase 2 groundwork)

### Data and Documentation / 数据与文档
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
src/main/java/com/weidonglang/NewBookRecommendationSystem/
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
### Testing and Build / 测试与构建
- Maven
- H2 (test environment / 测试环境)
- Spring Boot Test

### Database Change Management / 数据库变更管理
- Liquibase Maven Plugin

### Engineering and Runtime / 工程运行
- Docker
- Docker Compose
- PowerShell / Batch startup scripts

---

## 4. Project Structure / 项目结构

```text
book-discovery-system/
├─ src/main/java/com/weidonglang/NewBookRecommendationSystem/
│  ├─ config/          # Configuration and bootstrap initialization / 配置与启动初始化
│  ├─ controller/      # Controller layer / 接口控制层
│  ├─ dao/             # Data access implementation / 数据访问实现
│  ├─ dto/             # Request/response DTOs / 请求与响应 DTO
│  ├─ entity/          # Entities / 数据实体
│  ├─ enums/           # Enums / 枚举定义
│  ├─ exception/       # Global exception handling / 全局异常处理
│  ├─ manager/         # Authentication and base managers / 认证与基础管理器
│  ├─ recommender/     # Recommendation logic / 推荐相关实现
│  ├─ repository/      # JPA repositories / JPA Repository
│  ├─ security/        # Security config and JWT filters / 安全配置与 JWT 过滤
│  ├─ service/         # Service layer / 业务服务层
│  ├─ transformer/     # DTO / Entity transformation / DTO 与 Entity 转换
│  └─ utils/           # Utilities / 通用工具
├─ src/main/resources/
│  ├─ application*.yml / properties
│  ├─ db/
│  ├─ static/ui/       # Frontend static pages / 前端静态页面
│  └─ ...
├─ scripts/            # Helper scripts / 辅助脚本
├─ Dockerfile
├─ docker-compose.yml
├─ pom.xml
└─ README.md
````

> If your repository name has not been changed yet, replace `book-discovery-system/` with your current folder name.
> 如果你的仓库名还没改，可以把这里替换成当前实际目录名。

---

## 5. Requirements / 运行环境要求

Recommended environment:

建议环境：

* JDK 17
* Maven 3.9+
* PostgreSQL 14+
* Elasticsearch 8.x
* IntelliJ IDEA or VS Code
  IntelliJ IDEA 或 VS Code
* Docker / Docker Compose (optional, for local deployment and demonstration)
  Docker / Docker Compose（可选，用于本地部署和演示）

---

## 6. Quick Start / 快速启动

### 6.1 Clone the Repository / 克隆项目

```bash
git clone https://github.com/weidonglang/new-book-recommendation-system.git
cd new-book-recommendation-system
```

## Quick Start

### Option A: Recommended local development flow
If Elasticsearch is enabled in your local environment, also update the related search configuration.

如果你本地启用了 Elasticsearch，也请同步修改相关搜索配置。

> Do not commit real credentials or private connection information to a public repository.
> 不要将真实账号密码或私有连接信息提交到公开仓库。

Open two terminals in the project root.

Terminal 1:

```powershell
.\start-ai-service.bat
```

Terminal 2:
You can also use the provided local startup scripts:

你也可以使用当前仓库提供的本地启动脚本：

```bash
start-dev.bat
```

or

```powershell
scripts/start-dev.ps1
```

### 6.4 Package and Run / 打包运行

```powershell
.\start-dev.bat -WithAi
```

This starts:
- PostgreSQL on `localhost:5043`
- Elasticsearch on `localhost:9200`
- Spring Boot on `http://localhost:8010/book-service`
- Local AI service on `http://127.0.0.1:8001`
### 6.5 Docker Startup / Docker 启动方式

If you want to run the project in a more standardized local environment, you can use:

如果你希望以更标准化的本地环境运行，也可以使用：

```bash
docker-compose up --build
```

> Adjust the actual service configuration according to your local environment and current repository setup.
> 请根据你自己的本地环境和当前仓库实际配置调整服务参数。

---

## 7. API Documentation / 接口文档

The project integrates springdoc OpenAPI. After startup, you can access the Swagger UI to browse the API documentation.

项目集成了 springdoc OpenAPI，启动后可通过 Swagger UI 查看接口文档。

Swagger UI:

```text
http://localhost:8010/book-service/swagger-ui/index.html
```

Frontend search page:

```text
http://localhost:8010/book-service/ui/books.html
```

### Option B: Docker app container

```powershell
docker compose up --build
```
This project is more than a basic CRUD application. It already includes:

这个项目不是只做了一个简单的 CRUD 系统，而是已经具备：

* Authentication
  认证
* Book management and search
  图书管理与检索
* Recommendation
  推荐
* Borrowing workflow
  借阅流转
* Behavior tracking
  行为记录
* Frontend demo pages
  前端演示页面
* Search index synchronization loop
  搜索索引自动同步闭环
* Frontend-backend search integration
  前后端搜索链路打通
* Early-stage intelligent retrieval groundwork
  智能检索前置骨架

This makes it a good comprehensive project for demonstrations, defense presentations, and future expansion.

因此它更适合作为一个可展示、可答辩、可继续扩展的综合项目。

### 8.2 Easy to Extend / 适合继续升级

This system can still be extended in the following directions:

这个系统后续仍可以继续往以下方向扩展：

* Stronger recommendation strategies and offline evaluation
  更强的推荐策略与离线评测
* Natural language query
  自然语言查询
* BM25 + vector hybrid retrieval phase 2
  BM25 + vector 混合检索第二版
* Retrieval-Augmented Generation (RAG)
  RAG 问答
* Recommendation explanation
  推荐理由解释
* Redis caching optimization
  Redis 缓存优化
* Admin statistics dashboard
  管理后台统计看板
* Performance benchmarking and experimental evaluation
  性能基准与实验评测

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
> A Java web system centered on book recommendation and circulation, with authentication, search, recommendation, behavior logging, frontend demo pages, Elasticsearch-based search enhancement, and a reserved vector retrieval skeleton.
> 一个以图书推荐与借阅流转为核心、具备认证、检索、推荐、行为记录、前端演示能力，并已接入 Elasticsearch 搜索增强与预埋向量检索骨架的 Java Web 系统。

At the current stage, the project has already stabilized the following:

当前阶段，本项目已经基本做稳了以下部分：

* Traditional search + frontend access
  传统搜索 + 前端接入
* Search index synchronization loop
  搜索索引同步闭环
* Search logging and behavior data collection
  搜索日志与行为数据采集
* Core circulation workflow
  核心借阅流转
* Recommendation display and interaction
  推荐展示与交互链路
* Local engineering startup and containerized support
  本地工程启动与容器化支持

If the goal is a stronger award-level project or a more impressive portfolio item, the following areas can still be improved:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify-hybrid-search.ps1 -Query "Jane Austen"
```

When AI mode is enabled and the index has been rebuilt, the strategy should show:
* Real embedding service integration
  真实 embedding 服务接入
* Vector indexing and semantic retrieval activation
  向量索引与语义检索能力启用
* Evidence retrieval for RAG
  面向 RAG 的证据检索
* Better recommendation explainability
  推荐算法解释性增强
* System performance optimization
  系统性能优化
* Visual analytics
  可视化分析
* Experimental evaluation design
  实验评测体系建设

```text
hybrid-v2(exact-db+bm25+vector)
```

More detailed local testing steps are in:
## 10. Project Progress Update / 项目进度更新

This update mainly moved forward along two lines:

本次更新主要沿着两条主线推进：

1. Make the **first version of search** a truly usable closed loop
   将“搜索第一版”补齐为真正可用的闭环
2. Prepare the backend skeleton for **vector retrieval phase 2** in advance
   提前搭建“向量检索第二阶段”的后端骨架

### 10.1 What Has Been Completed / 本次已完成内容

#### Search Line / 搜索主线

* Elasticsearch integration completed
  已完成 Elasticsearch 接入
* Book search index added
  已补齐图书搜索索引
* BM25 retrieval completed
  已实现 BM25 检索
* Query intent classification added
  已增加查询意图分类
* First version of hybrid retrieval completed
  已实现第一版混合检索
* `books.html` connected to the new search API
  `books.html` 已接入新搜索接口
* Plain text uses intelligent search, advanced filtering still uses the original paginated filtering path
  纯文本走智能搜索，高级筛选继续走原分页筛选
* Chinese query rule expansion added
  已增加中文搜索规则扩展
* Search index now synchronizes automatically on create / update / logical delete
  图书新增 / 修改 / 逻辑删除后自动同步搜索索引
* Search logging added to the new search API
  新搜索接口已记录搜索日志
* Search page scrolling area, overlay, and margins optimized
  搜索页滚动区域、遮罩和边距已优化

#### Engineering / 工程与运行

* Added `Dockerfile`
* Added `docker-compose.yml`
* Added `start-dev.bat`
* Added `scripts/start-dev.ps1`
* Closed previous exception handling issues
  收口了异常处理问题
* Added recommendation click tracking
  增加了推荐点击埋点
* Optimized part of the query performance
  优化了部分查询性能问题
* Fixed collaborative filtering N+1 issue
  修复了协同过滤 N+1 问题

#### Next-Stage Search Skeleton / 下一阶段搜索骨架

* Added vector retrieval configuration entries
  增加了向量检索配置项
* Added embedding request/response DTOs
  增加了 embedding 请求/响应 DTO
* Added `EmbeddingProvider` abstraction and local AI client skeleton
  增加了 `EmbeddingProvider` 抽象和本地 AI 服务客户端骨架
* Added `VectorBookSearchService` and Elasticsearch vector retrieval implementation
  增加了 `VectorBookSearchService` 和 Elasticsearch 向量检索实现
* Reserved `BM25 + vector` merge capability in hybrid retrieval
  在混合检索中预留了 `BM25 + vector` 的合并能力
* Reserved vector fields in search documents
  搜索文档中已预留向量字段

### 10.2 Current Search Status / 当前搜索状态说明

It should be clearly stated that:

这里需要明确说明：

> Vector retrieval is currently only a skeleton, disabled by default, and has **not yet** been connected to the real Python embedding service.
> 向量检索目前只是骨架，默认关闭，**还没有**真正接上 Python embedding 服务。

Therefore, the actual current search capability still mainly relies on:

因此，当前系统实际运行的搜索能力仍主要依赖：

* BM25
* Exact match
* Chinese rule expansion

In one sentence:

一句话概括就是：

> The project has now stabilized **traditional search + frontend access + index synchronization loop**, and the next step is to move into the real intelligent retrieval stage by connecting the Python embedding service.
> 这次已经把“传统搜索 + 前端接入 + 索引闭环”做稳了；下一步就该进入真正的智能检索阶段，也就是优先把 Python embedding 服务接起来。

---

## 11. Roadmap / 后续升级方向

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

## Current Search Status

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

## Known Limitations

- The current local embedding backend is a placeholder, so semantic quality is limited
- Natural-language retrieval works as a demo path, but ranking quality still needs improvement
- Configuration defaults are development-oriented
- The project is suitable for demo and coursework use, not direct production deployment

## Development Notes
### Phase 1: Python Embedding Service Minimum Viable Setup / 第一阶段：Python Embedding 服务最小骨架

* Create an independent Python AI service directory
  新建独立 Python AI 服务目录
* Provide an `/embed` endpoint
  提供 `/embed` 接口
* Fully connect the Java-side `EmbeddingProvider`
  打通 Java 侧 `EmbeddingProvider`

### Phase 2: Vector Indexing and Hybrid Retrieval v2 / 第二阶段：向量索引与混合检索第二版

* Enable embedding configuration
  打开 embedding 配置
* Rebuild the book index and write vectors into documents
  重建图书索引并写入向量字段
* Make natural language search actually return vector hits
  让自然语言搜索真正开始返回 vector 命中
* Complete hybrid retrieval v2
  完成混合检索第二版

### Phase 3: Evidence Retrieval Before Full RAG / 第三阶段：RAG 前置证据检索

* Accept question input
  接收问题输入
* Retrieve candidate books
  检索候选图书
* Retrieve supporting evidence snippets
  检索证据片段
* Return evidence-grounded retrieval results without answer generation first
  暂不生成答案，先返回“有依据的检索结果”

### Phase 4: RAG Answer Generation and Evaluation / 第四阶段：RAG 回答生成与实验评测

* Answer generation
  回答生成
* Experimental comparison
  实验对比
* Retrieval / answer pipeline evaluation
  检索与回答链路评测

### Phase 5: Engineering Delivery and Defense Materials / 第五阶段：工程交付与答辩材料

* Deployment documentation
  部署文档
* Test reports
  测试报告
* Performance testing
  性能测试
* Defense PPT
  答辩 PPT
* Demo video
  演示视频

When to restart what:
- If you change Java backend code: restart the backend
- If you change Python AI service code: restart the AI service
- If you change index structure or embedding write logic: restart backend and rebuild the search index
- If you only change frontend static resources: hard refresh the page, and restart backend only if needed

Useful commands:
## 12. Use Cases / 适用场景

```powershell
.\start-ai-service.bat
```

```powershell
.\start-dev.bat -WithAi
```

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-search-index.ps1
```
* Undergraduate graduation projects
  本科毕业设计
* Java Web coursework
  Java Web 课程设计
* Backend practice projects
  后端开发练手项目
* Learning in recommendation system direction
  图书推荐系统方向学习
* Portfolio and resume showcase
  简历项目展示

It is especially suitable for scenarios where you want to show both:

它尤其适合用于同时展示以下两部分能力的场景：

* Business workflow completeness
  业务流程完整性
* A clear technical evolution path from traditional retrieval to intelligent retrieval
  从传统检索走向智能检索的技术演进路线

---

## 13. Notes / 说明

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
3. Vector retrieval is currently only a reserved backend skeleton and is not enabled in the default runnable path.
   当前向量检索仅为预埋后端骨架，并不属于默认可运行链路中的正式能力。

4. If your repository is still under active development, please refer to the latest implementation in your current branch.
   若你当前仓库代码仍在持续更新，请以你自己最新分支中的实际实现为准。

## Screenshots

If the image assets exist in your branch, you can use:
## 14. License / 开源许可

- `docs/images/home-dashboard.png`
- `docs/images/search-workspace.png`
- `docs/images/book-detail.png`
- `docs/images/recommendation-shelf.png`
- `docs/images/borrowing-records.png`
- `docs/images/swagger-ui.png`

## License

See the repository `LICENSE` file if present.

