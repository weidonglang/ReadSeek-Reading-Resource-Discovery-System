# Vector Retrieval and Python AI Service Development Plan

## 1. Background

The current project has already completed the first retrieval stage:

- PostgreSQL-based structured filtering and pagination
- Elasticsearch-based BM25 full-text search
- Query intent classification
- Hybrid retrieval v1: `exact-db + bm25`
- Frontend integration for the search workspace
- Automatic search-index synchronization for book create / update / soft delete

To move the project from keyword retrieval toward a stronger graduation-project direction, the next step is to introduce:

1. a vector retrieval skeleton in the Java backend
2. a minimal Python AI service for embedding generation
3. a hybrid retrieval v2 path combining BM25 and vector search

This document defines the implementation scope, milestones, risks, and deliverables for that stage.

## 2. Goals

### 2.1 Functional Goals

- Add a backend abstraction for embedding providers
- Add a backend abstraction for vector search
- Reserve vector fields in the search index model
- Allow hybrid retrieval to merge BM25 and vector hits
- Build a minimal Python AI service exposing an `/embed` endpoint
- Keep the system backward compatible when the AI service is not enabled

### 2.2 Non-Goals in This Stage

- No large-model answer generation yet
- No full RAG response generation yet
- No production-grade model orchestration
- No distributed deployment optimization
- No advanced evaluation dashboard in this stage

## 3. Current Status

### 3.1 Already Implemented

- Search configuration and Elasticsearch integration
- Search index rebuild and single-book indexing
- BM25 retrieval
- Exact-match retrieval
- Query rewrite bridge for Chinese queries on an English-heavy seed corpus
- Frontend search page using `/api/search/books`

### 3.2 Skeleton Work Already Prepared

- Search configuration now reserves vector and embedding settings
- Search document model reserves an embedding field
- Backend has `EmbeddingProvider` and `VectorBookSearchService` extension points
- Hybrid retrieval service already supports a vector branch when enabled

### 3.3 Still Missing

- A real embedding source
- Vectorized book documents in Elasticsearch
- Python AI service endpoint
- End-to-end vector retrieval verification

## 4. Architecture Plan

### 4.1 Java Backend Responsibilities

- Manage book metadata and existing BM25 retrieval
- Call the embedding provider when indexing documents
- Call vector search when natural-language retrieval is enabled
- Merge exact / BM25 / vector results into a single hybrid response
- Fail safely back to BM25 if the AI service is unavailable

### 4.2 Python AI Service Responsibilities

- Expose `POST /embed`
- Accept plain text plus model metadata
- Return a numeric embedding vector
- Run locally with lightweight dependencies

### 4.3 Retrieval Flow

1. User submits a search query
2. Java backend classifies query intent
3. Java backend performs exact match lookup
4. Java backend performs BM25 retrieval
5. If vector retrieval is enabled, Java backend requests a query embedding
6. Java backend performs vector similarity retrieval in Elasticsearch
7. Java backend merges and ranks hits
8. Frontend renders the unified result

## 5. Implementation Scope

### Phase A: Backend Vector Skeleton

Scope:

- Search configuration for vector retrieval and embedding provider
- DTOs for embedding request / response
- `EmbeddingProvider` abstraction
- `VectorBookSearchService` abstraction
- Local AI embedding client stub
- Hybrid retrieval merge logic

Expected output:

- The backend compiles and runs with vector retrieval disabled by default
- Existing search behavior is not broken

### Phase B: Python AI Service Minimal Version

Scope:

- New lightweight Python service directory
- `POST /embed` endpoint
- Configurable model name
- Local startup command
- Basic health endpoint

Expected output:

- Java backend can call the Python service locally
- One text input returns one embedding vector

### Phase C: Vectorized Document Indexing

Scope:

- Generate embeddings for indexed books
- Write embeddings into Elasticsearch document field
- Rebuild index after enabling the embedding provider

Expected output:

- Existing documents have both keyword fields and vector fields

### Phase D: Hybrid Retrieval v2

Scope:

- Query embedding generation
- Vector similarity search in Elasticsearch
- Merge policy for exact hits, BM25 hits, and vector hits
- Intent-aware ordering:
  - natural-language query: favor vector before BM25
  - keyword query: favor BM25 before vector

Expected output:

- Natural-language queries produce more semantic matches
- Keyword searches remain stable

## 6. Detailed Task Breakdown

### Task Group 1: Configuration

- Add `library.search.vector.*`
- Add `library.search.embedding.*`
- Keep everything disabled by default

### Task Group 2: Java AI Client

- Define embedding request and response DTOs
- Implement local HTTP client with timeout handling
- Return empty results safely on failure

### Task Group 3: Search Index Model

- Add `embedding` field to the Elasticsearch book document
- Ensure index rebuild supports vector generation

### Task Group 4: Retrieval Logic

- Add vector search service implementation
- Use safe fallback if:
  - embedding provider is disabled
  - Python service is unreachable
  - embedding size is invalid
  - vector query returns no hits

### Task Group 5: Python AI Service

- Add a minimal HTTP service
- Provide:
  - `/health`
  - `/embed`
- Support one default model first

### Task Group 6: Testing

- Unit tests for query expansion and vector-aware hybrid merge
- Unit tests for embedding provider disabled mode
- Integration test after Python service is connected

## 7. Milestones

### Milestone 1

Backend vector skeleton completed.

Definition of done:

- Java code compiles
- Existing search still works
- Vector branch is optional and disabled by default

### Milestone 2

Python AI service runs locally.

Definition of done:

- `/health` returns success
- `/embed` returns a valid vector

### Milestone 3

Vector indexing completed.

Definition of done:

- Rebuilt Elasticsearch index includes embeddings
- No regression to existing BM25 flow

### Milestone 4

Hybrid retrieval v2 completed.

Definition of done:

- Natural-language search can produce vector-assisted results
- Frontend can display hybrid-v2 strategy labels

## 8. Risks and Countermeasures

### Risk 1: AI service unavailable

Countermeasure:

- Backend must fail open and continue using BM25

### Risk 2: Embedding dimension mismatch

Countermeasure:

- Validate vector length before indexing or querying

### Risk 3: Retrieval quality regression

Countermeasure:

- Keep BM25 as baseline
- Use intent-aware merge order
- Compare before and after with representative queries

### Risk 4: Resource usage increases

Countermeasure:

- Use a small local embedding model first
- Keep vector retrieval disabled by default in development unless needed

## 9. Deliverables

- Updated Java backend retrieval module
- Minimal Python AI service
- Configuration guide for local startup
- Search test cases for BM25 and vector-assisted retrieval
- One milestone summary for thesis documentation or defense slides

## 10. Suggested Execution Order

Recommended order:

1. Finish backend vector skeleton
2. Create Python AI service minimal version
3. Connect `/embed` from Java to Python
4. Rebuild Elasticsearch documents with embeddings
5. Verify hybrid retrieval v2 locally
6. Prepare retrieval examples for thesis screenshots and discussion

## 11. Expected Thesis Value

After this stage, the project can be described more strongly as:

> A book discovery system with structured filtering, BM25 retrieval, hybrid retrieval, and a local semantic-search extension path.

This creates a clear transition from:

- engineering-oriented search and recommendation

to:

- retrieval-oriented intelligent book discovery

and lays the foundation for later:

- evidence retrieval
- RAG question answering
- explainable recommendation
- comparative experiments
