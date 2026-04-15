# Book Discovery and Circulation Management System 
## 图书发现与图书流通管理系统

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
- An integrated frontend-backend experience suitable for demos and defense presentations  
  适合答辩演示的前后端一体化体验

---

## Screenshots / 实际效果展示

### Home Dashboard / 首页阅读看板
![Home Dashboard](home-dashboard.png)

### Search Workspace / 图书检索工作台
![Search Workspace](search-workspace.png)

### Book Detail Page / 图书详情页
![Book Detail](book-detail.png)

### Recommendation Shelf / 推荐书架页
![Recommendation Shelf](recommendation-shelf.png)

### Borrowing Records / 借阅记录页
![Borrowing Records](borrowing-records.png)

### Swagger API Docs / Swagger 接口文档
![Swagger UI](swagger-ui.png)

---

## 1. Overview / 项目简介

This system is designed around two main directions: **book discovery/recommendation** and **book circulation management**. It combines a complete business workflow with recommendation and behavior tracking capabilities, making it suitable for:

本系统围绕 **图书发现 / 推荐** 与 **图书流通管理** 两条主线进行设计与实现，既具备完整业务闭环，也具备推荐与行为记录能力，适合用于：

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

---

## 3. Tech Stack / 技术栈

### Backend / 后端
- Java 17
- Spring Boot 3.5.7
- Spring Web
- Spring Security
- Spring Data JPA
- Spring Validation

### Data and Documentation / 数据与文档
- PostgreSQL
- JWT (`com.auth0:java-jwt`)
- springdoc OpenAPI (Swagger UI)
- MapStruct
- Lombok

### Testing and Build / 测试与构建
- Maven
- H2 (test environment / 测试环境)
- Spring Boot Test

### Database Change Management / 数据库变更管理
- Liquibase Maven Plugin

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
* IntelliJ IDEA or VS Code
  IntelliJ IDEA 或 VS Code

---

## 6. Quick Start / 快速启动

### 6.1 Clone the Repository / 克隆项目

```bash
git clone https://github.com/weidonglang/new-book-recommendation-system.git
cd new-book-recommendation-system
```

> If you rename the repository later, update the clone URL accordingly.
> 如果你后续修改了仓库名，请同步更新克隆地址。

### 6.2 Configure the Database / 配置数据库

Update your local database connection settings in the configuration file, including:

请在配置文件中修改你自己的本地数据库连接信息，包括：

* Database host
  数据库地址
* Database port
  数据库端口
* Database name
  数据库名称
* Username
  用户名
* Password
  密码

> Do not commit real credentials or private connection information to a public repository.
> 不要将真实账号密码或私有连接信息提交到公开仓库。

### 6.3 Install Dependencies and Run / 安装依赖并启动

```bash
./mvnw spring-boot:run
```

Windows:

```bash
mvnw.cmd spring-boot:run
```

### 6.4 Package and Run / 打包运行

```bash
./mvnw clean package
java -jar target/book-recommendation-system-0.0.1-SNAPSHOT.jar
```

---

## 7. API Documentation / 接口文档

The project integrates springdoc OpenAPI. After startup, you can access the Swagger UI to browse the API documentation.

项目集成了 springdoc OpenAPI，启动后可通过 Swagger UI 查看接口文档。

A common local access URL is:

常见的本地访问地址通常如下：

```text
http://localhost:8010/swagger-ui/index.html
```

If you changed the port, context path, or reverse proxy settings, use your actual runtime address.

若你本地修改过端口、上下文路径或反向代理配置，请以实际运行地址为准。

---

## 8. Highlights / 项目特点

### 8.1 A Relatively Complete Business Workflow / 业务链路比较完整

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

This makes it a good comprehensive project for demonstrations, defense presentations, and future expansion.

因此它更适合作为一个可展示、可答辩、可继续扩展的综合项目。

### 8.2 Easy to Extend / 适合继续升级

This system can be extended in the following directions:

这个系统后续可以继续往以下方向扩展：

* Stronger recommendation strategies and offline evaluation
  更强的推荐策略与离线评测
* Elasticsearch-based full-text search
  Elasticsearch 全文检索
* Natural language query
  自然语言查询
* Retrieval-Augmented Generation (RAG)
  RAG 问答
* Recommendation explanation
  推荐理由解释
* Redis caching optimization
  Redis 缓存优化
* Docker deployment
  Docker 部署
* Admin statistics dashboard
  管理后台统计看板

### 8.3 Suitable for a Stronger Graduation Project Theme / 适合毕业设计主线升级

If you want to further upgrade this project into a stronger graduation project, the research theme can gradually evolve into:

如果你后续希望把这个项目进一步提升为更强的毕设题目，可以将论文主线逐步收敛到：

**A system for retrieval, question answering, and recommendation for natural-language-based book discovery**
**面向自然语言图书发现的检索、问答与推荐系统**

In other words, it can grow from a “book recommendation and circulation management system” into a system centered on:

也就是从“图书推荐与借阅管理系统”进一步升级为：

* Hybrid retrieval
  混合检索
* Evidence-grounded question answering
  证据驱动问答
* Explainable recommendation
  可解释推荐

This transition helps the project move from pure engineering implementation toward a more research-oriented graduation project.

这样能让项目从“工程实现”进一步走向“研究型毕设”。

---

## 9. Current Positioning / 当前阶段定位

The current version is better described as:

当前版本更适合定义为：

> A Java web system centered on book recommendation and circulation, with authentication, search, recommendation, behavior logging, and frontend demo pages.
> 一个以图书推荐与借阅流转为核心、具备认证、检索、推荐、行为记录与前端演示能力的 Java Web 系统。

It already provides a solid foundation for a graduation project. If the goal is a stronger award-level project or a more impressive portfolio item, the following areas can still be improved:

它已经具备不错的毕业设计基础，但如果目标是“更强的优秀毕设 / 更亮眼的简历项目”，还可以继续在以下方向做增强：

* Retrieval capability upgrades
  检索能力升级
* Better recommendation explainability
  推荐算法解释性增强
* System performance optimization
  系统性能优化
* Visual analytics
  可视化分析
* Engineering deployment
  工程化部署
* Experimental evaluation design
  实验评测体系建设

---

## 10. Roadmap / 后续升级方向

Suggested progression:

建议按以下顺序推进：

### Phase 1: Engineering Improvements / 第一阶段：工程完善

* Improve exception handling
  完善异常处理
* Standardize response format
  统一返回格式
* Complete API comments and documentation
  补齐接口注释
* Improve logging
  完善日志体系
* Strengthen parameter validation
  优化参数校验

### Phase 2: Recommendation Enhancement / 第二阶段：推荐能力增强

* Refactor recommendation strategies
  推荐策略拆分与重构
* Further decouple popular / collaborative / content-based recommendation
  热门推荐 / 协同推荐 / 内容推荐进一步解耦
* Add recommendation explanation display
  推荐结果解释展示
* Add offline recommendation evaluation
  推荐效果离线评测

### Phase 3: Retrieval Enhancement / 第三阶段：检索能力增强

* Introduce Elasticsearch
  引入 Elasticsearch
* Support full-text search
  支持全文检索
* Support more advanced filtering and sorting
  支持更复杂的筛选与排序
* Prepare for natural language book search
  为自然语言搜书做铺垫

### Phase 4: Intelligent Features / 第四阶段：智能化能力增强

* Natural language query
  自然语言查询
* Retrieval-Augmented Generation (RAG)
  检索增强问答（RAG）
* Book comparison QA
  图书比较问答
* Reading path suggestion
  阅读路径建议
* Natural language recommendation explanations
  推荐理由自然语言生成

### Phase 5: Engineering Delivery / 第五阶段：工程化与答辩交付

* Docker / Docker Compose
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

---

## 11. Use Cases / 适用场景

This project is suitable for:

本项目适用于：

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

---

## 12. Notes / 说明

1. Use your own local configuration for database connection, credentials, and other private settings.
   项目中的数据库连接、账号密码等私有配置请使用你自己的本地环境配置。

2. The “roadmap” section describes future extensions and does not mean all features have already been implemented.
   README 中的“后续升级方向”属于扩展规划，不代表这些能力已经全部完成。

3. If your repository is still under active development, please refer to the latest implementation in your current branch.
   若你当前仓库代码仍在持续更新，请以你自己最新分支中的实际实现为准。

---

## 13. License / 开源许可

This project is released under the open-source license declared in the current repository. See the `LICENSE` file for details.

本项目采用仓库当前声明的开源许可证，详情见 `LICENSE` 文件。

