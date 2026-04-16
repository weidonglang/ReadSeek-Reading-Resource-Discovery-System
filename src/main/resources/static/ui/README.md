# ReadSeek Static UI

This directory contains the built-in static demo frontend for ReadSeek, a reading-resource discovery system focused on natural-language hybrid retrieval and explainable recommendation.

Default entry:

```text
http://localhost:8010/readseek-service/ui/login.html
```

Main pages:

1. `login.html`
2. `register.html`
3. `index.html`
4. `books.html` - resource discovery workspace
5. `book-detail.html` - resource detail page
6. `rate-book.html` - resource rating page
7. `recommendations.html` - recommendation page
8. `profile.html`
9. `admin.html`

Notes:

- The current UI uses books as the sample reading-resource type.
- Public-facing labels are being aligned to "reading resource" and "resource discovery".
- Some file names and backend API paths still use `book` for compatibility with the existing implementation.
