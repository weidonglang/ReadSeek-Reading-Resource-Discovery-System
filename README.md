# Book Discovery and Recommendation System  
# 图书发现与推荐系统

Java-based book discovery, recommendation, and circulation project for graduation design, coursework, and local demo use.  
一个基于 Java 的图书发现、推荐与借阅流通系统项目，适用于毕业设计、课程设计与本地演示场景。

## Current Status / 当前状态

- Search, recommendation, borrowing, reservation, rating, and authentication flows are available  
  已实现检索、推荐、借阅、预约、评分与认证等核心业务流程
- Frontend demo pages are included under `src/main/resources/static/ui`  
  已包含前端演示页面，位置在 `src/main/resources/static/ui`
- Elasticsearch-based search is integrated  
  已集成基于 Elasticsearch 的检索能力
- `hybrid-v2` search path is available: exact match + BM25 + vector  
  `hybrid-v2` 搜索链路可用：精确匹配 + BM25 + 向量检索
- A minimal local Python AI service is included and connected for embedding integration testing  
  已包含并接通最小本地 Python AI 服务，用于 embedding 集成测试
- Vector retrieval has entered the skeleton + integration testing stage, but it is not yet the final production-grade semantic retrieval solution  
  向量检索目前已进入“骨架 + 集成测试可用”阶段，但还不是最终生产级语义检索方案

This repository is suitable for:  
本仓库适合用于：

- Graduation project demo  
  毕业设计演示
- Java Web coursework  
  Java Web 课程设计
- Backend portfolio project  
  后端作品集项目
- A base system for further work on hybrid retrieval, RAG, and explainable recommendation  
  作为后续继续扩展混合检索、RAG 和可解释推荐的基础系统

This is a local-development and demo-oriented version, not a production-hardened release.  
当前版本主要面向本地开发与演示，并不是经过生产环境强化的正式发布版本。

---

## Features / 功能概览

### Core Business / 核心业务
- User registration, login, refresh token flow, and role-based access control  
  用户注册、登录、刷新令牌流程与基于角色的权限控制
- Book listing, detail, rating, borrowing, return, renewal, and reservation  
  图书列表、详情、评分、借阅、归还、续借与预约
- Recommendation overview, popular books, preference-based recommendation, and collaborative filtering  
  推荐总览、热门图书、偏好推荐与协同过滤推荐
- Behavior logging for search, detail click, and recommendation click  
  检索行为、详情点击与推荐点击埋点记录

### Search / 检索能力
- PostgreSQL exact matching  
  PostgreSQL 精确匹配
- Elasticsearch BM25 full-text retrieval  
  Elasticsearch BM25 全文检索
- Hybrid search API for keyword and natural-language queries  
  面向关键词与自然语言查询的混合搜索 API
- Chinese query expansion rules for common categories and author aliases  
  面向常见分类与作者别名的中文查询扩展规则
- Automatic book search index sync on create, update, and logical delete  
  图书新增、更新、逻辑删除后自动同步搜索索引

### Frontend / 前端页面
- Home dashboard  
  首页阅读看板
- Search workspace  
  图书检索工作台
- Book detail page  
  图书详情页
- Recommendation page  
  推荐书架页
- Borrowing page  
  借阅记录页
- Profile page  
  个人中心页
- Admin page  
  管理后台页

---

## 1. Overview / 项目简介

This system is designed around two main directions: **book discovery / recommendation** and **book circulation management**. It combines a complete business workflow with recommendation and behavior tracking capabilities, and has entered the stage of evolving from traditional retrieval toward more intelligent retrieval.  
本系统围绕 **图书发现 / 推荐** 与 **图书流通管理** 两条主线进行设计与实现，既具备完整业务闭环，也具备推荐与行为记录能力，并且当前已经进入从传统检索向智能检索逐步演进的阶段。

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

## 2. Screenshots / 实际效果展示

> Since `README.md` is located at the repository root and the screenshot assets are stored under `docs/images/`, the image links below use relative paths such as `docs/images/xxx.png`.  
> 由于 `README.md` 位于仓库根目录，截图资源位于 `docs/images/` 目录下，因此下方统一使用 `docs/images/xxx.png` 作为相对路径。

### Home Dashboard / 首页阅读看板
![Home Dashboard / 首页阅读看板](docs/images/home-dashboard.png)

### Search Workspace / 图书检索工作台
![Search Workspace / 图书检索工作台](docs/images/search-workspace.png)

### Book Detail Page / 图书详情页
![Book Detail Page / 图书详情页](docs/images/book-detail.png)

### Recommendation Shelf / 推荐书架页
![Recommendation Shelf / 推荐书架页](docs/images/recommendation-shelf.png)

### Borrowing Records / 借阅记录页
![Borrowing Records / 借阅记录页](docs/images/borrowing-records.png)

### Swagger API Docs / Swagger 接口文档
![Swagger UI / Swagger 接口文档](docs/images/swagger-ui.png)

---

## 3. Features Implemented / 当前已实现功能

### 3.1 User and Authentication / 用户与认证
- User registration, login, and logout  
  用户注册、登录、退出登录
- Access Token / Refresh Token authentication flow  
  Access Token / Refresh Token 认证流程
- Role-based access control with Spring Security  
  基于 Spring Security 的权限控制
- Guided creation of the default administrator account  
  默认管理员账号自动引导创建

### 3.2 Books and Search / 图书与检索
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

### 3.3 Recommendation / 推荐能力
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

### 3.4 Circulation Workflow / 借阅流转
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

### 3.5 Frontend Pages / 前端页面
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

### 3.6 Engineering and Runtime Improvements / 工程与运行能力补充
- `Dockerfile`
- `docker-compose.yml`
- Local startup scripts / 本地启动脚本
  - `start-dev.bat`
  - `scripts/start-dev.ps1`
- Improved exception handling  
  异常处理进一步收口
- Fixed some query performance issues  
  部分查询性能问题已优化
- Fixed collaborative filtering N+1 issue  
  协同过滤中的 N+1 问题已收口

### 3.7 Vector Retrieval and AI Integration / 向量检索与 AI 集成
The following backend groundwork and integration work have already been added for the next-stage intelligent retrieval:  
为后续智能检索演进，当前已补齐以下后端能力与集成基础：

- Vector retrieval configuration entries  
  向量检索配置项
- Embedding request / response DTOs  
  Embedding 请求 / 响应 DTO
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
- Minimal local Python AI service for embedding integration testing  
  用于 embedding 集成测试的最小本地 Python AI 服务
- Local embedding service integration path connected for development and verification  
  面向开发与验证场景的本地 embedding 服务集成链路已打通

> **Important / 说明**  
> Vector retrieval has already reached the **skeleton + integration testing** stage. The project includes a minimal local Python AI service, and the local embedding integration path is available for development verification. When AI mode is enabled and the index is prepared correctly, the system can run the `hybrid-v2` path (`exact-db + bm25 + vector`).  
> 向量检索目前已经进入**骨架 + 集成测试可用**阶段。项目内已包含最小本地 Python AI 服务，并且本地 embedding 集成链路可用于开发验证；在启用 AI 模式且索引准备正确后，系统可以运行 `hybrid-v2` 路径（`exact-db + bm25 + vector`）。

> At the same time, the current embedding backend is still a **minimal test-oriented implementation**, intended mainly for integration and workflow verification rather than final production-grade semantic retrieval. In other words, it is **connected and testable**, but **not yet the final retrieval-quality target**.  
> 同时，当前 embedding 后端仍然属于**面向测试的最小实现**，主要用于集成与链路验证，而不是最终的生产级语义检索方案。也就是说，它现在是**已接通、可测试**的，但**还不是最终检索质量目标**。

---

## 4. Tech Stack / 技术栈

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
- BM25 retrieval / BM25 检索
- Hybrid retrieval / 混合检索
- Vector retrieval skeleton + integration testing path / 向量检索骨架 + 集成测试链路

### Data and Documentation / 数据与文档
- PostgreSQL
- Elasticsearch 8
- Liquibase
- MapStruct
- Lombok
- Swagger UI / springdoc OpenAPI
- Python 3 for the local AI service / 用于本地 AI 服务的 Python 3
- Docker / Docker Compose

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
  PowerShell / Batch 启动脚本

---

## 5. Repository Structure / 仓库结构

### 5.1 Repository Structure Snapshot / 仓库结构快照

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
````

### 5.2 Project Structure / 项目结构

```text
new-book-recommendation-system/
├─ src/main/java/com/weidonglang/NewBookRecommendationSystem/
│  ├─ config/          # Configuration and bootstrap initialization / 配置与启动初始化
│  ├─ controller/      # Controller layer / 接口控制层
│  ├─ dao/             # Data access implementation / 数据访问实现
│  ├─ dto/             # Request / response DTOs / 请求与响应 DTO
│  ├─ entity/          # Entities / 数据实体
│  ├─ enums/           # Enums / 枚举定义
│  ├─ exception/       # Global exception handling / 全局异常处理
│  ├─ manager/         # Authentication and base managers / 认证与基础管理器
│  ├─ recommender/     # Recommendation logic / 推荐相关实现
│  ├─ repository/      # JPA repositories / JPA Repository
│  ├─ search/          # Search-related modules / 搜索相关模块
│  ├─ security/        # Security config and JWT filters / 安全配置与 JWT 过滤器
│  ├─ service/         # Service layer / 业务服务层
│  ├─ transformer/     # DTO / Entity transformation / DTO 与 Entity 转换
│  └─ utils/           # Utilities / 通用工具
├─ src/main/resources/
│  ├─ application*.yml / properties
│  ├─ db/
│  ├─ static/ui/       # Frontend static pages / 前端静态页面
│  └─ ...
├─ ai-service/         # Local Python AI service / 本地 Python AI 服务
├─ docs/               # Project docs and screenshots / 项目文档与截图
├─ scripts/            # Helper scripts / 辅助脚本
├─ Dockerfile
├─ docker-compose.yml
├─ pom.xml
└─ README.md
```

> If your repository name has not been changed yet, replace `new-book-recommendation-system/` with your current folder name.
> 如果你的仓库名还没改，可以把这里替换成当前实际目录名。

---

## 6. Requirements / 运行环境要求

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

## 7. Quick Start / 快速启动

### 7.1 Clone the Repository / 克隆项目

```bash
git clone https://github.com/weidonglang/new-book-recommendation-system.git
cd new-book-recommendation-system
```

### 7.2 Option A: Recommended Local Development Flow / 推荐本地开发流程

If Elasticsearch is enabled in your local environment, also update the related search configuration.
如果你本地启用了 Elasticsearch，也请同步修改相关搜索配置。

> Do not commit real credentials or private connection information to a public repository.
> 不要将真实账号密码或私有连接信息提交到公开仓库。

Open two terminals in the project root.
在项目根目录打开两个终端。

Terminal 1 / 终端 1：

```powershell
.\start-ai-service.bat
```

Terminal 2 / 终端 2：

You can also use the provided local startup scripts:
你也可以使用当前仓库提供的本地启动脚本：

```bash
start-dev.bat
```

or / 或者

```powershell
scripts/start-dev.ps1
```

### 7.3 Package and Run / 打包运行

```powershell
.\start-dev.bat -WithAi
```

This starts:
这将启动：

* PostgreSQL on `localhost:5043`
  PostgreSQL 服务地址：`localhost:5043`
* Elasticsearch on `localhost:9200`
  Elasticsearch 服务地址：`localhost:9200`
* Spring Boot on `http://localhost:8010/book-service`
  Spring Boot 服务地址：`http://localhost:8010/book-service`
* Local AI service on `http://127.0.0.1:8001`
  本地 AI 服务地址：`http://127.0.0.1:8001`

### 7.4 Docker Startup / Docker 启动方式

If you want to run the project in a more standardized local environment, you can use:
如果你希望以更标准化的本地环境运行，也可以使用：

```bash
docker-compose up --build
```

or / 或者

```powershell
docker compose up --build
```

This starts the app, PostgreSQL, and Elasticsearch inside Docker.
这会在 Docker 中启动应用、PostgreSQL 和 Elasticsearch。

> Adjust the actual service configuration according to your local environment and current repository setup.
> 请根据你自己的本地环境和当前仓库实际配置调整服务参数。

### 7.5 Default Accounts and Local Config / 默认账号与本地配置

Default bootstrap admin / 默认初始化管理员账号：

* Email: `admin@booknook.local`
* Password: `Admin123!`

Default Docker database / 默认 Docker 数据库配置：

* Database: `book_recommendation_system`
* Username: `postgres`
* Password: `postgres`

Important / 注意：

* If your local PostgreSQL volume already contains old data, your actual password may be different
  如果你的本地 PostgreSQL 数据卷已经存在旧数据，那么实际密码可能不同
* In that case, override the backend connection password when starting locally
  这种情况下，请在本地启动时覆盖后端数据库连接密码

For example / 例如：

```powershell
.\start-dev.bat -WithAi -DbPassword 20041117
```

---

## 8. API Documentation / 接口文档

The project integrates springdoc OpenAPI. After startup, you can access the Swagger UI to browse the API documentation.
项目集成了 springdoc OpenAPI，启动后可通过 Swagger UI 查看接口文档。

Swagger UI:

```text
http://localhost:8010/book-service/swagger-ui/index.html
```

Frontend search page / 前端搜索页面：

```text
http://localhost:8010/book-service/ui/books.html
```

---

## 9. Search and Vector Testing / 搜索与向量测试

### 9.1 Rebuild the Search Index / 重建搜索索引

Run after startup:
启动完成后执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\rebuild-search-index.ps1
```

Expected result / 预期结果：

* successful login
  登录成功
* `Book search index rebuilt successfully.`
* `indexedCount > 0`

### 9.2 Verify Hybrid Search / 验证混合搜索

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
当启用 AI 模式并完成索引重建后，策略应显示：

```text
hybrid-v2(exact-db+bm25+vector)
```

More detailed local testing steps are in:
更详细的本地测试步骤见：

* [docs/vector-local-test-checklist.md](docs/vector-local-test-checklist.md)

---

## 10. Python AI Service / Python AI 服务

The current local AI service is intentionally minimal.
当前本地 AI 服务被有意设计为最小可用版本。

It provides:
当前提供：

* `GET /health`
* `POST /embed`

Current embedding backend:
当前 embedding 后端：

* deterministic `hash-bow`
* intended for integration and workflow testing
  用于集成与流程验证
* not a final semantic model
  不是最终语义模型

Details / 详细说明：

* [ai-service/README.md](ai-service/README.md)
* [docs/vector-retrieval-ai-service-plan.md](docs/vector-retrieval-ai-service-plan.md)

---

## 11. Current Search Status / 当前搜索状态

Implemented now / 当前已实现：

* exact match
  精确匹配
* BM25 retrieval
  BM25 检索
* hybrid search API
  混合搜索 API
* `hybrid-v2` path available
  `hybrid-v2` 路径可用
* vector retrieval skeleton and integration
  向量检索骨架与集成链路
* local embedding service integration
  本地 embedding 服务集成
* Chinese query expansion for some common natural-language cases
  面向部分常见自然语言场景的中文查询扩展

Not finished yet / 尚未完成：

* real production-grade embedding model
  真实生产级 embedding 模型
* final retrieval quality tuning
  最终检索质量调优
* RAG evidence retrieval and answer generation
  RAG 证据检索与答案生成
* benchmark-quality retrieval evaluation
  基准级检索评测

> A Java web system centered on book recommendation and circulation, with authentication, search, recommendation, behavior logging, frontend demo pages, Elasticsearch-based search enhancement, and a connected vector-retrieval integration path for local testing.
> 一个以图书推荐与借阅流转为核心、具备认证、检索、推荐、行为记录、前端演示能力，并已接入 Elasticsearch 搜索增强，同时具备本地测试可用的向量检索集成链路的 Java Web 系统。

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
* Local AI integration testing path
  本地 AI 集成测试链路

It should be clearly stated that:
这里需要明确说明：

> Vector retrieval is already connected for local integration testing through a minimal Python AI service, and `hybrid-v2` is available when the relevant mode and index preparation are enabled. However, the current embedding backend is still a lightweight test-oriented implementation rather than a final production-grade semantic retrieval solution.
> 向量检索已经通过最小 Python AI 服务打通了本地集成测试链路，并且在启用相应模式和完成索引准备后可以使用 `hybrid-v2`；但当前 embedding 后端仍然是轻量级、面向测试的实现，而不是最终生产级语义检索方案。

Therefore, the actual current search capability can be understood as:
因此，当前系统实际运行的搜索能力可以理解为：

* BM25
* Exact match / 精确匹配
* Chinese rule expansion / 中文规则扩展
* Optional local vector path for integration testing and hybrid verification
  可选的本地向量链路，用于集成测试和混合检索验证

In one sentence:
一句话概括：

> The project has now stabilized **traditional search + frontend access + index synchronization loop**, and it has already connected a **minimal local AI integration path** for `hybrid-v2` and vector-related workflow testing; the next step is to upgrade the embedding backend and retrieval quality.
> 这次已经把“传统搜索 + 前端接入 + 索引闭环”做稳了，并且已经打通了面向 `hybrid-v2` 与向量相关流程验证的**最小本地 AI 集成链路**；下一步重点是继续升级 embedding 后端和检索质量。

---

## 12. Project Progress Update / 项目进度更新

This update mainly moved forward along two lines:
本次更新主要沿着两条主线推进：

1. Make the **first version of search** a truly usable closed loop
   将“搜索第一版”补齐为真正可用的闭环
2. Prepare and connect the backend foundation for **vector retrieval phase 2**
   提前搭建并接通“向量检索第二阶段”的后端基础链路

### 12.1 What Has Been Completed / 本次已完成内容

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

#### Next-Stage Search Foundation / 下一阶段搜索基础

* Added vector retrieval configuration entries
  增加了向量检索配置项
* Added embedding request / response DTOs
  增加了 embedding 请求 / 响应 DTO
* Added `EmbeddingProvider` abstraction and local AI client skeleton
  增加了 `EmbeddingProvider` 抽象和本地 AI 服务客户端骨架
* Added `VectorBookSearchService` and Elasticsearch vector retrieval implementation
  增加了 `VectorBookSearchService` 和 Elasticsearch 向量检索实现
* Reserved `BM25 + vector` merge capability in hybrid retrieval
  在混合检索中预留了 `BM25 + vector` 的合并能力
* Reserved vector fields in search documents
  搜索文档中已预留向量字段
* Connected the local embedding service integration path for testing
  已打通本地 embedding 服务测试集成链路

---

## 13. Project Value and Extension Directions / 项目价值与扩展方向

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
* Local vector / embedding integration verification path
  本地向量 / embedding 集成验证链路

This makes it a good comprehensive project for demonstrations, defense presentations, and future expansion.
因此它更适合作为一个可展示、可答辩、可继续扩展的综合项目。

### 13.1 Easy to Extend / 适合继续升级

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

### 13.2 Roadmap / 后续升级方向

Near-term priorities / 近期重点：

1. Replace the placeholder embedding backend with a real local embedding model
   用真实本地 embedding 模型替换当前占位实现
2. Improve hybrid retrieval quality and query rewrite rules
   提升混合检索质量与查询改写规则
3. Build RAG evidence retrieval
   构建 RAG 证据检索能力
4. Add answer generation with citation
   增加带引用的答案生成
5. Add evaluation for retrieval, recommendation, and QA
   增加检索、推荐与问答的评测体系

---

## 14. Development Notes / 开发说明

### 14.1 Development Phases / 开发阶段

#### Phase 1: Python Embedding Service Minimum Viable Setup / 第一阶段：Python Embedding 服务最小骨架

* Create an independent Python AI service directory
  新建独立 Python AI 服务目录
* Provide an `/embed` endpoint
  提供 `/embed` 接口
* Fully connect the Java-side `EmbeddingProvider`
  打通 Java 侧 `EmbeddingProvider`

#### Phase 2: Vector Indexing and Hybrid Retrieval v2 / 第二阶段：向量索引与混合检索第二版

* Enable embedding configuration
  打开 embedding 配置
* Rebuild the book index and write vectors into documents
  重建图书索引并写入向量字段
* Make natural language search actually return vector hits
  让自然语言搜索真正开始返回 vector 命中
* Complete hybrid retrieval v2
  完成混合检索第二版

#### Phase 3: Evidence Retrieval Before Full RAG / 第三阶段：RAG 前置证据检索

* Accept question input
  接收问题输入
* Retrieve candidate books
  检索候选图书
* Retrieve supporting evidence snippets
  检索证据片段
* Return evidence-grounded retrieval results without answer generation first
  暂不生成答案，先返回“有依据的检索结果”

#### Phase 4: RAG Answer Generation and Evaluation / 第四阶段：RAG 回答生成与实验评测

* Answer generation
  回答生成
* Experimental comparison
  实验对比
* Retrieval / answer pipeline evaluation
  检索与回答链路评测

#### Phase 5: Engineering Delivery and Defense Materials / 第五阶段：工程交付与答辩材料

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

### 14.2 When to Restart What / 什么时候需要重启什么

* If you change Java backend code: restart the backend
  如果修改了 Java 后端代码：重启后端
* If you change Python AI service code: restart the AI service
  如果修改了 Python AI 服务代码：重启 AI 服务
* If you change index structure or embedding write logic: restart backend and rebuild the search index
  如果修改了索引结构或 embedding 写入逻辑：重启后端并重建搜索索引
* If you only change frontend static resources: hard refresh the page, and restart backend only if needed
  如果只修改了前端静态资源：强制刷新页面，必要时再重启后端

### 14.3 Useful Commands / 常用命令

```powershell
.\start-ai-service.bat
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

---

## 15. Use Cases / 适用场景

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

## 16. Known Limitations and Notes / 已知限制与说明

### 16.1 Known Limitations / 已知限制

* The current local embedding backend is a placeholder, so semantic quality is limited
  当前本地 embedding 后端仍是占位实现，因此语义质量有限
* Natural-language retrieval works as a demo path, but ranking quality still needs improvement
  自然语言检索目前可以作为演示链路运行，但排序质量仍需提升
* Configuration defaults are development-oriented
  默认配置偏向开发环境
* The project is suitable for demo and coursework use, not direct production deployment
  本项目适合演示和课程设计使用，不建议直接用于生产部署

## 17. License / 开源许可

See the repository `LICENSE` file if present.
如仓库中存在 `LICENSE` 文件，请以该文件为准。
