# Book UI Skeleton

这是项目内置的一套静态页面骨架，用于对接当前后端接口。

访问地址：

```text
http://localhost:8010/book-service/ui/login.html
```

主要页面：

1. `login.html`
2. `register.html`
3. `index.html`
4. `books.html`
5. `book-detail.html`
6. `rate-book.html`
7. `recommendations.html`
8. `profile.html`

默认对接接口：

- `POST /api/auth/log-in`
- `GET /api/auth/current`
- `POST /api/auth/refresh-token`
- `GET /api/auth/log-out`
- `POST /api/user`
- `PUT /api/user`
- `GET /api/user/find-reading-info`
- `POST /api/user/reading-info`
- `GET /api/book/find-by-id/{bookId}`
- `GET /api/book/find-all-recommended`
- `POST /api/book/find-all-paginated-filtered`
- `POST /api/book/rate`

如果你修改了后端 DTO、鉴权策略或上下文路径，需要同步更新这些静态页面里的请求地址和请求体。
