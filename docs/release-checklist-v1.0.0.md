# ReadSeek v1.0.0 Release Checklist

This checklist is for preparing the final graduation / portfolio release of ReadSeek.

## 1. Create Release Branch

Run in a terminal where Git is available:

```powershell
git checkout main
git pull
git checkout -b release/v1.0.0
```

## 2. Verify Build

Backend:

```powershell
mvn test
```

Frontend:

```powershell
cd frontend
npm install
npm run build
cd ..
```

Rust benchmark CLI:

```powershell
cd readseek-bench-rs
cargo test
cd ..
```

## 3. Verify Release Assets

Required files:

```text
README.md
docs/architecture.md
docs/evaluation-report.md
docs/demo-script.md
docs/project-boundary.md
docs/model-finetuning-development-plan.md
assets/diagrams/readseek-overview.png
assets/diagrams/readseek-overview.mmd
assets/screenshots/search-page.png
assets/screenshots/recommendation-page.png
assets/screenshots/dashboard-page.png
assets/screenshots/book-detail-page.png
assets/screenshots/swagger-page.png
```

Optional demo file:

```text
assets/demo/readseek-demo.gif
```

## 4. Record Demo

Recommended flow:

1. Homepage and login
2. Keyword search
3. Natural-language search
4. RAG QA with evidence
5. Recommendation page with explanations
6. Evaluation or analytics dashboard

If the GIF is large, upload the video to GitHub Release assets or an external video service and link it from README.

## 5. Commit

```powershell
git status
git add README.md docs assets
git commit -m "docs: prepare ReadSeek v1.0.0 release"
```

## 6. Merge To Main

```powershell
git checkout main
git merge release/v1.0.0
git push origin main
```

## 7. Tag

```powershell
git tag -a v1.0.0 -m "ReadSeek v1.0.0"
git push origin v1.0.0
```

## 8. GitHub Release Draft

Release title:

```text
ReadSeek v1.0.0
```

Release body:

```md
# ReadSeek v1.0.0

This is the first stable demonstration release of ReadSeek, an AI-enhanced reading-resource discovery system.

## Highlights

- Hybrid retrieval with exact search, BM25, dense vector retrieval, and reranking.
- Evidence-grounded RAG question answering.
- Explainable recommendation with source-bound reasons.
- Behavior analytics and evaluation dashboard.
- Local deployment with Spring Boot, PostgreSQL, Redis, Elasticsearch, Python AI service, and local LLM service.

## Included in this release

- Backend service
- Vue frontend interface
- Database schema and demo catalog
- Search and RAG modules
- Recommendation module
- Evaluation scripts and reports
- Architecture documentation
- Demo script
- Project boundary documentation

## Evaluation

This release includes documentation and generated reports for:

- retrieval evaluation;
- RAG QA evaluation;
- recommendation evaluation;
- API performance testing;
- failure case analysis.

## Known Limitations

- The system is designed as an undergraduate engineering project, not an industrial-scale recommendation platform.
- The quality of RAG answers depends on the retrieved book evidence.
- Cold-start recommendation still relies on popularity and initial user preferences.
- Local LLM response time depends on hardware performance.
```

## 9. Final README First-screen Check

The first screen should clearly show:

- project name
- one-sentence positioning
- system overview diagram
- tech stack
- quick documentation links
- screenshots or demo link

The first impression should be:

```text
This is an AI reading-resource discovery system, not a simple library CRUD project.
```
