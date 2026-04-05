# New Book Recommendation System

一个面向图书推荐与图书流通管理的后端系统，基于 Spring Boot、Spring Security、JPA/Hibernate、PostgreSQL 和 Liquibase 构建。

## Overview

项目提供以下核心能力：

- 用户注册、登录、刷新令牌、退出登录
- 图书、作者、分类、标签、出版社管理
- 图书评分
- 推荐书架与相似图书推荐
- 图书借阅、归还、续借
- 图书预约与排队
- Liquibase 数据库版本管理

当前主包名：

```text
com.weidonglang.NewBookRecommendationSystem
```

## Tech Stack

- Java 11
- Spring Boot 2.7.5
- Spring Web
- Spring Security
- Spring Data JPA
- Hibernate
- PostgreSQL
- Liquibase
- Lombok
- MapStruct
- JWT (`com.auth0:java-jwt`)
- springdoc-openapi-ui

## Project Structure

```text
new-book-recommendation-system/
├─ src/main/java/com/weidonglang/NewBookRecommendationSystem/
│  ├─ config/
│  ├─ controller/
│  ├─ dao/
│  ├─ dto/
│  ├─ entity/
│  ├─ enums/
│  ├─ exception/
│  ├─ manager/
│  ├─ recommender/
│  ├─ repository/
│  ├─ security/
│  ├─ service/
│  ├─ transformer/
│  └─ utils/
├─ src/main/resources/
│  ├─ application.properties
│  ├─ application-dev.properties
│  └─ db/
├─ src/test/java/com/weidonglang/NewBookRecommendationSystem/
├─ scripts/
├─ pom.xml
├─ mvnw.cmd
└─ mvnw-jdk11.cmd
```

## Default Runtime Configuration

默认配置位于 [application.properties](/F:/code/java/new-book-recommendation-system/src/main/resources/application.properties)：

- Port: `8010`
- Context path: `/book-service`
- Database: `book_recommendation_system`
- PostgreSQL: `localhost:5043`

默认管理员账号：

- Email: `admin@booknook.local`
- Password: `Admin123!`

## Run With JDK 11

如果本机默认 Java 不是 11，优先使用项目内脚本：

```bat
mvnw-jdk11.cmd -DskipTests compile
mvnw-jdk11.cmd spring-boot:run
```

这个脚本会临时指定：

```text
C:\Program Files\Java\jdk-11.0.30+7
```

## Quick Start

1. 创建 PostgreSQL 数据库：

```sql
CREATE DATABASE book_recommendation_system;
```

2. 按需修改数据库连接：

```properties
spring.datasource.url=jdbc:postgresql://localhost:5043/book_recommendation_system
spring.datasource.username=postgres
spring.datasource.password=your_password
```

3. 编译并启动：

```bat
mvnw-jdk11.cmd -DskipTests compile
mvnw-jdk11.cmd spring-boot:run
```

4. 访问：

```text
http://localhost:8010/book-service
http://localhost:8010/book-service/swagger-ui/index.html
```

## Recommendation Features

系统当前包含以下推荐能力：

- 热门图书推荐
- 基于阅读偏好的推荐
- 基于评分与借阅行为的推荐
- 相似图书推荐
- 保留了协同过滤推荐器实现，便于后续扩展

## Loan And Reservation Rules

- 每位用户最多同时借阅 5 本书
- 默认借期 14 天
- 每笔借阅最多续借 1 次
- 每次续借延长 7 天
- 同一本未归还图书不能重复借阅
- 有预约队列时，仅队首用户可优先借阅

## API Examples

登录：

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

图书评分：

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

借书：

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
