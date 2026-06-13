# ReadSeek Demo Script

## 1. Preparation

Start required services:

- PostgreSQL
- Redis
- Elasticsearch
- Spring Boot backend
- Vue frontend
- Python BGE-M3 AI service
- Ollama local LLM service

Recommended launcher:

```powershell
.\start-readseek.bat
```

Main URLs:

```text
Frontend:  http://127.0.0.1:5173
Backend:   http://localhost:8010/readseek-service
Swagger:   http://localhost:8010/readseek-service/swagger-ui/index.html
Report:    http://127.0.0.1:8765/index.html
```

## 2. Demo Flow

Target duration: 2-3 minutes.

### Step 1: Open the homepage

Show the system entrance and explain that ReadSeek focuses on reading-resource discovery rather than simple book management.

Key point:

> ReadSeek upgrades a traditional book system into a natural-language discovery system with search, RAG, recommendation, and evaluation.

### Step 2: Keyword search

Input a keyword query, for example:

```text
psychology
```

Show:

- search result list
- matched resources
- search strategy
- source and ranking explanation

### Step 3: Natural-language search

Input a natural-language query:

```text
I want an introductory psychology book that is not too academic.
```

or:

```text
想找一本适合入门的心理学书，不要太学术
```

Show that the system can return semantically related books through vector retrieval, hybrid search, and reranking.

### Step 4: RAG question answering

Ask a book recommendation or comparison question:

```text
帮我推荐几本爱情小说，并说明推荐顺序。
```

Show:

- generated answer
- recommended book list
- evidence cards
- citation numbers
- limitations and follow-up suggestions

### Step 5: Explainable recommendation

Open the recommendation page.

Show:

- recommendation shelves
- similar-resource recommendation
- recommendation source
- recommendation reason
- click or feedback event if available

### Step 6: Analytics and evaluation dashboard

Show:

- search logs
- recommendation clicks or feedback
- RAG usage
- evaluation result summary
- Rust benchmark dashboard if available

## 3. Key Points to Explain

- ReadSeek uses hybrid retrieval instead of single keyword search.
- BGE-M3 vector retrieval helps with natural-language and semantic queries.
- BGE reranker improves top-ranked result quality.
- RAG answers are generated from retrieved book evidence.
- Recommendation explanations are bound to actual recommendation sources.
- Offline evaluation is used to verify retrieval, RAG, recommendation, and latency behavior.

## 4. Recording Plan

Recommended tools:

- ScreenToGif for a short GIF
- OBS for a higher-quality video

Recommended output:

```text
assets/demo/readseek-demo.gif
```

If the video is too large, upload it to GitHub Release assets or an external video service, then link it from README.
