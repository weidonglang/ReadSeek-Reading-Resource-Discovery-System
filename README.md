# New Book Recommendation System

一个面向图书场景的推荐与流通管理系统，后端基于 **Spring Boot + Spring Security + JPA/Hibernate + PostgreSQL + Liquibase** 构建，提供用户注册登录、图书管理、作者管理、标签与出版社管理、图书评分、个性化推荐、借阅、续借、预约排队等能力。

---

## 项目简介

`new-book-recommendation-system` 是一个以“图书推荐 + 图书馆流通管理”为核心的后端项目。除了基础的图书、作者、用户数据管理之外，系统还实现了：

- 基于 JWT 的认证与会话刷新
- 按分类、作者、标签、出版社等条件对图书进行筛选与分页查询
- 基于热门度、阅读偏好、用户行为的推荐结果聚合
- 图书相似推荐
- 图书评分系统
- 图书借阅、归还、续借
- 无库存时的预约排队机制
- Liquibase 驱动的数据库结构管理
- JSON / 列表数据导入脚本

该项目适合作为：

- 图书推荐系统课程设计 / 毕设后端
- Spring Boot 权限与业务建模练习项目
- 推荐系统与业务系统结合的 Demo / 原型项目

---

## 核心功能

### 1. 用户与认证

- 用户注册
- 校验邮箱是否已存在
- 用户登录
- 获取当前登录用户信息
- 刷新 access token
- 用户登出
- 用户基础资料修改
- 用户阅读偏好录入与查询

### 2. 图书域管理

- 图书详情查询
- 按作者查询图书
- 图书分类查询
- 图书分页 / 过滤查询
- 管理员新增、批量新增、修改、删除图书
- 支持图书库存字段：`totalCopies`、`availableCopies`

### 3. 作者 / 出版社 / 标签管理

- 作者分页筛选与 CRUD
- 出版社查询与 CRUD
- 标签查询与 CRUD

### 4. 推荐能力

系统当前实现的推荐能力包括：

- **Popular Right Now**：按评分人数、平均分、库存等综合排序
- **Because Of Your Reading Preferences**：根据用户选择的阅读偏好分类推荐
- **Based On Your Ratings And Loans**：根据评分、当前借阅、历史借阅行为推荐
- **Similar Books**：围绕某一本书，按同分类与共享标签生成相关推荐

> 仓库中还保留了 `CollaborativeFilteringRecommender`，实现了基于用户相似度（Pearson）的协同过滤推荐逻辑，可作为后续算法升级基础。

### 5. 借阅与预约

- 查看当前用户正在借阅的图书
- 查看借阅历史
- 借书
- 还书
- 续借
- 查看当前用户的有效预约
- 查看预约历史
- 发起预约
- 取消预约
- 查看某本书的预约队列摘要

当图书无可借库存时，用户可进入预约队列；当图书有排队预约时，只有排队第一位用户才可优先借阅。

---

## 技术栈

### 后端

- Java 11
- Spring Boot 2.7.5
- Spring Web
- Spring Security
- Spring Data JPA
- Hibernate
- Validation
- Lombok
- MapStruct
- JWT（`com.auth0:java-jwt`）
- springdoc-openapi-ui

### 数据库与迁移

- PostgreSQL
- Liquibase

### 数据脚本

- Node.js 脚本生成 SQL 种子数据 / 增量导入 SQL

---

## 项目结构

```text
new-book-recommendation-system/
├─ src/main/java/com/henry/bookrecommendationsystem/
│  ├─ config/                # 启动初始化配置，如默认管理员账号
│  ├─ controller/            # REST API 入口
│  ├─ dao/                   # 业务数据访问层
│  ├─ dto/                   # 请求 / 响应 DTO
│  ├─ entity/                # JPA 实体
│  ├─ enums/                 # 枚举定义
│  ├─ exception/             # 全局异常处理
│  ├─ manager/               # JWT 认证管理逻辑
│  ├─ recommender/           # 推荐算法实现
│  ├─ repository/            # Spring Data Repository
│  ├─ security/              # 安全配置、过滤器、UserDetailsService
│  ├─ service/               # 业务服务层
│  ├─ transformer/           # Entity / DTO 转换
│  └─ utils/                 # 工具类
├─ src/main/resources/
│  ├─ application.properties # 应用配置
│  ├─ db/                    # Liquibase 变更集
│  └─ json/                  # 初始化数据源（由脚本使用）
├─ scripts/
│  ├─ generated/             # 生成后的 SQL 文件
│  ├─ generate-json-seed-sql.js
│  └─ generate-list-import-sql.js
├─ pom.xml
└─ README.md


````

---

## 当前实现的系统架构

项目整体采用较清晰的分层结构：

* **Controller 层**：接收 HTTP 请求，统一返回 `ApiResponse`
* **Service 层**：承载核心业务逻辑，例如推荐、借阅、预约、权限控制
* **DAO / Repository 层**：执行数据访问与复杂查询
* **Transformer / Mapper 层**：完成 Entity 与 DTO 转换
* **Security 层**：负责 JWT 鉴权、过滤器、认证入口与权限控制
* **Liquibase**：负责数据库表结构和增量变更

这种结构对于后续扩展前端、增加推荐算法、拆分微服务都比较友好。

---

## 数据库设计概览

从 Liquibase 变更集可以看到，当前项目至少包含以下核心表：

* `user`
* `refresh_token`
* `author`
* `book_category`
* `book`
* `publisher`
* `tag`
* `user_book_rate`
* `user_book_category`
* `user_reading_info`
* `book_loan`
* 预约相关表（由库存 / 预约变更脚本创建）

这些表共同支撑了：

* 用户身份与权限
* 图书元数据管理
* 用户评分行为
* 用户阅读偏好
* 图书库存与借阅状态
* 图书预约队列

---

## 推荐逻辑说明

### 1. 总览推荐（Recommendation Overview）

推荐总览会按“书架”形式返回多个推荐集合，常见包括：

* 热门推荐
* 偏好分类推荐
* 基于评分与借阅行为的推荐

### 2. 热门推荐

热门推荐会综合以下信号：

* 评分人数 `usersRateCount`
* 平均评分 `rate`
* 可借库存 `availableCopies`
* 名称等稳定排序字段

### 3. 阅读偏好推荐

如果用户已经填写阅读偏好，系统会优先从偏好分类中挑选图书并按热度排序。

### 4. 用户行为推荐

系统会根据：

* 用户评分记录
* 当前借阅记录
* 历史借阅记录

提取用户偏好的分类与标签，并对候选图书打分，再生成个性化推荐结果。

### 5. 相似图书推荐

围绕某本图书生成相关推荐时，系统会优先考虑：

* 同分类图书
* 共享标签数量更多的图书
* 热门度更高的图书

### 6. 协同过滤实现（已保留）

仓库中还保留了 `CollaborativeFilteringRecommender`，其中使用了：

* 用户-图书评分矩阵
* Pearson 相似度
* Top-K 邻域
* 预测评分计算

当前主流程已经更偏向“业务可解释”的推荐方式，但协同过滤类仍可作为后续实验、论文对比、算法增强入口。

---

## 借阅与预约规则

根据当前业务实现，借阅 / 预约规则包括：

* 每位用户最多同时借阅 **5 本** 图书
* 默认借期为 **14 天**
* 每笔借阅最多可续借 **1 次**
* 每次续借延长 **7 天**
* 已借过同一本且仍未归还时，不可重复借阅
* 若该书存在预约队列，只有当前排队第一位用户可以优先借阅
* 图书有库存时不允许预约，应该直接借阅
* 用户不能重复预约同一本书
* 借阅成功后，如用户原本有该书有效预约，该预约会被自动标记为已履约

这部分逻辑让项目不再只是“推荐系统”，而更接近一个具备基本图书流通能力的业务系统。

---

## 安全与权限

项目使用 JWT 作为认证方案。

当前权限策略大致如下：

### 公开接口

* `POST /api/user`：注册
* `GET /api/user/find-is-email-exists/**`：邮箱检测
* `POST /api/auth/log-in`：登录
* `POST /api/auth/refresh-token`：刷新 token

### 需要登录

* 绝大多数 `/api/**` 接口
* 用户资料、阅读偏好
* 图书评分
* 借阅 / 归还 / 续借
* 预约 / 取消预约 / 查看预约摘要

### 需要管理员权限

* 新增 / 更新 / 删除图书
* 批量新增图书
* 新增 / 更新 / 删除作者
* 新增 / 更新 / 删除标签
* 新增 / 更新 / 删除出版社

---

## 默认运行配置

`application.properties` 中当前默认配置如下：

* 服务端口：`8010`
* 上下文路径：`/book-service`
* PostgreSQL 地址：`localhost:5043`
* 数据库名：`book_recommendation_system`
* 启用 Liquibase 自动迁移
* 本地开发默认引导管理员账号：

  * 邮箱：`admin@booknook.local`
  * 密码：`Admin123!`

> 建议在正式环境中不要直接使用仓库中的明文配置，应改为环境变量、外部配置中心或 `.env` 方式管理。

---

## 快速开始

### 1. 环境要求

请先准备：

* JDK 11
* Maven（或直接使用仓库自带的 `mvnw`）
* PostgreSQL
* Node.js（仅在需要生成导入 SQL 时使用）

### 2. 创建数据库

```sql
CREATE DATABASE book_recommendation_system;
```

如果你本地 PostgreSQL 不是运行在 `5043` 端口，请修改：

```properties
spring.datasource.url=jdbc:postgresql://localhost:5043/book_recommendation_system
spring.datasource.username=postgres
spring.datasource.password=你的密码
```

### 3. 启动项目

#### Windows

```bash
mvnw.cmd spring-boot:run
```

#### macOS / Linux

```bash
./mvnw spring-boot:run
```

或者先打包再启动：

```bash
./mvnw clean package
java -jar target/book-recommendation-system-0.0.1-SNAPSHOT.jar
```

### 4. 访问地址

启动后基础地址为：

```text
http://localhost:8010/book-service
```

如果启用了 SpringDoc，通常可以访问：

```text
http://localhost:8010/book-service/swagger-ui/index.html
```

---

## 数据库迁移

项目通过 Liquibase 管理数据库版本，主变更入口为：

```text
src/main/resources/db/book-recommendation-system.xml
```

其下又引入 PostgreSQL 变更集，包括：

* 用户表
* 刷新令牌表
* 作者表
* 图书分类表
* 图书表
* 出版社 / 标签表
* 用户评分表
* 用户阅读偏好表
* 借阅表
* 库存与预约相关变更

只要应用正常启动，Liquibase 会自动执行缺失的变更。

---

## 数据初始化与导入脚本

### 1. 从 JSON 重建种子数据

脚本：

```text
scripts/generate-json-seed-sql.js
```

输入：

* `src/main/resources/json/Authors - final.json`
* `src/main/resources/json/Books - final.json`

输出：

* `scripts/generated/reset_from_json.sql`

作用：

* 清空作者与图书相关测试数据
* 重置自增 ID
* 重新导入作者与图书
* 同时清理依赖图书 / 作者的数据，如偏好与评分

执行示例：

```bash
node scripts/generate-json-seed-sql.js
psql -U postgres -d book_recommendation_system -f scripts/generated/reset_from_json.sql
```

### 2. 增量导入列表数据

脚本：

```text
scripts/generate-list-import-sql.js
```

输入：

* `list/authors.raw.json`
* `list/books.raw.json`

输出：

* `scripts/generated/import_from_list_raw.sql`

作用：

* 插入缺失作者
* 插入缺失分类
* 插入缺失图书
* 保留原有数据，不执行 truncate
* 自动填充默认日期、封面、国家、描述等兜底字段

---

## API 设计说明

项目统一响应结构：

```json
{
  "success": true,
  "timestamp": "2026-04-02T10:00:00",
  "message": "Operation completed successfully.",
  "body": {}
}
```

---

## 主要接口一览

下面列出 README 里最值得先让使用者了解的一组接口。

### 认证相关

| 方法   | 路径                        | 说明       |
| ---- | ------------------------- | -------- |
| POST | `/api/auth/log-in`        | 用户登录     |
| POST | `/api/auth/refresh-token` | 刷新令牌     |
| GET  | `/api/auth/current`       | 获取当前登录用户 |
| GET  | `/api/auth/log-out`       | 当前用户登出   |

### 用户相关

| 方法   | 路径                                       | 说明       |
| ---- | ---------------------------------------- | -------- |
| POST | `/api/user`                              | 用户注册     |
| PUT  | `/api/user`                              | 更新当前用户资料 |
| GET  | `/api/user/find-is-email-exists/{email}` | 检查邮箱是否存在 |
| GET  | `/api/user/find-reading-info`            | 获取阅读偏好   |
| POST | `/api/user/reading-info`                 | 创建阅读偏好   |
| GET  | `/api/user/find-all-genders`             | 获取性别枚举   |
| GET  | `/api/user/find-all-martial-statuses`    | 获取婚姻状态枚举 |

### 图书相关

| 方法     | 路径                                           | 说明        |
| ------ | -------------------------------------------- | --------- |
| GET    | `/api/book/find-by-id/{bookId}`              | 图书详情      |
| POST   | `/api/book/find-all-paginated-filtered`      | 图书分页筛选    |
| GET    | `/api/book/find-all-by-author-id/{authorId}` | 查询作者名下图书  |
| GET    | `/api/book/find-all-categories`              | 获取图书分类    |
| GET    | `/api/book/find-all-recommended`             | 获取推荐图书列表  |
| GET    | `/api/book/recommendations/popular`          | 获取热门推荐    |
| GET    | `/api/book/recommendations/overview`         | 获取推荐总览    |
| GET    | `/api/book/recommendations/similar/{bookId}` | 获取相似图书推荐  |
| POST   | `/api/book/rate`                             | 图书评分      |
| POST   | `/api/book`                                  | 新增图书（管理员） |
| PUT    | `/api/book`                                  | 修改图书（管理员） |
| DELETE | `/api/book/{bookId}`                         | 删除图书（管理员） |

### 作者相关

| 方法     | 路径                                        | 说明        |
| ------ | ----------------------------------------- | --------- |
| GET    | `/api/author/find-by-id/{authorId}`       | 作者详情      |
| POST   | `/api/author/find-all-paginated-filtered` | 作者分页筛选    |
| POST   | `/api/author`                             | 新增作者（管理员） |
| PUT    | `/api/author`                             | 修改作者（管理员） |
| DELETE | `/api/author/{authorId}`                  | 删除作者（管理员） |

### 出版社 / 标签相关

| 方法     | 路径                             | 说明         |
| ------ | ------------------------------ | ---------- |
| GET    | `/api/publisher`               | 查询出版社      |
| POST   | `/api/publisher`               | 新增出版社（管理员） |
| PUT    | `/api/publisher`               | 修改出版社（管理员） |
| DELETE | `/api/publisher/{publisherId}` | 删除出版社（管理员） |
| GET    | `/api/tag`                     | 查询标签       |
| POST   | `/api/tag`                     | 新增标签（管理员）  |
| PUT    | `/api/tag`                     | 修改标签（管理员）  |
| DELETE | `/api/tag/{tagId}`             | 删除标签（管理员）  |

### 借阅 / 预约相关

| 方法   | 路径                                        | 说明       |
| ---- | ----------------------------------------- | -------- |
| GET  | `/api/loan/my-active`                     | 当前借阅     |
| GET  | `/api/loan/my-history`                    | 借阅历史     |
| POST | `/api/loan/borrow`                        | 借书       |
| POST | `/api/loan/{loanId}/return`               | 还书       |
| POST | `/api/loan/{loanId}/renew`                | 续借       |
| GET  | `/api/reservation/my-active`              | 当前预约     |
| GET  | `/api/reservation/my-history`             | 预约历史     |
| GET  | `/api/reservation/book/{bookId}/summary`  | 当前书籍预约摘要 |
| POST | `/api/reservation/reserve`                | 发起预约     |
| POST | `/api/reservation/{reservationId}/cancel` | 取消预约     |

---

## 请求示例

### 1. 注册

```http
POST /book-service/api/user
Content-Type: application/json
```

```json
{
  "firstName": "Wei",
  "lastName": "Dong",
  "email": "wei@example.com",
  "password": "123456",
  "phoneNumber": "18800000000",
  "country": "China"
}
```

### 2. 登录

```http
POST /book-service/api/auth/log-in
Content-Type: application/json
```

```json
{
  "email": "wei@example.com",
  "password": "123456"
}
```

### 3. 刷新 Token

```http
POST /book-service/api/auth/refresh-token
Content-Type: application/json
```

```json
{
  "email": "wei@example.com",
  "refreshToken": "your-refresh-token"
}
```

### 4. 创建阅读偏好

```http
POST /book-service/api/user/reading-info
Authorization: Bearer <access_token>
Content-Type: application/json
```

```json
{
  "readingLevel": "BEGINNER",
  "userBookCategories": [
    {
      "category": { "id": 1 }
    },
    {
      "category": { "id": 3 }
    }
  ]
}
```

### 5. 图书筛选分页

```http
POST /book-service/api/book/find-all-paginated-filtered
Content-Type: application/json
```

```json
{
  "pageNumber": 0,
  "pageSize": 12,
  "sortingByList": [
    {
      "fieldName": "name",
      "direction": "ASC",
      "isNumber": false
    }
  ],
  "criteria": {
    "name": "harry",
    "categories": [1, 2],
    "authors": [3],
    "publishers": [1],
    "tags": [2, 5],
    "fromPrice": 10,
    "toPrice": 120,
    "fromPagesNumber": 100,
    "toPagesNumber": 600,
    "fromReadingDuration": 60,
    "toReadingDuration": 900
  },
  "deletedRecords": false
}
```

### 6. 图书评分

```http
POST /book-service/api/book/rate
Authorization: Bearer <access_token>
Content-Type: application/json
```

```json
{
  "book": { "id": 10 },
  "rate": 5
}
```

### 7. 借书

```http
POST /book-service/api/loan/borrow
Authorization: Bearer <access_token>
Content-Type: application/json
```

```json
{
  "bookId": 10
}
```

### 8. 预约图书

```http
POST /book-service/api/reservation/reserve
Authorization: Bearer <access_token>
Content-Type: application/json
```

```json
{
  "bookId": 10
}
```



```
