# ReadSeek Architecture and Flows

This document uses Mermaid diagrams so GitHub can render the architecture directly from Markdown.

## System Architecture

```mermaid
flowchart LR
    User[Browser / Vue UI / Static UI] --> API[Spring Boot API<br/>readseek-service]
    API --> PG[(PostgreSQL<br/>catalog, users, logs)]
    API --> Redis[(Redis<br/>dedupe and cache)]
    API --> ES[(Elasticsearch<br/>BM25 and vectors)]
    API --> AI[Python AI Service<br/>BGE-M3 embedding<br/>BGE reranker]
    API --> Ollama[Ollama<br/>Qwen local LLM]
    API -. optional .-> Online[OpenAI-compatible<br/>Online AI Provider]
```

## Hybrid Search Flow

```mermaid
flowchart TD
    Q[User Query] --> N[Query Normalize]
    N --> I[Intent Classifier]
    I --> E[Query Expansion]
    E --> Exact[Exact DB Match]
    E --> BM25[BM25 Search]
    E --> Vector[Vector Search]
    Exact --> Merge[Candidate Merge]
    BM25 --> Merge
    Vector --> Merge
    Merge --> Rerank[BGE Reranker]
    Rerank --> Explain[Search Results with Explanations]
    Explain --> UI[UI shows intent, strategy, source, retrievalStage, matchType, reason, reranked]
```

## RAG Question Answering Flow

```mermaid
flowchart TD
    Q[User Question] --> Search[Hybrid Search]
    Search --> Evidence[Evidence Snippets]
    Evidence --> Check{Enough Evidence?}
    Check -- yes --> Provider[LLM Provider<br/>Ollama or Online API]
    Provider --> Answer[Citation-based Answer]
    Check -- no --> Refuse[Refusal / Conservative Degrade]
    Answer --> Logs[QA Logs and Analytics]
    Refuse --> Logs
    Logs --> UI[Answer, citations, evidence cards, confidence, latency, fallback]
```

## AI Reading Assistant Flow

```mermaid
flowchart TD
    UserTurn[User Message] --> Session[Session Context<br/>in-memory lightweight version]
    Session --> Rag[Per-turn RAG Request]
    Rag --> Search[Hybrid Search]
    Search --> Evidence[Evidence Cards]
    Evidence --> LLM[Evidence-constrained LLM Answer]
    LLM --> ChatResponse[Assistant Message]
    ChatResponse --> Cards[Recommended Resource Cards]
    ChatResponse --> Meta[Strategy, fallback, latency, citations]
    Cards --> UI[Multi-turn Chat UI]
    Meta --> UI
```

## Recommendation Analytics Flow

```mermaid
flowchart TD
    Profile[User Profile and Behavior] --> Strategies[Popular / Preference / Collaborative / Similar / Cold-start]
    Strategies --> Shelves[Recommendation Shelves]
    Shelves --> Exposure[Exposure Log]
    Shelves --> Click[Click Log]
    Shelves --> Feedback[Interested / Not Interested]
    Exposure --> Analytics[CTR and Feedback Rate]
    Click --> Analytics
    Feedback --> Analytics
    Analytics --> Admin[Admin Analytics Dashboard]
```

## Current Non-goals

- No full-text book ingestion.
- No chapter-level knowledge base.
- No deep chapter-specific QA.
- No production-scale retrieval benchmark.
- No complex Learning-to-Rank model training.
