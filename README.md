# 图书推荐与借阅管理系统

一个面向毕业设计、课程设计和功能演示场景的图书推荐系统，包含后端 API、权限认证、借阅流转、推荐能力，以及一套可直接访问的前端页面。

项目当前重点是：

- 图书检索、详情、评分、推荐与行为记录
- 图书借阅、归还、续借、预约与排队
- 用户注册、登录、令牌刷新与权限控制
- PostgreSQL 持久化与 Liquibase 数据库版本管理
- 适合答辩演示的前后端一体化体验

主包名：

```text
com.weidonglang.NewBookRecommendationSystem
```

## 项目定位

这个项目更适合作为：

- 本科毕业设计
- 课程设计
- 功能展示型作品集项目
- 推荐系统与图书流通管理方向的教学演示项目

它已经具备较完整的业务链路，但默认配置仍以本地开发和演示为主，不建议直接按当前配置投入生产环境。

## 功能概览

### 用户与认证

- 用户注册、登录、退出登录
- Access Token / Refresh Token 认证流程
- 基于 Spring Security 的权限控制
- 默认管理员账号自动引导创建

### 图书与检索

- 图书列表与多条件筛选
- 作者、分类、标签、出版社维度筛选
- 图书详情页
- 图书评分
- 用户行为记录与搜索日志

### 推荐能力

- 热门图书推荐
- 基于阅读偏好的推荐
- 基于评分和借阅行为的推荐
- 相似图书推荐
- 推荐总览书架
- 首页阅读看板与推荐预览

### 借阅流转

- 借阅
- 归还
- 续借
- 预约
- 预约排队与队首优先借阅
- 借阅状态与到期提醒展示

### 前端页面

前端静态页面位于 `src/main/resources/static/ui`，当前包含：

- 首页阅读看板
- 图书检索工作台
- 图书详情页
- 推荐书架页
- 登录、注册、个人中心、借阅记录等页面

## 技术栈

- Java 11
- Spring Boot 2.7.5
- Spring Web
- Spring Security
- Spring Data JPA
- Hibernate
- PostgreSQL
- Liquibase
- JWT (`com.auth0:java-jwt`)
- MapStruct
- Lombok
- springdoc-openapi-ui
- 原生 HTML / CSS / JavaScript 前端页面

## 目录结构

```text
book-recommendation-system/
├─ src/main/java/com/weidonglang/NewBookRecommendationSystem/
│  ├─ config/          # 配置与启动初始化
│  ├─ controller/      # 接口控制层
│  ├─ dao/             # 数据访问实现
│  ├─ dto/             # 请求/响应 DTO
│  ├─ entity/          # 数据实体
│  ├─ enums/           # 枚举定义
│  ├─ exception/       # 全局异常处理
│  ├─ manager/         # 认证与基础管理器
│  ├─ recommender/     # 推荐相关实现
│  ├─ repository/      # JPA Repository
│  ├─ security/        # 安全配置与 JWT 过滤
│  ├─ service/         # 业务服务层
│  ├─ transformer/     # DTO / Entity 转换
│  └─ utils/           # 通用工具
├─ src/main/resources/
│  ├─ application.properties
│  ├─ application-dev.properties
│  ├─ db/              # Liquibase 脚本
│  ├─ json/            # 初始化或导入数据
│  └─ static/ui/       # 前端页面
├─ scripts/            # 项目辅助脚本
├─ pom.xml
├─ mvnw.cmd
└─ mvnw-jdk11.cmd
```

## 运行环境

建议环境：

- JDK 11
- Maven Wrapper（项目已内置）
- PostgreSQL 12+
- Windows + IntelliJ IDEA 或任意支持 Maven 的 IDE

## 默认配置

当前默认配置来自 `src/main/resources/application.properties`：

- 服务端口：`8010`
- 上下文路径：`/book-service`
- 数据库：`book_recommendation_system`
- 默认数据库地址：`jdbc:postgresql://localhost:5043/book_recommendation_system`
- Swagger UI：`/swagger-ui/index.html`

默认管理员账号：

- 邮箱：`admin@booknook.local`
- 密码：`Admin123!`

## 启动前说明

项目配置里当前保留了本地开发用数据库连接与 JWT 密钥。若你准备对外发布、部署或多人协作，建议先做这些调整：

- 修改数据库用户名和密码
- 修改 JWT Secret
- 使用环境变量或外部配置管理敏感信息
- 不要继续把本地密码直接提交到公共仓库

## 快速启动

### 1. 创建数据库

```sql
CREATE DATABASE book_recommendation_system;
```

### 2. 修改数据库连接

按你的本地环境修改 `src/main/resources/application.properties`：

```properties
spring.datasource.url=jdbc:postgresql://localhost:5043/book_recommendation_system
spring.datasource.username=postgres
spring.datasource.password=your_password
```

### 3. 使用 JDK 11 编译

如果你本机默认 Java 不是 11，优先使用项目脚本：

```bat
mvnw-jdk11.cmd -DskipTests compile
```

### 4. 启动项目

```bat
mvnw-jdk11.cmd spring-boot:run
```

如果你的环境已经正确切到 JDK 11，也可以直接用：

```bat
mvnw.cmd spring-boot:run
```

## 访问入口

启动成功后可访问：

- 后端根路径：`http://localhost:8010/book-service`
- Swagger 文档：`http://localhost:8010/book-service/swagger-ui/index.html`
- 前端登录页：`http://localhost:8010/book-service/ui/login.html`
- 前端首页：`http://localhost:8010/book-service/ui/index.html`

## 借阅与预约规则

当前系统内置的业务规则包括：

- 每位用户最多同时借阅 5 本书
- 默认借期 14 天
- 每笔借阅最多续借 1 次
- 每次续借延长 7 天
- 同一本未归还图书不能重复借阅
- 图书无可借库存时可进入预约队列
- 有预约队列时，通常由队首用户优先借阅

## 推荐能力说明

系统当前已经具备以下推荐能力：

- 推荐总览书架
- 热门推荐
- 基于偏好的推荐
- 基于评分和借阅行为的推荐
- 相似图书推荐
- 同作者延伸浏览
- 首页阅读建议与推荐预览

如果后续继续深化，可以进一步扩展：

- 协同过滤排序权重优化
- 混合推荐策略
- 推荐理由解释能力增强
- 用户画像可视化

## 常用接口示例

### 登录

```http
POST /book-service/api/auth/log-in
Content-Type: application/json
```

```json
{
  "email": "admin@booknook.local",
  "password": "Admin123!"
}
```

### 图书评分

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

### 借阅图书

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

## 测试与验证建议

建议至少按下面顺序验证：

1. 编译项目

```bat
mvnw-jdk11.cmd -DskipTests compile
```

2. 启动项目

```bat
mvnw-jdk11.cmd spring-boot:run
```

3. 验证登录

- 使用默认管理员登录
- 检查 Access Token / Refresh Token 是否正常工作

4. 验证核心业务

- 检索图书
- 查看图书详情
- 评分
- 借阅 / 归还 / 续借 / 预约
- 查看推荐页与首页看板

## 二次开发建议

如果你准备基于本项目继续开发，建议优先从这些方向入手：

- 把敏感配置移出 `application.properties`
- 补充单元测试和集成测试
- 优化异常码与统一响应结构
- 增强 JWT、刷新令牌和登出策略
- 为推荐服务增加更清晰的策略分层
- 为前端页面加入更完整的国际化和状态反馈

## 贡献说明

This project is developed based on / inspired by henry-azer/book-recommendation-system.
On top of the original project, I extended the system with borrowing, returning, renewal, reservation queue, admin management, deployment scripts, and improved project documentation.

本项目基于 henry-azer/book-recommendation-system 进行二次开发。
在原有图书推荐能力基础上，新增/完善了借阅、归还、续借、预约排队、后台管理、部署脚本与文档说明等功能。

欢迎任何形式的贡献，包括但不限于：

- 提交 Issue
- 修复 Bug
- 补充文档
- 优化样式或前端交互
- 增强推荐算法
- 增加测试
- 提交 Pull Request
- 基于此项目继续二次开发

如果你准备贡献代码，建议：

- 保持提交粒度清晰
- 尽量不要混入无关改动
- 对配置、依赖和数据库脚本改动写清楚目的

## 开源许可

本项目采用 MIT License。

这意味着你基本可以自由地：

- 使用
- 下载
- 复制
- 修改
- 二次开发
- 分发
- 商用
- 提交衍生工具
- 贡献代码

唯一需要保留的是原始许可声明与版权声明，同时作者不对软件使用结果承担担保责任。

完整许可见 [LICENSE](LICENSE)。
