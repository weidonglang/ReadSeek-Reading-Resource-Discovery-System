# New Book Recommendation System

一个基于 **Spring Boot** 的图书推荐与图书馆业务后台项目。

它不仅提供基础的图书、作者、用户和评分管理能力，还集成了 **JWT 鉴权**、**个性化推荐**、**借阅/归还/续借**、**预约**、**出版社与标签管理**，以及一套可直接访问的 **静态 UI 页面骨架**，适合作为课程设计、毕设原型或后端项目作品集展示。

---

## 项目简介

本项目围绕“图书发现 + 个性化推荐 + 借阅流转”展开，核心目标包括：

- 管理图书、作者、分类、出版社、标签等基础数据
- 支持用户注册、登录、刷新 Token、查询当前登录用户
- 记录用户评分与阅读偏好
- 基于用户评分行为生成个性化推荐结果
- 支持图书借阅、归还、续借与预约流程
- 提供静态前端页面骨架，便于快速联调和演示

推荐模块当前采用 **基于用户的协同过滤（User-Based Collaborative Filtering）**，使用相似用户的评分行为为当前用户生成候选图书。

---

## 当前功能

### 1. 用户与认证

- 用户注册
- JWT 登录
- 刷新访问令牌
- 获取当前登录用户
- 退出登录
- 基于角色/登录状态的接口访问控制

### 2. 图书与作者管理

- 图书详情查询
- 按作者查询图书
- 图书分类查询
- 图书分页与条件筛选
- 作者分页与条件筛选
- 管理员创建、更新、删除图书/作者

### 3. 个性化推荐

- 用户可对图书评分
- 系统基于评分数据生成推荐结果
- 推荐逻辑使用用户相似度计算，适合演示推荐系统核心流程

### 4. 阅读偏好与用户信息

- 读取用户阅读信息
- 保存用户阅读偏好
- 查询性别、婚姻状态等枚举数据
- 检查邮箱是否已注册

### 5. 借阅与预约

- 借书
- 还书
- 续借
- 查看当前用户借阅历史与在借记录
- 预约图书
- 取消预约
- 查看当前用户预约历史与有效预约
- 查看某本书的预约摘要

### 6. 扩展元数据管理

- 出版社管理
- 标签管理

### 7. 前端演示页面

仓库内已包含一套静态 UI 页面，可直接随 Spring Boot 一起提供：

- `ui/login.html`
- `ui/register.html`
- `ui/index.html`
- `ui/books.html`
- `ui/book-detail.html`
- `ui/rate-book.html`
- `ui/recommendations.html`
- `ui/profile.html`
- `ui/borrowings.html`
- `ui/admin.html`

---

## 技术栈

### 后端

- Java 11
- Spring Boot 2.7.x
- Spring Web
- Spring Security
- Spring Data JPA / Hibernate
- Bean Validation
- MapStruct
- Lombok
- JWT（`java-jwt`）
- Liquibase
- PostgreSQL

### 构建与工具

- Maven / Maven Wrapper
- Spring Boot DevTools
- springdoc-openapi-ui

### 前端与辅助脚本

- HTML / CSS / JavaScript 静态页面
- Node.js 脚本用于根据 JSON 生成 SQL 种子数据

---

## 项目结构

```text
new-book-recommendation-system/
├─ scripts/                         # JSON -> SQL 种子生成脚本
├─ src/
│  ├─ main/
│  │  ├─ java/com/henry/bookrecommendationsystem/
│  │  │  ├─ config/                 # 启动初始化配置（如管理员引导账号）
│  │  │  ├─ controller/             # REST API 控制器
│  │  │  ├─ dto/                    # 请求/响应 DTO
│  │  │  ├─ entity/                 # JPA 实体
│  │  │  ├─ exception/              # 异常处理
│  │  │  ├─ recommender/            # 推荐算法实现
│  │  │  ├─ repository/             # 数据访问层
│  │  │  ├─ security/               # JWT 与 Spring Security 配置
│  │  │  ├─ service/                # 业务逻辑层
│  │  │  └─ transformer/            # 对象转换
│  │  └─ resources/
│  │     ├─ db/                     # Liquibase 迁移脚本
│  │     ├─ json/                   # 作者/图书 JSON 原始数据
│  │     ├─ static/ui/              # 静态前端页面骨架
│  │     └─ application.properties  # 默认配置
│  └─ test/
├─ pom.xml
└─ system.properties
