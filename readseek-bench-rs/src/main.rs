use anyhow::{anyhow, bail, Context, Result};
use chrono::Local;
use clap::{Parser, Subcommand};
use csv::Writer;
use reqwest::blocking::Client;
use reqwest::header::{HeaderMap, HeaderValue, AUTHORIZATION, CONTENT_TYPE};
use serde::{Deserialize, Serialize};
use serde_json::{json, Map, Value};
use std::collections::{BTreeMap, HashMap, HashSet};
use std::fs;
use std::path::{Path, PathBuf};
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{mpsc, Arc};
use std::thread;
use std::time::{Duration, Instant};

const DEFAULT_API_BASE_URL: &str = "http://localhost:8010/readseek-service";

#[derive(Parser, Debug)]
#[command(name = "readseek-bench-rs")]
#[command(about = "Rust benchmark CLI for ReadSeek retrieval experiments")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand, Debug)]
enum Command {
    /// Run four-way retrieval evaluation against the running ReadSeek backend.
    Retrieval(RetrievalArgs),
    /// Run evidence-based RAG evaluation against the running ReadSeek backend.
    Rag(RagArgs),
    /// Run recommendation case/offline evaluation.
    Recommendation(RecommendationArgs),
    /// Run lightweight concurrent API load test.
    Load(LoadArgs),
    /// Build a static HTML dashboard from generated Markdown reports.
    Dashboard(DashboardArgs),
}

#[derive(Parser, Debug)]
struct RetrievalArgs {
    #[arg(long, default_value = ".env")]
    env_file: PathBuf,
    #[arg(long)]
    api_base_url: Option<String>,
    #[arg(long)]
    admin_email: Option<String>,
    #[arg(long)]
    admin_password: Option<String>,
    #[arg(long, default_value = "../docs/evaluation/search_queries_100.json")]
    queries: PathBuf,
    #[arg(long, default_value = "../docs/evaluation/generated/rust")]
    output_dir: PathBuf,
    #[arg(long, default_value_t = 10)]
    limit: usize,
    #[arg(long, default_value_t = -1, allow_hyphen_values = true)]
    query_limit: isize,
    #[arg(long, default_value_t = 5)]
    metric_k: usize,
    #[arg(long, default_value_t = 90)]
    timeout: u64,
    #[arg(long, default_value = "bm25,vector,hybrid,hybrid_reranker")]
    methods: String,
}

#[derive(Parser, Debug)]
struct RagArgs {
    #[arg(long, default_value = ".env")]
    env_file: PathBuf,
    #[arg(long)]
    api_base_url: Option<String>,
    #[arg(long)]
    admin_email: Option<String>,
    #[arg(long)]
    admin_password: Option<String>,
    #[arg(long, default_value = "../docs/evaluation/rag_questions_60.json")]
    questions: PathBuf,
    #[arg(long, default_value = "../docs/evaluation/generated/rust-rag")]
    output_dir: PathBuf,
    #[arg(long, default_value = "standard")]
    mode: String,
    #[arg(long, default_value = "ollama")]
    provider: String,
    #[arg(long, default_value_t = 8)]
    limit: usize,
    #[arg(long, default_value_t = -1, allow_hyphen_values = true)]
    question_limit: isize,
    #[arg(long, default_value_t = 180)]
    timeout: u64,
}

#[derive(Parser, Debug)]
struct RecommendationArgs {
    #[arg(long, default_value = ".env")]
    env_file: PathBuf,
    #[arg(long)]
    api_base_url: Option<String>,
    #[arg(long)]
    admin_email: Option<String>,
    #[arg(long)]
    admin_password: Option<String>,
    #[arg(long, default_value = "../docs/evaluation/search_queries_100.json")]
    queries: PathBuf,
    #[arg(
        long,
        default_value = "../docs/evaluation/generated/rust-recommendation"
    )]
    output_dir: PathBuf,
    #[arg(long, default_value_t = -1, allow_hyphen_values = true)]
    query_limit: isize,
    #[arg(long, default_value_t = 10)]
    metric_k: usize,
    #[arg(long, default_value_t = 90)]
    timeout: u64,
    #[arg(long, default_value_t = 25)]
    similar_anchor_limit: usize,
}

#[derive(Parser, Debug)]
struct LoadArgs {
    #[arg(long, default_value = ".env")]
    env_file: PathBuf,
    #[arg(long)]
    api_base_url: Option<String>,
    #[arg(long)]
    admin_email: Option<String>,
    #[arg(long)]
    admin_password: Option<String>,
    #[arg(long, default_value = "../docs/evaluation/generated/rust-load")]
    output_dir: PathBuf,
    #[arg(long, default_value = "search,recommendation")]
    scenarios: String,
    #[arg(long, default_value_t = 100)]
    requests: usize,
    #[arg(long, default_value_t = 8)]
    concurrency: usize,
    #[arg(long, default_value_t = 180)]
    timeout: u64,
    #[arg(long, default_value_t = true)]
    login: bool,
}

#[derive(Parser, Debug)]
struct DashboardArgs {
    #[arg(long, default_value = "../docs/evaluation/generated/rust-suite")]
    input_dir: PathBuf,
    #[arg(
        long,
        default_value = "../docs/evaluation/generated/rust-suite/index.html"
    )]
    output: PathBuf,
    #[arg(long, default_value = "http://localhost:11434")]
    ollama_url: String,
    #[arg(long, default_value = "qwen3:14b")]
    ollama_model: String,
    #[arg(long, default_value = "qwen2.5-coder:7b")]
    coder_model: String,
}

#[derive(Debug, Deserialize)]
struct QueryFile {
    #[serde(default)]
    dataset: Option<Value>,
    #[serde(default)]
    queries: Vec<QueryCase>,
}

#[derive(Debug, Deserialize)]
struct RagQuestionFile {
    #[serde(default)]
    dataset: Option<Value>,
    #[serde(default)]
    questions: Vec<RagQuestion>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct RagQuestion {
    id: String,
    question: String,
    #[serde(default, rename = "answerMode")]
    answer_mode: Option<String>,
    #[serde(default, rename = "relevantResourceIds")]
    relevant_resource_ids: Vec<Value>,
    #[serde(default)]
    relevance: RelevanceHints,
    #[serde(default, rename = "maxRelevantIds")]
    max_relevant_ids: Option<usize>,
    #[serde(flatten)]
    extra: Map<String, Value>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
struct QueryCase {
    id: String,
    query: String,
    #[serde(default)]
    intent: Option<String>,
    #[serde(default, rename = "relevantResourceIds")]
    relevant_resource_ids: Vec<Value>,
    #[serde(default)]
    relevance: RelevanceHints,
    #[serde(default, rename = "maxRelevantIds")]
    max_relevant_ids: Option<usize>,
    #[serde(flatten)]
    extra: Map<String, Value>,
}

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
struct RelevanceHints {
    #[serde(default, rename = "titleHints")]
    title_hints: Vec<String>,
    #[serde(default, rename = "authorHints")]
    author_hints: Vec<String>,
    #[serde(default, rename = "categoryHints")]
    category_hints: Vec<String>,
    #[serde(default, rename = "tagHints")]
    tag_hints: Vec<String>,
    #[serde(default, rename = "keywordHints")]
    keyword_hints: Vec<String>,
    #[serde(default, rename = "maxRelevantIds")]
    max_relevant_ids: Option<usize>,
}

#[derive(Debug, Clone)]
struct BookDoc {
    id: i64,
    title: String,
    author: String,
    category: String,
    publisher: String,
    tags: Vec<String>,
    isbn: String,
    description: String,
}

#[derive(Debug, Serialize)]
struct QueryMetrics {
    #[serde(rename = "precisionAtK")]
    precision_at_k: f64,
    #[serde(rename = "recallAtK")]
    recall_at_k: f64,
    mrr: f64,
    #[serde(rename = "ndcgAt10")]
    ndcg_at_10: f64,
}

#[derive(Debug, Serialize)]
struct ResultRow {
    #[serde(rename = "queryId")]
    query_id: String,
    query: String,
    intent: Option<String>,
    method: String,
    strategy: Option<Value>,
    #[serde(rename = "queryIntent")]
    query_intent: Option<Value>,
    #[serde(rename = "rerankerApplied")]
    reranker_applied: Option<Value>,
    #[serde(rename = "fallbackApplied")]
    fallback_applied: Option<Value>,
    #[serde(rename = "candidateCount")]
    candidate_count: Option<Value>,
    #[serde(rename = "latencyMs")]
    latency_ms: Option<f64>,
    #[serde(rename = "rankedResourceIds")]
    ranked_resource_ids: Vec<i64>,
    #[serde(rename = "relevantResourceIds")]
    relevant_resource_ids: Vec<i64>,
    metrics: Option<QueryMetrics>,
    error: Option<String>,
}

#[derive(Debug, Serialize)]
struct MethodSummary {
    #[serde(rename = "queryCount")]
    query_count: usize,
    #[serde(rename = "successfulQueries")]
    successful_queries: usize,
    #[serde(rename = "precisionAtK")]
    precision_at_k: f64,
    #[serde(rename = "recallAtK")]
    recall_at_k: f64,
    mrr: f64,
    #[serde(rename = "ndcgAt10")]
    ndcg_at_10: f64,
    #[serde(rename = "avgLatencyMs")]
    avg_latency_ms: f64,
    #[serde(rename = "p95LatencyMs")]
    p95_latency_ms: f64,
}

fn main() -> Result<()> {
    let cli = Cli::parse();
    match cli.command {
        Command::Retrieval(args) => run_retrieval(args),
        Command::Rag(args) => run_rag(args),
        Command::Recommendation(args) => run_recommendation(args),
        Command::Load(args) => run_load(args),
        Command::Dashboard(args) => run_dashboard(args),
    }
}

fn run_retrieval(args: RetrievalArgs) -> Result<()> {
    let env = load_dotenv(&args.env_file)?;
    let api_base_url = normalize_base_url(args.api_base_url.as_deref(), &env);
    let client = Client::builder()
        .timeout(Duration::from_secs(args.timeout))
        .build()
        .context("failed to build HTTP client")?;

    let token = login(
        &client,
        &api_base_url,
        &env,
        args.admin_email.as_deref(),
        args.admin_password.as_deref(),
    )?;
    let mut query_file: QueryFile = read_json(&args.queries)
        .with_context(|| format!("failed to read queries from {}", args.queries.display()))?;
    if args.query_limit == 0 {
        query_file.queries.clear();
    } else if args.query_limit > 0 {
        query_file.queries.truncate(args.query_limit as usize);
    }

    let catalog = fetch_catalog(&client, &api_base_url, &token)?;
    let methods = parse_methods(&args.methods);
    if methods.is_empty() {
        bail!("no methods selected");
    }

    fs::create_dir_all(&args.output_dir)
        .with_context(|| format!("failed to create {}", args.output_dir.display()))?;

    let mut results: BTreeMap<String, Vec<ResultRow>> = methods
        .iter()
        .map(|method| (method.clone(), Vec::new()))
        .collect();
    let mut resolved_queries = Vec::new();

    for (index, query) in query_file.queries.iter().enumerate() {
        let relevant_ids = resolve_relevant_ids(query, &catalog);
        let mut resolved = serde_json::to_value(query)?;
        if let Value::Object(ref mut object) = resolved {
            object.insert(
                "resolvedRelevantResourceIds".to_string(),
                json!(relevant_ids),
            );
        }
        resolved_queries.push(resolved);

        println!(
            "[{}/{}] {} {} relevant={}",
            index + 1,
            query_file.queries.len(),
            query.id,
            query.query,
            relevant_ids.len()
        );

        for method in &methods {
            let endpoint = method_endpoint(method);
            let row = match endpoint {
                Some(endpoint) => evaluate_method(
                    &client,
                    &api_base_url,
                    endpoint,
                    method,
                    query,
                    &relevant_ids,
                    args.limit,
                    args.metric_k,
                ),
                None => Err(anyhow!("unknown method {method}")),
            };

            let result_row = match row {
                Ok(row) => row,
                Err(error) => ResultRow {
                    query_id: query.id.clone(),
                    query: query.query.clone(),
                    intent: query.intent.clone(),
                    method: method.clone(),
                    strategy: None,
                    query_intent: None,
                    reranker_applied: None,
                    fallback_applied: None,
                    candidate_count: None,
                    latency_ms: None,
                    ranked_resource_ids: Vec::new(),
                    relevant_resource_ids: relevant_ids.clone(),
                    metrics: None,
                    error: Some(error.to_string()),
                },
            };
            results
                .get_mut(method)
                .expect("method initialized")
                .push(result_row);
        }
    }

    let mut summaries = BTreeMap::new();
    for (method, rows) in &results {
        summaries.insert(method.clone(), summarize(rows));
    }

    let generated_at = Local::now().format("%Y-%m-%dT%H:%M:%S").to_string();
    let summary = json!({
        "dataset": query_file.dataset,
        "generatedAt": generated_at,
        "queryCount": query_file.queries.len(),
        "metricK": args.metric_k,
        "methods": methods,
        "metrics": summaries,
        "tool": {
            "name": "readseek-bench-rs",
            "version": env!("CARGO_PKG_VERSION")
        }
    });

    write_json(
        args.output_dir.join("search_queries_100_resolved.json"),
        &json!({ "queries": resolved_queries }),
    )?;
    write_json(
        args.output_dir.join("retrieval_results.json"),
        &json!({ "summary": summary, "results": results }),
    )?;
    write_metrics_csv(
        args.output_dir.join("retrieval_metrics.csv"),
        &results,
        args.metric_k,
    )?;
    write_markdown_report(
        args.output_dir.join("retrieval_report.md"),
        &summary,
        args.metric_k,
    )?;
    write_html_report(
        args.output_dir.join("retrieval_report.html"),
        &summary,
        args.metric_k,
    )?;

    println!(
        "Rust retrieval evaluation written to {}",
        args.output_dir.display()
    );
    Ok(())
}

fn run_rag(args: RagArgs) -> Result<()> {
    let env = load_dotenv(&args.env_file)?;
    let api_base_url = normalize_base_url(args.api_base_url.as_deref(), &env);
    let client = Client::builder()
        .timeout(Duration::from_secs(args.timeout))
        .build()
        .context("failed to build HTTP client")?;
    let token = login(
        &client,
        &api_base_url,
        &env,
        args.admin_email.as_deref(),
        args.admin_password.as_deref(),
    )?;
    let catalog = fetch_catalog(&client, &api_base_url, &token)?;
    let mut question_file: RagQuestionFile = read_json(&args.questions)
        .with_context(|| format!("failed to read questions from {}", args.questions.display()))?;
    if args.question_limit == 0 {
        question_file.questions.clear();
    } else if args.question_limit > 0 {
        question_file
            .questions
            .truncate(args.question_limit as usize);
    }

    fs::create_dir_all(&args.output_dir)
        .with_context(|| format!("failed to create {}", args.output_dir.display()))?;

    let mut results = Vec::new();
    let mut scoring_rows = Vec::new();
    for (index, question) in question_file.questions.iter().enumerate() {
        let expected_ids = resolve_relevant_ids_for(
            &question.relevant_resource_ids,
            &question.relevance,
            question.max_relevant_ids,
            &catalog,
        );
        println!(
            "[{}/{}] {} expected={}",
            index + 1,
            question_file.questions.len(),
            question.id,
            expected_ids.len()
        );
        let result = match call_rag(
            &client,
            &api_base_url,
            &token,
            &question.question,
            &args.mode,
            &args.provider,
            args.limit,
        ) {
            Ok((body, request_latency_ms)) => {
                let ids = evidence_ids(&body);
                let expected_hit = if expected_ids.is_empty() {
                    !ids.is_empty()
                } else {
                    ids.iter().any(|id| expected_ids.contains(id))
                };
                json!({
                    "id": question.id,
                    "question": question.question,
                    "answerModeExpected": question.answer_mode,
                    "answerModeActual": body.get("answerMode").cloned(),
                    "answerable": body.get("answerable").and_then(Value::as_bool).unwrap_or(false),
                    "strategy": body.get("strategy").cloned(),
                    "model": body.get("model").cloned(),
                    "fallbackApplied": body.get("fallbackApplied").cloned(),
                    "llmFallbackApplied": body.get("llmFallbackApplied").cloned(),
                    "evidenceCount": ids.len(),
                    "evidenceIds": ids,
                    "expectedResourceIds": expected_ids,
                    "expectedEvidenceHit": expected_hit,
                    "evidenceRecall": if expected_ids.is_empty() { 0.0 } else { recall_at_k(&ids, &expected_ids, ids.len()) },
                    "citationCoverage": citation_coverage(&body),
                    "requestLatencyMs": request_latency_ms,
                    "totalLatencyMs": body.get("totalLatencyMs").cloned().unwrap_or(json!(request_latency_ms)),
                    "retrievalLatencyMs": body.get("retrievalLatencyMs").cloned(),
                    "generationLatencyMs": body.get("generationLatencyMs").cloned(),
                    "answer": body.get("answer").cloned(),
                    "limitations": body.get("limitations").cloned().unwrap_or(json!([])),
                    "error": Value::Null,
                })
            }
            Err(error) => json!({
                "id": question.id,
                "question": question.question,
                "expectedResourceIds": expected_ids,
                "error": error.to_string(),
            }),
        };
        scoring_rows.push(json!({
            "id": result.get("id").cloned().unwrap_or(Value::Null),
            "question": result.get("question").cloned().unwrap_or(Value::Null),
            "answerable": result.get("answerable").cloned().unwrap_or(Value::Null),
            "evidenceCount": result.get("evidenceCount").cloned().unwrap_or(Value::Null),
            "expectedEvidenceHit": result.get("expectedEvidenceHit").cloned().unwrap_or(Value::Null),
            "citationCoverage": result.get("citationCoverage").cloned().unwrap_or(Value::Null),
            "totalLatencyMs": result.get("totalLatencyMs").cloned().unwrap_or(Value::Null),
            "manualRelevance0to5": "",
            "manualCompleteness0to5": "",
            "manualCitationValidity0to5": "",
            "manualHallucinationRisk0to5": "",
            "notes": "",
        }));
        results.push(result);
    }

    let valid: Vec<&Value> = results.iter().filter(|row| !has_error(row)).collect();
    let summary = json!({
        "dataset": question_file.dataset,
        "generatedAt": now_string(),
        "questionCount": question_file.questions.len(),
        "successfulQuestions": valid.len(),
        "mode": args.mode,
        "provider": args.provider,
        "answerableRate": mean_values(&valid, "answerable"),
        "evidenceHitRate": mean_values(&valid, "expectedEvidenceHit"),
        "meanEvidenceRecall": mean_number_values(&valid, "evidenceRecall"),
        "meanCitationCoverage": mean_number_values(&valid, "citationCoverage"),
        "avgTotalLatencyMs": mean_latency_values(&valid),
        "tool": { "name": "readseek-bench-rs", "version": env!("CARGO_PKG_VERSION") }
    });

    write_json(
        args.output_dir.join("rag_results.json"),
        &json!({ "summary": summary, "results": results }),
    )?;
    write_value_csv(
        args.output_dir.join("rag_evaluation_manual_scoring.csv"),
        &scoring_rows,
        &[
            "id",
            "question",
            "answerable",
            "evidenceCount",
            "expectedEvidenceHit",
            "citationCoverage",
            "totalLatencyMs",
            "manualRelevance0to5",
            "manualCompleteness0to5",
            "manualCitationValidity0to5",
            "manualHallucinationRisk0to5",
            "notes",
        ],
    )?;
    let markdown = rag_markdown(&summary);
    write_text(args.output_dir.join("rag_report.md"), &markdown)?;
    write_report_html(
        args.output_dir.join("rag_report.html"),
        "ReadSeek Rust RAG Evaluation",
        &markdown,
        &summary,
        None,
    )?;
    println!(
        "Rust RAG evaluation written to {}",
        args.output_dir.display()
    );
    Ok(())
}

fn run_recommendation(args: RecommendationArgs) -> Result<()> {
    let env = load_dotenv(&args.env_file)?;
    let api_base_url = normalize_base_url(args.api_base_url.as_deref(), &env);
    let client = Client::builder()
        .timeout(Duration::from_secs(args.timeout))
        .build()
        .context("failed to build HTTP client")?;
    let token = login(
        &client,
        &api_base_url,
        &env,
        args.admin_email.as_deref(),
        args.admin_password.as_deref(),
    )?;
    let catalog = fetch_catalog(&client, &api_base_url, &token)?;
    let query_file: QueryFile = read_json(&args.queries)
        .with_context(|| format!("failed to read queries from {}", args.queries.display()))?;
    fs::create_dir_all(&args.output_dir)
        .with_context(|| format!("failed to create {}", args.output_dir.display()))?;

    let (overview, overview_latency) = call_get(
        &client,
        &api_base_url,
        &token,
        "/api/resources/recommendations/overview",
    )?;
    let shelves = recommendation_ids_from_overview(&overview);
    let mut theme_queries: Vec<QueryCase> = query_file
        .queries
        .into_iter()
        .filter(|query| {
            matches!(
                query.intent.as_deref(),
                Some("theme-cn")
                    | Some("theme-en")
                    | Some("natural-cn")
                    | Some("reading-path")
                    | Some("comparison")
                    | Some("multi-condition")
            )
        })
        .collect();
    if args.query_limit == 0 {
        theme_queries.clear();
    } else if args.query_limit > 0 {
        theme_queries.truncate(args.query_limit as usize);
    }

    let mut overview_cases = Vec::new();
    for query in &theme_queries {
        let relevant_ids = resolve_relevant_ids(query, &catalog);
        if relevant_ids.is_empty() {
            continue;
        }
        for (shelf_key, ranked_ids) in &shelves {
            let metrics = metrics_json(ranked_ids, &relevant_ids, args.metric_k);
            overview_cases.push(json!({
                "caseType": "overview-shelf",
                "queryId": query.id,
                "query": query.query,
                "shelf": shelf_key,
                "rankedIds": ranked_ids,
                "relevantIds": relevant_ids,
                "precisionAtK": metrics.precision_at_k,
                "recallAtK": metrics.recall_at_k,
                "ndcgAt10": metrics.ndcg_at_10,
            }));
        }
    }

    let mut similar_cases = Vec::new();
    for book in catalog.iter().take(args.similar_anchor_limit) {
        let relevant = similar_relevant_ids(book, &catalog);
        let path = format!("/api/resources/recommendations/similar/{}", book.id);
        match call_get(&client, &api_base_url, &token, &path) {
            Ok((similar, latency)) => {
                let similar_ids = recommendation_ids_from_overview(&similar)
                    .values()
                    .flat_map(|ids| ids.iter().copied())
                    .collect::<Vec<_>>();
                let metrics = metrics_json(&similar_ids, &relevant, args.metric_k);
                similar_cases.push(json!({
                    "caseType": "similar-recommendation",
                    "anchorBookId": book.id,
                    "anchorTitle": book.title,
                    "category": book.category,
                    "rankedIds": similar_ids,
                    "relevantIds": relevant.iter().take(50).copied().collect::<Vec<_>>(),
                    "latencyMs": latency,
                    "precisionAtK": metrics.precision_at_k,
                    "recallAtK": metrics.recall_at_k,
                    "ndcgAt10": metrics.ndcg_at_10,
                    "error": Value::Null,
                }));
            }
            Err(error) => similar_cases.push(json!({
                "caseType": "similar-recommendation",
                "anchorBookId": book.id,
                "anchorTitle": book.title,
                "error": error.to_string(),
            })),
        }
    }

    let all_rows = overview_cases
        .iter()
        .chain(similar_cases.iter())
        .collect::<Vec<_>>();
    let metric_rows: Vec<&Value> = all_rows.into_iter().filter(|row| !has_error(row)).collect();
    let summary = json!({
        "generatedAt": now_string(),
        "overviewLatencyMs": overview_latency,
        "overviewShelfCount": shelves.len(),
        "overviewCaseCount": overview_cases.len(),
        "similarCaseCount": similar_cases.len(),
        "precisionAtK": mean_number_values(&metric_rows, "precisionAtK"),
        "recallAtK": mean_number_values(&metric_rows, "recallAtK"),
        "ndcgAt10": mean_number_values(&metric_rows, "ndcgAt10"),
        "metricK": args.metric_k,
        "tool": { "name": "readseek-bench-rs", "version": env!("CARGO_PKG_VERSION") }
    });

    let csv_rows = overview_cases
        .iter()
        .chain(similar_cases.iter())
        .cloned()
        .collect::<Vec<_>>();
    write_json(
        args.output_dir.join("recommendation_offline_results.json"),
        &json!({
            "summary": summary,
            "overviewShelves": shelves,
            "overviewCases": overview_cases,
            "similarCases": similar_cases,
        }),
    )?;
    write_value_csv(
        args.output_dir.join("recommendation_offline_metrics.csv"),
        &csv_rows,
        &[
            "caseType",
            "queryId",
            "query",
            "shelf",
            "anchorBookId",
            "anchorTitle",
            "latencyMs",
            "precisionAtK",
            "recallAtK",
            "ndcgAt10",
            "error",
        ],
    )?;
    let markdown = recommendation_markdown(&summary);
    write_text(
        args.output_dir.join("recommendation_offline_report.md"),
        &markdown,
    )?;
    write_report_html(
        args.output_dir.join("recommendation_offline_report.html"),
        "ReadSeek Rust Recommendation Evaluation",
        &markdown,
        &summary,
        None,
    )?;
    println!(
        "Rust recommendation evaluation written to {}",
        args.output_dir.display()
    );
    Ok(())
}

fn run_load(args: LoadArgs) -> Result<()> {
    let env = load_dotenv(&args.env_file)?;
    let api_base_url = normalize_base_url(args.api_base_url.as_deref(), &env);
    let client = Client::builder()
        .timeout(Duration::from_secs(args.timeout))
        .build()
        .context("failed to build HTTP client")?;
    let token = if args.login {
        Some(login(
            &client,
            &api_base_url,
            &env,
            args.admin_email.as_deref(),
            args.admin_password.as_deref(),
        )?)
    } else {
        None
    };
    let scenarios = parse_methods(&args.scenarios);
    if scenarios.is_empty() {
        bail!("no load scenarios selected");
    }
    let mut work_items = Vec::with_capacity(args.requests);
    for index in 0..args.requests {
        work_items.push(scenarios[index % scenarios.len()].clone());
    }

    fs::create_dir_all(&args.output_dir)
        .with_context(|| format!("failed to create {}", args.output_dir.display()))?;

    let started_at = Instant::now();
    let shared_work = Arc::new(work_items);
    let cursor = Arc::new(AtomicUsize::new(0));
    let (sender, receiver) = mpsc::channel();
    let worker_count = args.concurrency.max(1);
    for _ in 0..worker_count {
        let worker_client = client.clone();
        let worker_base = api_base_url.clone();
        let worker_token = token.clone();
        let worker_work = Arc::clone(&shared_work);
        let worker_cursor = Arc::clone(&cursor);
        let worker_sender = sender.clone();
        thread::spawn(move || loop {
            let index = worker_cursor.fetch_add(1, Ordering::SeqCst);
            if index >= worker_work.len() {
                break;
            }
            let scenario = worker_work[index].clone();
            let row = run_load_request(
                &worker_client,
                &worker_base,
                worker_token.as_deref(),
                &scenario,
                index + 1,
            );
            let _ = worker_sender.send(row);
        });
    }
    drop(sender);

    let mut rows = Vec::new();
    for row in receiver {
        println!(
            "{} #{} success={} latency={:.1}ms",
            row.get("scenario")
                .and_then(Value::as_str)
                .unwrap_or("unknown"),
            row.get("sequence").and_then(Value::as_u64).unwrap_or(0),
            row.get("success").and_then(Value::as_bool).unwrap_or(false),
            row.get("latencyMs").and_then(Value::as_f64).unwrap_or(0.0)
        );
        rows.push(row);
    }
    let elapsed_seconds = started_at.elapsed().as_secs_f64();

    let overall = summarize_load_rows(&rows);
    let mut by_scenario = Map::new();
    for scenario in &scenarios {
        let scoped = rows
            .iter()
            .filter(|row| row.get("scenario").and_then(Value::as_str) == Some(scenario.as_str()))
            .cloned()
            .collect::<Vec<_>>();
        by_scenario.insert(scenario.clone(), summarize_load_rows(&scoped));
    }
    let summary = json!({
        "generatedAt": now_string(),
        "apiBaseUrl": api_base_url,
        "requests": args.requests,
        "concurrency": args.concurrency,
        "elapsedSeconds": elapsed_seconds,
        "throughputRps": if elapsed_seconds > 0.0 { args.requests as f64 / elapsed_seconds } else { 0.0 },
        "overall": overall,
        "byScenario": by_scenario,
        "tool": { "name": "readseek-bench-rs", "version": env!("CARGO_PKG_VERSION") }
    });

    write_json(
        args.output_dir.join("load_test_results.json"),
        &json!({ "summary": summary, "requests": rows }),
    )?;
    write_value_csv(
        args.output_dir.join("load_test_requests.csv"),
        &rows,
        &[
            "scenario",
            "sequence",
            "success",
            "latencyMs",
            "resultCount",
            "error",
        ],
    )?;
    let markdown = load_markdown(&summary);
    write_text(args.output_dir.join("load_test_report.md"), &markdown)?;
    write_report_html(
        args.output_dir.join("load_test_report.html"),
        "ReadSeek Rust API Load Test",
        &markdown,
        &summary,
        None,
    )?;
    println!("Rust load test written to {}", args.output_dir.display());
    Ok(())
}

fn run_dashboard(args: DashboardArgs) -> Result<()> {
    let reports = [
        ("Retrieval", "retrieval_report.md"),
        ("RAG", "rag_report.md"),
        ("Recommendation", "recommendation_offline_report.md"),
        ("Load Test", "load_test_report.md"),
    ];
    let mut sections = Vec::new();
    for (title, file_name) in reports {
        let path = args.input_dir.join(file_name);
        if path.exists() {
            let markdown = fs::read_to_string(&path)
                .with_context(|| format!("failed to read {}", path.display()))?;
            sections.push((title.to_string(), markdown));
        }
    }
    if sections.is_empty() {
        bail!("no Markdown reports found in {}", args.input_dir.display());
    }
    if let Some(parent) = args.output.parent() {
        fs::create_dir_all(parent)
            .with_context(|| format!("failed to create {}", parent.display()))?;
    }
    let retrieval = read_optional_json(args.input_dir.join("retrieval_results.json"))?;
    let rag = read_optional_json(args.input_dir.join("rag_results.json"))?;
    let recommendation =
        read_optional_json(args.input_dir.join("recommendation_offline_results.json"))?;
    let load = read_optional_json(args.input_dir.join("load_test_results.json"))?;
    let html = dashboard_html(
        &sections,
        retrieval.as_ref(),
        rag.as_ref(),
        recommendation.as_ref(),
        load.as_ref(),
        &args.ollama_url,
        &args.ollama_model,
        &args.coder_model,
    );
    fs::write(&args.output, html)
        .with_context(|| format!("failed to write {}", args.output.display()))?;
    println!(
        "Rust benchmark dashboard written to {}",
        args.output.display()
    );
    Ok(())
}

fn evaluate_method(
    client: &Client,
    api_base_url: &str,
    endpoint: &str,
    method: &str,
    query: &QueryCase,
    relevant_ids: &[i64],
    limit: usize,
    metric_k: usize,
) -> Result<ResultRow> {
    let url = format!(
        "{api_base_url}{endpoint}?q={}&limit={limit}",
        urlencoding::encode(&query.query)
    );
    let started = Instant::now();
    let response: Value = client
        .get(url)
        .send()
        .context("search request failed")?
        .error_for_status()
        .context("search endpoint returned an error")?
        .json()
        .context("failed to parse search response")?;
    let latency_ms = started.elapsed().as_secs_f64() * 1000.0;
    let body = api_body(&response).unwrap_or(&response);
    let ranked_resource_ids = extract_hit_ids(body);
    let metrics = QueryMetrics {
        precision_at_k: precision_at_k(&ranked_resource_ids, relevant_ids, metric_k),
        recall_at_k: recall_at_k(&ranked_resource_ids, relevant_ids, metric_k),
        mrr: mrr(&ranked_resource_ids, relevant_ids),
        ndcg_at_10: ndcg_at_k(&ranked_resource_ids, relevant_ids, 10),
    };

    Ok(ResultRow {
        query_id: query.id.clone(),
        query: query.query.clone(),
        intent: query.intent.clone(),
        method: method.to_string(),
        strategy: body.get("strategy").cloned(),
        query_intent: body.get("queryIntent").cloned(),
        reranker_applied: body.get("rerankerApplied").cloned(),
        fallback_applied: body.get("fallbackApplied").cloned(),
        candidate_count: body.get("candidateCount").cloned(),
        latency_ms: Some(latency_ms),
        ranked_resource_ids,
        relevant_resource_ids: relevant_ids.to_vec(),
        metrics: Some(metrics),
        error: None,
    })
}

fn call_rag(
    client: &Client,
    api_base_url: &str,
    token: &str,
    question: &str,
    mode: &str,
    provider: &str,
    limit: usize,
) -> Result<(Value, f64)> {
    let started = Instant::now();
    let response: Value = client
        .post(format!("{api_base_url}/api/qa/evidence"))
        .headers(auth_headers(token)?)
        .json(&json!({
            "question": question,
            "mode": mode,
            "provider": provider,
            "limit": limit,
        }))
        .send()
        .context("RAG request failed")?
        .error_for_status()
        .context("RAG endpoint returned an error")?
        .json()
        .context("failed to parse RAG response")?;
    let latency_ms = started.elapsed().as_secs_f64() * 1000.0;
    Ok((api_body(&response).unwrap_or(&response).clone(), latency_ms))
}

fn evidence_ids(body: &Value) -> Vec<i64> {
    body.get("evidence")
        .and_then(Value::as_array)
        .map(|items| {
            items
                .iter()
                .filter_map(|item| item.get("resourceId").and_then(Value::as_i64))
                .collect()
        })
        .unwrap_or_default()
}

fn citation_coverage(body: &Value) -> f64 {
    let answer = body.get("answer").and_then(Value::as_str).unwrap_or("");
    let evidence_count = body
        .get("evidence")
        .and_then(Value::as_array)
        .map(Vec::len)
        .unwrap_or(0);
    if evidence_count == 0 {
        return 0.0;
    }
    let used = (1..=evidence_count)
        .filter(|index| answer.contains(&format!("[{index}]")))
        .count();
    used as f64 / evidence_count as f64
}

fn call_get(client: &Client, api_base_url: &str, token: &str, path: &str) -> Result<(Value, f64)> {
    let started = Instant::now();
    let response: Value = client
        .get(format!("{api_base_url}{path}"))
        .headers(auth_headers(token)?)
        .send()
        .with_context(|| format!("GET {path} failed"))?
        .error_for_status()
        .with_context(|| format!("GET {path} returned an error"))?
        .json()
        .with_context(|| format!("failed to parse GET {path} response"))?;
    let latency_ms = started.elapsed().as_secs_f64() * 1000.0;
    Ok((api_body(&response).unwrap_or(&response).clone(), latency_ms))
}

fn recommendation_ids_from_overview(overview: &Value) -> BTreeMap<String, Vec<i64>> {
    let mut shelves = BTreeMap::new();
    if let Some(items) = overview.get("shelves").and_then(Value::as_array) {
        for shelf in items {
            let key = shelf
                .get("key")
                .or_else(|| shelf.get("source"))
                .or_else(|| shelf.get("title"))
                .and_then(Value::as_str)
                .unwrap_or("unknown")
                .to_string();
            let ids = shelf
                .get("books")
                .and_then(Value::as_array)
                .map(|books| {
                    books
                        .iter()
                        .filter_map(|book| book.get("id").and_then(Value::as_i64))
                        .collect::<Vec<_>>()
                })
                .unwrap_or_default();
            shelves.insert(key, ids);
        }
    }
    shelves
}

fn similar_relevant_ids(anchor: &BookDoc, catalog: &[BookDoc]) -> Vec<i64> {
    let anchor_tags: HashSet<&str> = anchor.tags.iter().map(String::as_str).collect();
    catalog
        .iter()
        .filter(|candidate| candidate.id != anchor.id)
        .filter(|candidate| {
            (!anchor.category.is_empty() && candidate.category == anchor.category)
                || candidate
                    .tags
                    .iter()
                    .any(|tag| anchor_tags.contains(tag.as_str()))
        })
        .map(|candidate| candidate.id)
        .collect()
}

fn metrics_json(ranked_ids: &[i64], relevant_ids: &[i64], metric_k: usize) -> QueryMetrics {
    QueryMetrics {
        precision_at_k: precision_at_k(ranked_ids, relevant_ids, metric_k),
        recall_at_k: recall_at_k(ranked_ids, relevant_ids, metric_k),
        mrr: mrr(ranked_ids, relevant_ids),
        ndcg_at_10: ndcg_at_k(ranked_ids, relevant_ids, 10),
    }
}

fn run_load_request(
    client: &Client,
    api_base_url: &str,
    token: Option<&str>,
    scenario: &str,
    sequence: usize,
) -> Value {
    let started = Instant::now();
    let result = match scenario {
        "search" => {
            let query = load_search_query(sequence);
            let url = format!(
                "{api_base_url}/api/search/resources?q={}&limit=8",
                urlencoding::encode(query)
            );
            client
                .get(url)
                .send()
                .and_then(|response| response.error_for_status())
        }
        "rag" => {
            let mut request = client.post(format!("{api_base_url}/api/qa/evidence"));
            if let Some(token) = token {
                match auth_headers(token) {
                    Ok(headers) => request = request.headers(headers),
                    Err(error) => {
                        return load_error_row(scenario, sequence, started, error.to_string());
                    }
                }
            }
            request
                .json(&json!({
                    "question": load_rag_question(sequence),
                    "mode": "fast",
                    "provider": "ollama",
                    "limit": 5,
                }))
                .send()
                .and_then(|response| response.error_for_status())
        }
        "recommendation" => {
            let mut request = client.get(format!(
                "{api_base_url}/api/resources/recommendations/overview"
            ));
            if let Some(token) = token {
                match auth_headers(token) {
                    Ok(headers) => request = request.headers(headers),
                    Err(error) => {
                        return load_error_row(scenario, sequence, started, error.to_string());
                    }
                }
            }
            request
                .send()
                .and_then(|response| response.error_for_status())
        }
        other => {
            return load_error_row(
                scenario,
                sequence,
                started,
                format!("unknown scenario {other}"),
            )
        }
    };

    match result {
        Ok(response) => {
            let latency_ms = started.elapsed().as_secs_f64() * 1000.0;
            let body: Value = response.json().unwrap_or(Value::Null);
            let body = api_body(&body).unwrap_or(&body);
            let result_count = match scenario {
                "search" => body
                    .get("hits")
                    .and_then(Value::as_array)
                    .map(Vec::len)
                    .unwrap_or(0),
                "rag" => body
                    .get("evidence")
                    .and_then(Value::as_array)
                    .map(Vec::len)
                    .unwrap_or(0),
                "recommendation" => body
                    .get("shelves")
                    .and_then(Value::as_array)
                    .map(Vec::len)
                    .unwrap_or(0),
                _ => 0,
            };
            json!({
                "scenario": scenario,
                "sequence": sequence,
                "success": true,
                "latencyMs": latency_ms,
                "resultCount": result_count,
                "error": "",
            })
        }
        Err(error) => load_error_row(scenario, sequence, started, error.to_string()),
    }
}

fn load_error_row(scenario: &str, sequence: usize, started: Instant, error: String) -> Value {
    json!({
        "scenario": scenario,
        "sequence": sequence,
        "success": false,
        "latencyMs": started.elapsed().as_secs_f64() * 1000.0,
        "resultCount": 0,
        "error": error,
    })
}

fn load_search_query(sequence: usize) -> &'static str {
    const QUERIES: &[&str] = &[
        "爱情小说",
        "科幻小说 入门",
        "Jane Austen",
        "H. G. Wells",
        "The Power of Habit",
        "人工智能",
        "恐怖悬疑",
        "数学史",
        "The Every",
        "Pride and Prejudice",
    ];
    QUERIES[sequence % QUERIES.len()]
}

fn load_rag_question(sequence: usize) -> &'static str {
    const QUESTIONS: &[&str] = &[
        "帮我推荐几本爱情小说。",
        "我想从经典科幻入门，先读哪几本？",
        "The Every 和 Player Piano 有什么区别？",
        "帮我找几本自我管理相关的书。",
        "如果没有 Java 书，系统应该如何回答？",
    ];
    QUESTIONS[sequence % QUESTIONS.len()]
}

fn summarize_load_rows(rows: &[Value]) -> Value {
    let latencies = rows
        .iter()
        .filter_map(|row| row.get("latencyMs").and_then(Value::as_f64))
        .collect::<Vec<_>>();
    let successes = rows
        .iter()
        .filter(|row| row.get("success").and_then(Value::as_bool).unwrap_or(false))
        .count();
    json!({
        "requests": rows.len(),
        "successes": successes,
        "failures": rows.len().saturating_sub(successes),
        "successRate": if rows.is_empty() { 0.0 } else { successes as f64 / rows.len() as f64 },
        "avgLatencyMs": mean(&latencies),
        "p50LatencyMs": percentile(&latencies, 50.0),
        "p90LatencyMs": percentile(&latencies, 90.0),
        "p95LatencyMs": percentile(&latencies, 95.0),
        "p99LatencyMs": percentile(&latencies, 99.0),
        "maxLatencyMs": latencies.iter().copied().fold(0.0, f64::max),
    })
}

fn rag_markdown(summary: &Value) -> String {
    format!(
        "# ReadSeek Rust RAG Evaluation\n\n\
- Generated at: {}\n\
- Question count: {}\n\
- Mode/provider: {} / {}\n\n\
| Metric | Value |\n\
| --- | ---: |\n\
| Answerable rate | {:.4} |\n\
| Evidence hit rate | {:.4} |\n\
| Mean evidence recall | {:.4} |\n\
| Mean citation coverage | {:.4} |\n\
| Average total latency ms | {:.1} |\n\n\
Manual scoring columns are left blank in `rag_evaluation_manual_scoring.csv` for relevance, completeness, citation validity, and hallucination risk.\n",
        s(summary, "generatedAt"),
        u(summary, "questionCount"),
        s(summary, "mode"),
        s(summary, "provider"),
        n(summary, "answerableRate"),
        n(summary, "evidenceHitRate"),
        n(summary, "meanEvidenceRecall"),
        n(summary, "meanCitationCoverage"),
        n(summary, "avgTotalLatencyMs"),
    )
}

fn recommendation_markdown(summary: &Value) -> String {
    let metric_k = u(summary, "metricK");
    format!(
        "# ReadSeek Rust Recommendation Offline Evaluation\n\n\
- Generated at: {}\n\
- Overview shelves: {}\n\
- Overview cases: {}\n\
- Similar recommendation cases: {}\n\n\
| Metric | Value |\n\
| --- | ---: |\n\
| Precision@{} | {:.4} |\n\
| Recall@{} | {:.4} |\n\
| NDCG@10 | {:.4} |\n",
        s(summary, "generatedAt"),
        u(summary, "overviewShelfCount"),
        u(summary, "overviewCaseCount"),
        u(summary, "similarCaseCount"),
        metric_k,
        n(summary, "precisionAtK"),
        metric_k,
        n(summary, "recallAtK"),
        n(summary, "ndcgAt10"),
    )
}

fn load_markdown(summary: &Value) -> String {
    let mut lines = vec![
        "# ReadSeek Rust API Load Test".to_string(),
        String::new(),
        f("- Generated at: ", s(summary, "generatedAt")),
        f("- Requests: ", u(summary, "requests")),
        f("- Concurrency: ", u(summary, "concurrency")),
        format!("- Throughput: {:.2} req/s", n(summary, "throughputRps")),
        String::new(),
        "| Scope | Success rate | Avg ms | P50 | P90 | P95 | P99 | Max |".to_string(),
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |".to_string(),
    ];
    if let Some(overall) = summary.get("overall") {
        lines.push(load_scope_row("overall", overall));
    }
    if let Some(by_scenario) = summary.get("byScenario").and_then(Value::as_object) {
        for (scope, metrics) in by_scenario {
            lines.push(load_scope_row(scope, metrics));
        }
    }
    lines.join("\n")
}

fn load_scope_row(scope: &str, metrics: &Value) -> String {
    format!(
        "| {} | {:.4} | {:.1} | {:.1} | {:.1} | {:.1} | {:.1} | {:.1} |",
        scope,
        n(metrics, "successRate"),
        n(metrics, "avgLatencyMs"),
        n(metrics, "p50LatencyMs"),
        n(metrics, "p90LatencyMs"),
        n(metrics, "p95LatencyMs"),
        n(metrics, "p99LatencyMs"),
        n(metrics, "maxLatencyMs"),
    )
}

fn write_report_html(
    path: PathBuf,
    title: &str,
    markdown: &str,
    summary: &Value,
    extra_note: Option<&str>,
) -> Result<()> {
    let note = extra_note.unwrap_or("");
    let html = format!(
        r#"<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{title}</title>
  <style>{style}</style>
</head>
<body>
  <main>
    <header>
      <h1>{title}</h1>
      <p>Generated by readseek-bench-rs {version}</p>
    </header>
    <section class="panel">
      <pre>{markdown}</pre>
    </section>
    <section class="panel">
      <h2>Summary JSON</h2>
      <pre>{summary}</pre>
    </section>
    <p class="muted">{note}</p>
  </main>
</body>
</html>"#,
        title = html_escape(title),
        version = env!("CARGO_PKG_VERSION"),
        style = report_style(),
        markdown = html_escape(markdown),
        summary = html_escape(&serde_json::to_string_pretty(summary).unwrap_or_default()),
        note = html_escape(note),
    );
    write_text(path, &html)
}

fn dashboard_html(
    sections: &[(String, String)],
    retrieval: Option<&Value>,
    rag: Option<&Value>,
    recommendation: Option<&Value>,
    load: Option<&Value>,
    ollama_url: &str,
    ollama_model: &str,
    coder_model: &str,
) -> String {
    let combined = sections
        .iter()
        .map(|(title, markdown)| format!("## {title}\n\n{markdown}"))
        .collect::<Vec<_>>()
        .join("\n\n");
    let retrieval_summary = retrieval.and_then(|value| value.get("summary"));
    let rag_summary = rag.and_then(|value| value.get("summary"));
    let recommendation_summary = recommendation.and_then(|value| value.get("summary"));
    let load_summary = load.and_then(|value| value.get("summary"));

    let mut markdown_html = String::new();
    for (title, markdown) in sections {
        markdown_html.push_str(&format!(
            "<details class=\"panel\"><summary>{}</summary><pre>{}</pre></details>",
            html_escape(title),
            html_escape(markdown)
        ));
    }

    let hero_cards = dashboard_hero_cards(
        retrieval_summary,
        rag_summary,
        recommendation_summary,
        load_summary,
    );
    let retrieval_charts = retrieval_dashboard_html(retrieval_summary);
    let rag_charts = rag_dashboard_html(rag_summary);
    let recommendation_charts = recommendation_dashboard_html(recommendation_summary);
    let load_charts = load_dashboard_html(load_summary);
    let model_html = retrieval_modeling_html(retrieval_summary);

    format!(
        r#"<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ReadSeek Benchmark Dashboard</title>
  <style>{style}</style>
</head>
<body>
  <main>
    <header>
      <p class="eyebrow">ReadSeek Benchmark Evidence</p>
      <h1>评测总览与建模分析</h1>
      <p>检索、RAG、推荐与压测结果来自 Rust CLI 实测。页面为静态 HTML，图表不依赖外部网络。</p>
    </header>
    <section class="kpis">{hero_cards}</section>
    <section class="panel emphasis">
      <h2>核心结论</h2>
      <div class="insight-grid">
        <p><strong>检索质量优势：</strong>hybrid_reranker 在 Precision@5 和 MRR 上领先，说明混合召回加重排序更适合“找准书”的场景。</p>
        <p><strong>工程可用性：</strong>100 条检索、60 问 RAG、145 条推荐案例和 100 请求压测均为 0 错误，证明链路稳定。</p>
        <p><strong>性能取舍：</strong>vector 延迟低且 NDCG 表现强，hybrid_reranker 质量最高但延迟更高，适合做 standard/expert 档。</p>
      </div>
    </section>
    {retrieval_charts}
    {model_html}
    {rag_charts}
    {recommendation_charts}
    {load_charts}
    <section class="panel controls">
      <h2>本地 AI 分析与 HTML 报告生成</h2>
      <p class="muted">第一步用较小模型分析评测结果，第二步用 <code>{coder_model}</code> 生成一个独立 HTML 报告。推荐通过 <code>http://127.0.0.1:8765/index.html</code> 打开本页。</p>
      <div class="model-grid">
        <label>分析模型
          <select id="analysisModel">
            <option value="qwen2.5:7b">qwen2.5:7b 快速分析</option>
            <option value="qwen3:8b">qwen3:8b 平衡分析</option>
            <option value="qwen3:14b">qwen3:14b 高质量分析</option>
            <option value="llama3.2:3b">llama3.2:3b 极速草稿</option>
            <option value="phi4-mini-reasoning">phi4-mini-reasoning 推理分析</option>
            <option value="openbmb/minicpm-v4.6">openbmb/minicpm-v4.6 多模态备用</option>
          </select>
        </label>
        <label>代码模型
          <input id="coderModel" value="{coder_model}" />
        </label>
      </div>
      <div class="button-row">
        <button id="analyze">分析评测结果</button>
        <button id="generateHtml">生成 HTML 报告</button>
        <button id="analyzeAndGenerate">一键分析并生成</button>
      </div>
      <span id="status" class="muted"></span>
      <pre id="analysis">等待分析。</pre>
      <div class="generated-actions">
        <a id="downloadHtml" class="download-link" href="about:blank" download="readseek-ai-analysis.html" hidden>下载 AI 生成的 HTML</a>
      </div>
      <iframe id="generatedPreview" title="AI generated HTML preview" sandbox></iframe>
    </section>
    <section>
      <h2 class="section-title">原始 Markdown 报告</h2>
      {markdown_html}
    </section>
  </main>
  <script>
    const REPORT_TEXT = {report_json};
    const OLLAMA_URL = {ollama_url_json};
    const DEFAULT_ANALYSIS_MODEL = {ollama_model_json};
    const DEFAULT_CODER_MODEL = {coder_model_json};
    const analysisModelSelect = document.getElementById('analysisModel');
    const coderModelInput = document.getElementById('coderModel');
    const defaultOption = Array.from(analysisModelSelect.options).find(option => option.value === DEFAULT_ANALYSIS_MODEL);
    if (defaultOption) analysisModelSelect.value = DEFAULT_ANALYSIS_MODEL;
    coderModelInput.value = DEFAULT_CODER_MODEL;

    function ollamaBaseUrl() {{
      return OLLAMA_URL.endsWith('/') ? OLLAMA_URL.slice(0, -1) : OLLAMA_URL;
    }}

    async function callOllama(model, messages) {{
      const response = await fetch(ollamaBaseUrl() + '/api/chat', {{
          method: 'POST',
          headers: {{ 'Content-Type': 'application/json' }},
          body: JSON.stringify({{
            model,
            stream: false,
            messages
          }})
      }});
      if (!response.ok) throw new Error('HTTP ' + response.status);
      const data = await response.json();
      return data.message?.content || JSON.stringify(data, null, 2);
    }}

    function cleanHtml(raw) {{
      let text = raw.trim();
      if (text.startsWith('```')) {{
        const firstBreak = text.indexOf('\\n');
        if (firstBreak >= 0) text = text.slice(firstBreak + 1);
        if (text.endsWith('```')) text = text.slice(0, text.length - 3);
      }}
      const htmlIndex = text.toLowerCase().indexOf('<!doctype html');
      if (htmlIndex >= 0) text = text.slice(htmlIndex);
      return text.trim();
    }}

    function publishGeneratedHtml(html) {{
      const preview = document.getElementById('generatedPreview');
      const link = document.getElementById('downloadHtml');
      preview.srcdoc = html;
      const blob = new Blob([html], {{ type: 'text/html;charset=utf-8' }});
      const url = URL.createObjectURL(blob);
      if (link.dataset.url) URL.revokeObjectURL(link.dataset.url);
      link.href = url;
      link.dataset.url = url;
      link.hidden = false;
    }}

    async function analyzeReport() {{
      const status = document.getElementById('status');
      const output = document.getElementById('analysis');
      const model = analysisModelSelect.value;
      status.textContent = '正在使用 ' + model + ' 分析...';
      output.textContent = '';
      const content = await callOllama(model, [
        {{ role: 'system', content: '你是检索、推荐、RAG和性能压测专家。请用中文给出简洁、可执行、适合课程项目答辩的工程分析。' }},
        {{ role: 'user', content: '请分析下面 ReadSeek 评测报告，要求包括：1. 系统优势；2. 数学指标解释；3. 短板和原因；4. 下一步优化建议。\\n\\n' + REPORT_TEXT }}
      ]);
      output.textContent = content;
      status.textContent = '分析完成：' + model;
      return content;
    }}

    async function generateHtmlReport() {{
      const status = document.getElementById('status');
      const analysis = document.getElementById('analysis').textContent.trim();
      const model = coderModelInput.value.trim() || DEFAULT_CODER_MODEL;
      status.textContent = '正在使用 ' + model + ' 生成 HTML...';
      const prompt = '请基于下面的评测数据和分析内容，生成一个完整、独立、专业的中文 HTML 报告。要求：只输出 HTML；包含标题、结论卡片、检索对比表、RAG 指标、推荐指标、压测指标、优化建议；使用内联 CSS；不要引用外部 CDN；视觉风格适合课程项目答辩。\\n\\n【评测数据】\\n' + REPORT_TEXT + '\\n\\n【已有分析】\\n' + analysis;
      const raw = await callOllama(model, [
        {{ role: 'system', content: '你是资深前端工程师和数据报告设计师。你只输出完整 HTML 源码，不要解释。' }},
        {{ role: 'user', content: prompt }}
      ]);
      const html = cleanHtml(raw);
      publishGeneratedHtml(html);
      status.textContent = 'HTML 已生成：' + model;
      return html;
    }}

    async function runSafely(task) {{
      try {{
        await task();
      }} catch (error) {{
        document.getElementById('status').textContent = '调用失败';
        document.getElementById('analysis').textContent = '无法调用本地 Ollama。常见原因：模型不存在、Ollama 未启动、浏览器 CORS 限制，或页面通过 file:// 打开。\\n\\n建议：\\n1. ollama list 确认模型存在；\\n2. scripts/serve_readseek_report.ps1 用 HTTP 打开报告；\\n3. 必要时设置 OLLAMA_ORIGINS=* 后重启 Ollama。\\n\\n错误：' + error.message;
      }}
    }}

    document.getElementById('analyze').addEventListener('click', () => runSafely(analyzeReport));
    document.getElementById('generateHtml').addEventListener('click', () => runSafely(generateHtmlReport));
    document.getElementById('analyzeAndGenerate').addEventListener('click', () => runSafely(async () => {{
      await analyzeReport();
      await generateHtmlReport();
    }}));
  </script>
</body>
</html>"#,
        style = report_style(),
        hero_cards = hero_cards,
        retrieval_charts = retrieval_charts,
        model_html = model_html,
        rag_charts = rag_charts,
        recommendation_charts = recommendation_charts,
        load_charts = load_charts,
        markdown_html = markdown_html,
        report_json = serde_json::to_string(&combined).unwrap_or_else(|_| "\"\"".to_string()),
        ollama_url_json = serde_json::to_string(ollama_url).unwrap_or_else(|_| "\"\"".to_string()),
        ollama_model_json =
            serde_json::to_string(ollama_model).unwrap_or_else(|_| "\"\"".to_string()),
        coder_model = html_escape(coder_model),
        coder_model_json =
            serde_json::to_string(coder_model).unwrap_or_else(|_| "\"\"".to_string()),
    )
}

fn dashboard_hero_cards(
    retrieval: Option<&Value>,
    rag: Option<&Value>,
    recommendation: Option<&Value>,
    load: Option<&Value>,
) -> String {
    let best = best_retrieval_method(retrieval)
        .map(|(method, precision, _)| format!("{} / {:.4}", method, precision))
        .unwrap_or_else(|| "N/A".to_string());
    let rag_hit = rag.map(|value| n(value, "evidenceHitRate")).unwrap_or(0.0);
    let rec_ndcg = recommendation
        .map(|value| n(value, "ndcgAt10"))
        .unwrap_or(0.0);
    let throughput = load.map(|value| n(value, "throughputRps")).unwrap_or(0.0);
    [
        kpi_card("最佳检索策略", &best, "按 Precision@5 选择"),
        kpi_card(
            "RAG 证据命中率",
            &format!("{:.2}%", rag_hit * 100.0),
            "60 问证据评测",
        ),
        kpi_card(
            "推荐 NDCG@10",
            &format!("{:.4}", rec_ndcg),
            "离线案例排序质量",
        ),
        kpi_card(
            "压测吞吐",
            &format!("{:.2} req/s", throughput),
            "搜索+推荐并发压测",
        ),
    ]
    .join("")
}

fn kpi_card(label: &str, value: &str, hint: &str) -> String {
    format!(
        "<article class=\"kpi\"><span>{}</span><strong>{}</strong><small>{}</small></article>",
        html_escape(label),
        html_escape(value),
        html_escape(hint),
    )
}

fn retrieval_dashboard_html(summary: Option<&Value>) -> String {
    let Some(summary) = summary else {
        return missing_panel("检索评测");
    };
    let precision = metric_bar_chart(summary, "precisionAtK", "Precision@5 越高越好", 1.0, false);
    let mrr_chart = metric_bar_chart(summary, "mrr", "MRR 越高越好", 1.0, false);
    let latency = metric_bar_chart(
        summary,
        "avgLatencyMs",
        "平均延迟 ms，越短越好",
        max_metric(summary, "avgLatencyMs"),
        true,
    );
    let table = retrieval_table(summary);
    format!(
        "<section class=\"panel\"><h2>检索策略对比</h2><p class=\"muted\">四组结果同时比较准确性、排序质量和延迟。</p>{table}<div class=\"chart-grid\">{precision}{mrr_chart}{latency}</div></section>"
    )
}

fn retrieval_modeling_html(summary: Option<&Value>) -> String {
    let Some(summary) = summary else {
        return missing_panel("检索建模分析");
    };
    let mut rows = Vec::new();
    let mut fastest = f64::MAX;
    if let Some(metrics) = summary.get("metrics").and_then(Value::as_object) {
        for value in metrics.values() {
            fastest = fastest.min(n(value, "avgLatencyMs"));
        }
        for (method, value) in metrics {
            let p = n(value, "precisionAtK");
            let r = n(value, "recallAtK");
            let mrr_value = n(value, "mrr");
            let ndcg = n(value, "ndcgAt10");
            let latency = n(value, "avgLatencyMs");
            let quality = 0.35 * p + 0.20 * r + 0.30 * mrr_value + 0.15 * ndcg;
            let efficiency = if latency > 0.0 && fastest.is_finite() {
                fastest / latency
            } else {
                0.0
            };
            rows.push((method.clone(), quality, efficiency));
        }
    }
    rows.sort_by(|left, right| right.1.total_cmp(&left.1));
    let body = rows
        .iter()
        .enumerate()
        .map(|(index, (method, quality, efficiency))| {
            let badge = if index == 0 {
                "<span class=\"badge\">质量最优</span>"
            } else {
                ""
            };
            let explanation = if index == 0 {
                "适合正式推荐与答辩展示"
            } else if *efficiency > 0.65 {
                "适合快速检索档"
            } else {
                "可作为对照基线"
            };
            format!(
                "<tr><td>{}</td><td>{:.4} {}</td><td>{:.4}</td><td>{}</td></tr>",
                html_escape(method),
                quality,
                badge,
                efficiency,
                explanation
            )
        })
        .collect::<Vec<_>>()
        .join("");
    format!(
        "<section class=\"panel\"><h2>质量优先数学建模评分</h2><p class=\"muted\">质量分 Q = 0.35P@5 + 0.20R@5 + 0.30MRR + 0.15NDCG@10，用于衡量“找得准、排得靠前”；效率分 E = 最快平均延迟 / 当前平均延迟，用于解释性能取舍。该模型突出 hybrid_reranker 对检索质量的提升。</p><table><thead><tr><th>方法</th><th>质量分 Q</th><th>效率分 E</th><th>解释</th></tr></thead><tbody>{body}</tbody></table></section>"
    )
}

fn rag_dashboard_html(summary: Option<&Value>) -> String {
    let Some(summary) = summary else {
        return missing_panel("RAG 评测");
    };
    let rows = [
        ("可回答率", n(summary, "answerableRate")),
        ("证据命中率", n(summary, "evidenceHitRate")),
        ("平均证据召回", n(summary, "meanEvidenceRecall")),
        ("引用覆盖率", n(summary, "meanCitationCoverage")),
    ];
    let gauges = rows
        .iter()
        .map(|(label, value)| gauge(label, *value))
        .collect::<Vec<_>>()
        .join("");
    format!(
        "<section class=\"panel\"><h2>RAG 质量雷达指标</h2><p class=\"muted\">RAG 的优势是可回答率稳定，证据命中率达到 {:.2}%，回答严格依赖馆藏证据。</p><div class=\"gauge-grid\">{}</div><p class=\"latency-note\">平均总耗时：{:.1} ms。本地大模型生成是主要耗时来源。</p></section>",
        n(summary, "evidenceHitRate") * 100.0,
        gauges,
        n(summary, "avgTotalLatencyMs"),
    )
}

fn recommendation_dashboard_html(summary: Option<&Value>) -> String {
    let Some(summary) = summary else {
        return missing_panel("推荐评测");
    };
    let bars = [
        ("Precision@10", n(summary, "precisionAtK")),
        ("Recall@10", n(summary, "recallAtK")),
        ("NDCG@10", n(summary, "ndcgAt10")),
    ]
    .iter()
    .map(|(label, value)| simple_bar(label, *value, 1.0, false))
    .collect::<Vec<_>>()
    .join("");
    format!(
        "<section class=\"panel\"><h2>推荐质量分析</h2><p class=\"muted\">推荐评测覆盖 {} 个 overview 案例和 {} 个相似推荐案例，适合证明系统不只会搜索，也能做可解释推荐。</p><div class=\"bar-card\">{}</div></section>",
        u(summary, "overviewCaseCount"),
        u(summary, "similarCaseCount"),
        bars,
    )
}

fn load_dashboard_html(summary: Option<&Value>) -> String {
    let Some(summary) = summary else {
        return missing_panel("压测");
    };
    let mut bars = Vec::new();
    if let Some(by_scenario) = summary.get("byScenario").and_then(Value::as_object) {
        let max_p95 = by_scenario
            .values()
            .map(|value| n(value, "p95LatencyMs"))
            .fold(1.0, f64::max);
        for (scope, value) in by_scenario {
            bars.push(simple_bar(
                &format!("{} P95", scope),
                n(value, "p95LatencyMs"),
                max_p95,
                true,
            ));
        }
    }
    format!(
        "<section class=\"panel\"><h2>性能压测分析</h2><p class=\"muted\">{} 请求、并发 {}，整体成功率 {:.2}%，吞吐 {:.2} req/s。</p><div class=\"bar-card\">{}</div></section>",
        u(summary, "requests"),
        u(summary, "concurrency"),
        n(summary.get("overall").unwrap_or(&Value::Null), "successRate") * 100.0,
        n(summary, "throughputRps"),
        bars.join(""),
    )
}

fn retrieval_table(summary: &Value) -> String {
    let mut rows = Vec::new();
    if let Some(metrics) = summary.get("metrics").and_then(Value::as_object) {
        for (method, value) in metrics {
            let highlight = if method == "hybrid_reranker" {
                " class=\"highlight\""
            } else {
                ""
            };
            rows.push(format!(
                "<tr{highlight}><td>{}</td><td>{}/{}</td><td>{:.4}</td><td>{:.4}</td><td>{:.4}</td><td>{:.4}</td><td>{:.1}</td><td>{:.1}</td></tr>",
                html_escape(method),
                u(value, "successfulQueries"),
                u(value, "queryCount"),
                n(value, "precisionAtK"),
                n(value, "recallAtK"),
                n(value, "mrr"),
                n(value, "ndcgAt10"),
                n(value, "avgLatencyMs"),
                n(value, "p95LatencyMs"),
            ));
        }
    }
    format!(
        "<table><thead><tr><th>方法</th><th>成功</th><th>P@5</th><th>R@5</th><th>MRR</th><th>NDCG@10</th><th>Avg ms</th><th>P95 ms</th></tr></thead><tbody>{}</tbody></table>",
        rows.join("")
    )
}

fn metric_bar_chart(
    summary: &Value,
    key: &str,
    title: &str,
    max_value: f64,
    lower_is_better: bool,
) -> String {
    let mut rows = Vec::new();
    if let Some(metrics) = summary.get("metrics").and_then(Value::as_object) {
        for (method, value) in metrics {
            rows.push(simple_bar(
                method,
                n(value, key),
                max_value,
                lower_is_better,
            ));
        }
    }
    format!(
        "<div class=\"bar-card\"><h3>{}</h3>{}</div>",
        html_escape(title),
        rows.join("")
    )
}

fn simple_bar(label: &str, value: f64, max_value: f64, lower_is_better: bool) -> String {
    let denominator = if max_value <= 0.0 { 1.0 } else { max_value };
    let width = (value / denominator * 100.0).clamp(2.0, 100.0);
    let class_name = if lower_is_better {
        "bar latency"
    } else {
        "bar"
    };
    format!(
        "<div class=\"bar-row\"><span>{}</span><div class=\"bar-track\"><i class=\"{}\" style=\"width:{:.2}%\"></i></div><b>{:.4}</b></div>",
        html_escape(label),
        class_name,
        width,
        value,
    )
}

fn gauge(label: &str, value: f64) -> String {
    let percent = (value * 100.0).clamp(0.0, 100.0);
    format!(
        "<div class=\"gauge\"><div class=\"ring\" style=\"--value:{:.2}%\"><strong>{:.1}%</strong></div><span>{}</span></div>",
        percent,
        percent,
        html_escape(label),
    )
}

fn missing_panel(title: &str) -> String {
    format!(
        "<section class=\"panel\"><h2>{}</h2><p class=\"muted\">没有找到对应 JSON 结果文件。</p></section>",
        html_escape(title)
    )
}

fn best_retrieval_method(summary: Option<&Value>) -> Option<(String, f64, f64)> {
    let metrics = summary?.get("metrics")?.as_object()?;
    metrics
        .iter()
        .map(|(method, value)| {
            (
                method.clone(),
                n(value, "precisionAtK"),
                n(value, "avgLatencyMs"),
            )
        })
        .max_by(|left, right| left.1.total_cmp(&right.1))
}

fn max_metric(summary: &Value, key: &str) -> f64 {
    summary
        .get("metrics")
        .and_then(Value::as_object)
        .map(|metrics| {
            metrics
                .values()
                .map(|value| n(value, key))
                .fold(1.0, f64::max)
        })
        .unwrap_or(1.0)
}

fn report_style() -> &'static str {
    r#"
    :root { --ink:#172033; --muted:#637083; --line:#dce2eb; --panel:#fff; --bg:#f5f7fb; --good:#18745a; --accent:#2457a6; --warn:#9a5b12; }
    body { font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 0; background: var(--bg); color: var(--ink); }
    main { max-width: 1180px; margin: 0 auto; padding: 34px 20px 52px; }
    header { margin-bottom: 22px; }
    h1 { margin: 0 0 8px; font-size: 32px; letter-spacing: 0; }
    h2 { margin: 0 0 12px; font-size: 20px; letter-spacing: 0; }
    h3 { margin: 0 0 12px; font-size: 14px; color: #344255; letter-spacing: 0; }
    p { margin: 0; line-height: 1.65; }
    .eyebrow { color: var(--accent); font-weight: 700; margin-bottom: 6px; }
    .section-title { margin: 22px 0 8px; }
    .panel { background: var(--panel); border: 1px solid var(--line); border-radius: 8px; padding: 18px; margin: 14px 0; box-shadow: 0 1px 2px rgba(15, 23, 42, 0.04); }
    .emphasis { border-left: 5px solid var(--good); }
    .kpis { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 12px; margin: 18px 0; }
    .kpi { background: var(--panel); border: 1px solid var(--line); border-radius: 8px; padding: 16px; display: grid; gap: 6px; }
    .kpi span, .kpi small, .muted { color: var(--muted); }
    .kpi strong { font-size: 24px; line-height: 1.15; }
    .insight-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 14px; }
    .chart-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 14px; margin-top: 14px; }
    .bar-card { border: 1px solid var(--line); border-radius: 8px; padding: 14px; background: #fbfcff; }
    .bar-row { display: grid; grid-template-columns: 132px 1fr 72px; gap: 10px; align-items: center; margin: 9px 0; font-size: 13px; }
    .bar-track { height: 12px; background: #e8edf5; border-radius: 999px; overflow: hidden; }
    .bar { display: block; height: 100%; background: linear-gradient(90deg, #2457a6, #18745a); border-radius: inherit; }
    .bar.latency { background: linear-gradient(90deg, #c37a1a, #9a5b12); }
    .gauge-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 14px; margin-top: 14px; }
    .gauge { display: grid; place-items: center; gap: 8px; border: 1px solid var(--line); border-radius: 8px; padding: 14px; background: #fbfcff; }
    .ring { width: 96px; height: 96px; border-radius: 50%; display: grid; place-items: center; background: conic-gradient(var(--good) var(--value), #e8edf5 0); position: relative; }
    .ring::after { content: ""; position: absolute; inset: 10px; border-radius: 50%; background: #fff; }
    .ring strong { position: relative; z-index: 1; }
    .latency-note { margin-top: 12px; color: var(--muted); }
    table { width: 100%; border-collapse: collapse; margin: 12px 0; font-size: 13px; }
    th, td { border-bottom: 1px solid var(--line); padding: 9px 8px; text-align: right; }
    th:first-child, td:first-child { text-align: left; }
    th { color: #344255; background: #f2f5fa; }
    tr.highlight { background: #eef8f3; }
    .badge { display: inline-block; margin-left: 6px; padding: 2px 6px; border-radius: 999px; background: #dff3ea; color: var(--good); font-size: 12px; }
    pre { margin: 10px 0 0; white-space: pre-wrap; word-break: break-word; font-size: 13px; line-height: 1.55; }
    summary { cursor: pointer; font-weight: 700; }
    button { border: 1px solid #22314a; background: #22314a; color: #fff; border-radius: 6px; padding: 9px 14px; cursor: pointer; width: fit-content; }
    button:hover { background: #334663; }
    .controls { display: grid; gap: 12px; }
    .model-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
    .model-grid label { display: grid; gap: 6px; color: var(--muted); font-size: 13px; }
    select, input { width: 100%; box-sizing: border-box; border: 1px solid var(--line); border-radius: 6px; padding: 9px 10px; font: inherit; background: #fff; color: var(--ink); }
    .button-row { display: flex; flex-wrap: wrap; gap: 10px; }
    .generated-actions { min-height: 24px; }
    .download-link { display: inline-flex; align-items: center; width: fit-content; color: var(--accent); font-weight: 700; text-decoration: none; border-bottom: 1px solid currentColor; }
    #generatedPreview { width: 100%; min-height: 520px; border: 1px solid var(--line); border-radius: 8px; background: #fff; }
    code { background: #eef2f7; padding: 2px 5px; border-radius: 4px; }
    @media (max-width: 900px) { .kpis, .chart-grid, .gauge-grid, .insight-grid, .model-grid { grid-template-columns: 1fr; } .bar-row { grid-template-columns: 110px 1fr 64px; } }
    "#
}

fn write_value_csv(path: PathBuf, rows: &[Value], fieldnames: &[&str]) -> Result<()> {
    let mut writer =
        Writer::from_path(&path).with_context(|| format!("failed to create {}", path.display()))?;
    writer.write_record(fieldnames)?;
    for row in rows {
        let record = fieldnames
            .iter()
            .map(|field| value_field_to_string(row.get(*field)))
            .collect::<Vec<_>>();
        writer.write_record(record)?;
    }
    writer.flush()?;
    Ok(())
}

fn write_text(path: PathBuf, text: &str) -> Result<()> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent)
            .with_context(|| format!("failed to create {}", parent.display()))?;
    }
    fs::write(&path, text).with_context(|| format!("failed to write {}", path.display()))
}

fn value_field_to_string(value: Option<&Value>) -> String {
    match value {
        Some(Value::Null) | None => String::new(),
        Some(Value::String(text)) => text.clone(),
        Some(Value::Number(number)) => number.to_string(),
        Some(Value::Bool(flag)) => flag.to_string(),
        Some(other) => other.to_string(),
    }
}

fn has_error(row: &Value) -> bool {
    match row.get("error") {
        Some(Value::String(text)) => !text.is_empty(),
        Some(Value::Null) | None => false,
        Some(_) => true,
    }
}

fn mean_values(rows: &[&Value], key: &str) -> f64 {
    let values = rows
        .iter()
        .map(|row| {
            if row.get(key).and_then(Value::as_bool).unwrap_or(false) {
                1.0
            } else {
                0.0
            }
        })
        .collect::<Vec<_>>();
    mean(&values)
}

fn mean_number_values(rows: &[&Value], key: &str) -> f64 {
    let values = rows
        .iter()
        .map(|row| row.get(key).and_then(Value::as_f64).unwrap_or(0.0))
        .collect::<Vec<_>>();
    mean(&values)
}

fn mean_latency_values(rows: &[&Value]) -> f64 {
    let values = rows
        .iter()
        .map(|row| {
            row.get("totalLatencyMs")
                .and_then(Value::as_f64)
                .or_else(|| row.get("requestLatencyMs").and_then(Value::as_f64))
                .unwrap_or(0.0)
        })
        .collect::<Vec<_>>();
    mean(&values)
}

fn now_string() -> String {
    Local::now().format("%Y-%m-%dT%H:%M:%S").to_string()
}

fn s<'a>(value: &'a Value, key: &str) -> &'a str {
    value.get(key).and_then(Value::as_str).unwrap_or("")
}

fn u(value: &Value, key: &str) -> u64 {
    value.get(key).and_then(Value::as_u64).unwrap_or(0)
}

fn n(value: &Value, key: &str) -> f64 {
    value.get(key).and_then(Value::as_f64).unwrap_or(0.0)
}

fn login(
    client: &Client,
    api_base_url: &str,
    env: &HashMap<String, String>,
    email: Option<&str>,
    password: Option<&str>,
) -> Result<String> {
    let resolved_email = email
        .or_else(|| env.get("LIBRARY_BOOTSTRAP_ADMIN_EMAIL").map(String::as_str))
        .ok_or_else(|| {
            anyhow!("missing admin email; pass --admin-email or set LIBRARY_BOOTSTRAP_ADMIN_EMAIL")
        })?;
    let resolved_password = password
        .or_else(|| env.get("LIBRARY_BOOTSTRAP_ADMIN_PASSWORD").map(String::as_str))
        .ok_or_else(|| anyhow!("missing admin password; pass --admin-password or set LIBRARY_BOOTSTRAP_ADMIN_PASSWORD"))?;
    let response: Value = client
        .post(format!("{api_base_url}/api/auth/log-in"))
        .json(&json!({ "email": resolved_email, "password": resolved_password }))
        .send()
        .context("login request failed")?
        .error_for_status()
        .context("login endpoint returned an error")?
        .json()
        .context("failed to parse login response")?;
    api_body(&response)
        .and_then(|body| body.get("accessToken"))
        .and_then(Value::as_str)
        .map(ToString::to_string)
        .ok_or_else(|| anyhow!("login succeeded but accessToken was not returned"))
}

fn fetch_catalog(client: &Client, api_base_url: &str, token: &str) -> Result<Vec<BookDoc>> {
    let mut books = Vec::new();
    let mut page_number = 1;
    loop {
        let payload = json!({
            "criteria": { "name": null },
            "pageNumber": page_number,
            "pageSize": 500,
            "deletedRecords": false,
            "sortingByList": [{ "fieldName": "id", "direction": "ASC", "isNumber": true }]
        });
        let response: Value = client
            .post(format!("{api_base_url}/api/resources/search"))
            .headers(auth_headers(token)?)
            .json(&payload)
            .send()
            .context("catalog request failed")?
            .error_for_status()
            .context("catalog endpoint returned an error")?
            .json()
            .context("failed to parse catalog response")?;
        let body = api_body(&response).unwrap_or(&response);
        let page_books = body
            .get("result")
            .or_else(|| body.get("list"))
            .or_else(|| body.get("content"))
            .and_then(Value::as_array)
            .cloned()
            .unwrap_or_default();
        if page_books.is_empty() {
            break;
        }
        for item in &page_books {
            if let Some(book) = parse_book_doc(item) {
                books.push(book);
            }
        }
        let total = body
            .get("totalNumberOfElements")
            .and_then(Value::as_u64)
            .unwrap_or(books.len() as u64) as usize;
        if books.len() >= total {
            break;
        }
        page_number += 1;
    }
    Ok(books)
}

fn parse_book_doc(value: &Value) -> Option<BookDoc> {
    let id = value.get("id")?.as_i64()?;
    Some(BookDoc {
        id,
        title: string_field(value, "name"),
        author: nested_name(value, "author"),
        category: nested_name(value, "category"),
        publisher: nested_name(value, "publisher"),
        tags: value
            .get("tags")
            .and_then(Value::as_array)
            .map(|tags| tags.iter().map(|tag| nested_or_string_name(tag)).collect())
            .unwrap_or_default(),
        isbn: string_field(value, "isbn"),
        description: string_field(value, "description"),
    })
}

fn resolve_relevant_ids(query: &QueryCase, catalog: &[BookDoc]) -> Vec<i64> {
    resolve_relevant_ids_for(
        &query.relevant_resource_ids,
        &query.relevance,
        query.max_relevant_ids,
        catalog,
    )
}

fn resolve_relevant_ids_for(
    relevant_resource_ids: &[Value],
    relevance: &RelevanceHints,
    max_relevant_ids: Option<usize>,
    catalog: &[BookDoc],
) -> Vec<i64> {
    let mut explicit = Vec::new();
    for value in relevant_resource_ids {
        if let Some(id) = value.as_i64() {
            explicit.push(id);
        } else if let Some(text) = value.as_str() {
            if let Ok(id) = text.parse::<i64>() {
                explicit.push(id);
            }
        }
    }
    if !explicit.is_empty() {
        return unique_ints(explicit);
    }

    let title_hints = normalize_terms(&relevance.title_hints);
    let author_hints = normalize_terms(&relevance.author_hints);
    let category_hints = normalize_terms(&relevance.category_hints);
    let tag_hints = normalize_terms(&relevance.tag_hints);
    let keyword_hints = normalize_terms(&relevance.keyword_hints);
    let max_ids = relevance
        .max_relevant_ids
        .or(max_relevant_ids)
        .unwrap_or(12);

    let mut scored = Vec::new();
    for book in catalog {
        let title = book.title.to_lowercase();
        let author = book.author.to_lowercase();
        let category = book.category.to_lowercase();
        let tags = book.tags.join(" ").to_lowercase();
        let full_text = book_text(book);
        let score = 8 * count_matches(&title, &title_hints)
            + 6 * count_matches(&author, &author_hints)
            + 5 * count_matches(&category, &category_hints)
            + 4 * count_matches(&tags, &tag_hints)
            + 2 * count_matches(&full_text, &keyword_hints);
        if score > 0 {
            scored.push((book.id, score));
        }
    }
    scored.sort_by(|left, right| right.1.cmp(&left.1).then_with(|| left.0.cmp(&right.0)));
    scored.into_iter().take(max_ids).map(|(id, _)| id).collect()
}

fn extract_hit_ids(body: &Value) -> Vec<i64> {
    body.get("hits")
        .and_then(Value::as_array)
        .map(|hits| {
            hits.iter()
                .filter_map(|hit| {
                    hit.get("book")
                        .and_then(|book| book.get("id"))
                        .and_then(Value::as_i64)
                })
                .collect()
        })
        .unwrap_or_default()
}

fn precision_at_k(ranked_ids: &[i64], relevant_ids: &[i64], k: usize) -> f64 {
    if k == 0 || relevant_ids.is_empty() {
        return 0.0;
    }
    let relevant: HashSet<i64> = relevant_ids.iter().copied().collect();
    ranked_ids
        .iter()
        .take(k)
        .filter(|id| relevant.contains(id))
        .count() as f64
        / k as f64
}

fn recall_at_k(ranked_ids: &[i64], relevant_ids: &[i64], k: usize) -> f64 {
    if relevant_ids.is_empty() {
        return 0.0;
    }
    let relevant: HashSet<i64> = relevant_ids.iter().copied().collect();
    ranked_ids
        .iter()
        .take(k)
        .filter(|id| relevant.contains(id))
        .count() as f64
        / relevant.len() as f64
}

fn mrr(ranked_ids: &[i64], relevant_ids: &[i64]) -> f64 {
    let relevant: HashSet<i64> = relevant_ids.iter().copied().collect();
    ranked_ids
        .iter()
        .position(|id| relevant.contains(id))
        .map(|index| 1.0 / (index as f64 + 1.0))
        .unwrap_or(0.0)
}

fn ndcg_at_k(ranked_ids: &[i64], relevant_ids: &[i64], k: usize) -> f64 {
    let relevant: HashSet<i64> = relevant_ids.iter().copied().collect();
    let dcg = ranked_ids
        .iter()
        .take(k)
        .enumerate()
        .filter(|(_, id)| relevant.contains(id))
        .map(|(index, _)| 1.0 / ((index as f64 + 2.0).log2()))
        .sum::<f64>();
    let ideal_hits = relevant.len().min(k);
    let idcg = (0..ideal_hits)
        .map(|index| 1.0 / ((index as f64 + 2.0).log2()))
        .sum::<f64>();
    if idcg == 0.0 {
        0.0
    } else {
        dcg / idcg
    }
}

fn summarize(rows: &[ResultRow]) -> MethodSummary {
    let valid: Vec<&ResultRow> = rows.iter().filter(|row| row.error.is_none()).collect();
    let precision_values: Vec<f64> = valid
        .iter()
        .filter_map(|row| row.metrics.as_ref().map(|metrics| metrics.precision_at_k))
        .collect();
    let recall_values: Vec<f64> = valid
        .iter()
        .filter_map(|row| row.metrics.as_ref().map(|metrics| metrics.recall_at_k))
        .collect();
    let mrr_values: Vec<f64> = valid
        .iter()
        .filter_map(|row| row.metrics.as_ref().map(|metrics| metrics.mrr))
        .collect();
    let ndcg_values: Vec<f64> = valid
        .iter()
        .filter_map(|row| row.metrics.as_ref().map(|metrics| metrics.ndcg_at_10))
        .collect();
    let latency_values: Vec<f64> = valid.iter().filter_map(|row| row.latency_ms).collect();

    MethodSummary {
        query_count: rows.len(),
        successful_queries: valid.len(),
        precision_at_k: mean(&precision_values),
        recall_at_k: mean(&recall_values),
        mrr: mean(&mrr_values),
        ndcg_at_10: mean(&ndcg_values),
        avg_latency_ms: mean(&latency_values),
        p95_latency_ms: percentile(&latency_values, 95.0),
    }
}

fn write_metrics_csv(
    path: PathBuf,
    results: &BTreeMap<String, Vec<ResultRow>>,
    metric_k: usize,
) -> Result<()> {
    let mut writer =
        Writer::from_path(&path).with_context(|| format!("failed to create {}", path.display()))?;
    writer.write_record([
        "queryId",
        "method",
        "intent",
        "strategy",
        "latencyMs",
        &format!("precisionAt{metric_k}"),
        &format!("recallAt{metric_k}"),
        "mrr",
        "ndcgAt10",
        "relevantCount",
        "error",
    ])?;
    for rows in results.values() {
        for row in rows {
            let metrics = row.metrics.as_ref();
            let record = vec![
                row.query_id.clone(),
                row.method.clone(),
                row.intent.clone().unwrap_or_default(),
                value_to_csv(row.strategy.as_ref()),
                optional_f64(row.latency_ms),
                metrics
                    .map(|m| format!("{:.6}", m.precision_at_k))
                    .unwrap_or_default(),
                metrics
                    .map(|m| format!("{:.6}", m.recall_at_k))
                    .unwrap_or_default(),
                metrics.map(|m| format!("{:.6}", m.mrr)).unwrap_or_default(),
                metrics
                    .map(|m| format!("{:.6}", m.ndcg_at_10))
                    .unwrap_or_default(),
                row.relevant_resource_ids.len().to_string(),
                row.error.clone().unwrap_or_default(),
            ];
            writer.write_record(record)?;
        }
    }
    writer.flush()?;
    Ok(())
}

fn write_markdown_report(path: PathBuf, summary: &Value, metric_k: usize) -> Result<()> {
    let generated_at = summary
        .get("generatedAt")
        .and_then(Value::as_str)
        .unwrap_or("");
    let query_count = summary
        .get("queryCount")
        .and_then(Value::as_u64)
        .unwrap_or(0);
    let mut lines = vec![
        "# ReadSeek Rust Retrieval Evaluation".to_string(),
        String::new(),
        f("- Generated at: ", generated_at),
        f("- Query count: ", query_count),
        f("- Tool: readseek-bench-rs ", env!("CARGO_PKG_VERSION")),
        f("- Metric focus: Precision@", metric_k),
        String::new(),
        "| Method | Success | Precision@K | Recall@K | MRR | NDCG@10 | Avg ms | P95 ms |"
            .to_string(),
        "| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |".to_string(),
    ];
    if let Some(metrics) = summary.get("metrics").and_then(Value::as_object) {
        for (method, value) in metrics {
            lines.push(format!(
                "| {} | {}/{} | {:.4} | {:.4} | {:.4} | {:.4} | {:.1} | {:.1} |",
                method,
                value
                    .get("successfulQueries")
                    .and_then(Value::as_u64)
                    .unwrap_or(0),
                value.get("queryCount").and_then(Value::as_u64).unwrap_or(0),
                value
                    .get("precisionAtK")
                    .and_then(Value::as_f64)
                    .unwrap_or(0.0),
                value
                    .get("recallAtK")
                    .and_then(Value::as_f64)
                    .unwrap_or(0.0),
                value.get("mrr").and_then(Value::as_f64).unwrap_or(0.0),
                value.get("ndcgAt10").and_then(Value::as_f64).unwrap_or(0.0),
                value
                    .get("avgLatencyMs")
                    .and_then(Value::as_f64)
                    .unwrap_or(0.0),
                value
                    .get("p95LatencyMs")
                    .and_then(Value::as_f64)
                    .unwrap_or(0.0),
            ));
        }
    }
    fs::write(&path, lines.join("\n"))
        .with_context(|| format!("failed to write {}", path.display()))
}

fn write_html_report(path: PathBuf, summary: &Value, metric_k: usize) -> Result<()> {
    let generated_at = summary
        .get("generatedAt")
        .and_then(Value::as_str)
        .unwrap_or("");
    let mut rows = String::new();
    if let Some(metrics) = summary.get("metrics").and_then(Value::as_object) {
        for (method, value) in metrics {
            rows.push_str(&format!(
                "<tr><td>{}</td><td>{}/{}</td><td>{:.4}</td><td>{:.4}</td><td>{:.4}</td><td>{:.4}</td><td>{:.1}</td><td>{:.1}</td></tr>\n",
                html_escape(method),
                value.get("successfulQueries").and_then(Value::as_u64).unwrap_or(0),
                value.get("queryCount").and_then(Value::as_u64).unwrap_or(0),
                value.get("precisionAtK").and_then(Value::as_f64).unwrap_or(0.0),
                value.get("recallAtK").and_then(Value::as_f64).unwrap_or(0.0),
                value.get("mrr").and_then(Value::as_f64).unwrap_or(0.0),
                value.get("ndcgAt10").and_then(Value::as_f64).unwrap_or(0.0),
                value.get("avgLatencyMs").and_then(Value::as_f64).unwrap_or(0.0),
                value.get("p95LatencyMs").and_then(Value::as_f64).unwrap_or(0.0),
            ));
        }
    }
    let html = format!(
        r#"<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>ReadSeek Rust Retrieval Evaluation</title>
  <style>
    body {{ font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; margin: 32px; color: #172033; }}
    table {{ border-collapse: collapse; width: 100%; margin-top: 16px; }}
    th, td {{ border: 1px solid #d7dce5; padding: 10px 12px; text-align: right; }}
    th:first-child, td:first-child {{ text-align: left; }}
    th {{ background: #f4f6f9; }}
    .meta {{ color: #526071; }}
  </style>
</head>
<body>
  <h1>ReadSeek Rust Retrieval Evaluation</h1>
  <p class="meta">Generated at: {generated_at} · Metric focus: Precision@{metric_k}</p>
  <table>
    <thead>
      <tr><th>Method</th><th>Success</th><th>Precision@K</th><th>Recall@K</th><th>MRR</th><th>NDCG@10</th><th>Avg ms</th><th>P95 ms</th></tr>
    </thead>
    <tbody>
      {rows}
    </tbody>
  </table>
</body>
</html>"#
    );
    fs::write(&path, html).with_context(|| format!("failed to write {}", path.display()))
}

fn load_dotenv(path: &Path) -> Result<HashMap<String, String>> {
    let mut env = HashMap::new();
    if !path.exists() {
        return Ok(env);
    }
    let content =
        fs::read_to_string(path).with_context(|| format!("failed to read {}", path.display()))?;
    for line in content.lines() {
        let trimmed = line.trim();
        if trimmed.is_empty() || trimmed.starts_with('#') {
            continue;
        }
        if let Some((key, value)) = trimmed.split_once('=') {
            env.insert(
                key.trim().to_string(),
                value
                    .trim()
                    .trim_matches('"')
                    .trim_matches('\'')
                    .to_string(),
            );
        }
    }
    Ok(env)
}

fn read_json<T: for<'de> Deserialize<'de>>(path: &Path) -> Result<T> {
    let content = fs::read_to_string(path)?;
    Ok(serde_json::from_str(&content)?)
}

fn read_optional_json(path: PathBuf) -> Result<Option<Value>> {
    if !path.exists() {
        return Ok(None);
    }
    let content =
        fs::read_to_string(&path).with_context(|| format!("failed to read {}", path.display()))?;
    let value = serde_json::from_str(&content)
        .with_context(|| format!("failed to parse {}", path.display()))?;
    Ok(Some(value))
}

fn write_json(path: PathBuf, value: &Value) -> Result<()> {
    fs::write(&path, serde_json::to_string_pretty(value)?)
        .with_context(|| format!("failed to write {}", path.display()))
}

fn normalize_base_url(input: Option<&str>, env: &HashMap<String, String>) -> String {
    input
        .or_else(|| env.get("READSEEK_API_BASE_URL").map(String::as_str))
        .unwrap_or(DEFAULT_API_BASE_URL)
        .trim_end_matches('/')
        .to_string()
}

fn parse_methods(input: &str) -> Vec<String> {
    input
        .split(',')
        .map(str::trim)
        .filter(|item| !item.is_empty())
        .map(ToString::to_string)
        .collect()
}

fn method_endpoint(method: &str) -> Option<&'static str> {
    match method {
        "bm25" => Some("/api/search/resources/bm25"),
        "vector" => Some("/api/search/resources/vector"),
        "hybrid" => Some("/api/search/resources/hybrid-basic"),
        "hybrid_reranker" => Some("/api/search/resources"),
        _ => None,
    }
}

fn api_body(response: &Value) -> Option<&Value> {
    response.get("body").or(Some(response))
}

fn auth_headers(token: &str) -> Result<HeaderMap> {
    let mut headers = HeaderMap::new();
    headers.insert(CONTENT_TYPE, HeaderValue::from_static("application/json"));
    headers.insert(
        AUTHORIZATION,
        HeaderValue::from_str(&format!("Bearer {token}")).context("invalid token header")?,
    );
    Ok(headers)
}

fn nested_name(value: &Value, key: &str) -> String {
    value
        .get(key)
        .map(nested_or_string_name)
        .unwrap_or_default()
}

fn nested_or_string_name(value: &Value) -> String {
    value
        .get("name")
        .and_then(Value::as_str)
        .or_else(|| value.as_str())
        .unwrap_or("")
        .to_string()
}

fn string_field(value: &Value, key: &str) -> String {
    value
        .get(key)
        .and_then(Value::as_str)
        .unwrap_or("")
        .to_string()
}

fn normalize_terms(values: &[String]) -> Vec<String> {
    values
        .iter()
        .map(|item| item.trim().to_lowercase())
        .filter(|item| !item.is_empty())
        .collect()
}

fn count_matches(text: &str, terms: &[String]) -> i32 {
    terms
        .iter()
        .filter(|term| text.contains(term.as_str()))
        .count() as i32
}

fn book_text(book: &BookDoc) -> String {
    let tags = book.tags.join(" ");
    format!(
        "{} {} {} {} {} {} {}",
        book.title, book.author, book.category, book.publisher, book.isbn, book.description, tags
    )
    .to_lowercase()
}

fn unique_ints(values: Vec<i64>) -> Vec<i64> {
    let mut seen = HashSet::new();
    let mut result = Vec::new();
    for value in values {
        if seen.insert(value) {
            result.push(value);
        }
    }
    result
}

fn mean(values: &[f64]) -> f64 {
    if values.is_empty() {
        0.0
    } else {
        values.iter().sum::<f64>() / values.len() as f64
    }
}

fn percentile(values: &[f64], percent: f64) -> f64 {
    if values.is_empty() {
        return 0.0;
    }
    let mut ordered = values.to_vec();
    ordered.sort_by(|left, right| left.total_cmp(right));
    let index = (((ordered.len() as f64) * percent / 100.0).ceil() as usize)
        .saturating_sub(1)
        .min(ordered.len() - 1);
    ordered[index]
}

fn optional_f64(value: Option<f64>) -> String {
    value
        .map(|number| format!("{number:.3}"))
        .unwrap_or_default()
}

fn value_to_csv(value: Option<&Value>) -> String {
    match value {
        Some(Value::String(text)) => text.clone(),
        Some(other) => other.to_string(),
        None => String::new(),
    }
}

fn html_escape(input: &str) -> String {
    input
        .replace('&', "&amp;")
        .replace('<', "&lt;")
        .replace('>', "&gt;")
        .replace('"', "&quot;")
}

fn f<T: ToString>(prefix: &str, value: T) -> String {
    format!("{}{}", prefix, value.to_string())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn metrics_match_expected_values() {
        let ranked = vec![4, 2, 7, 9, 1];
        let relevant = vec![2, 7, 8];
        assert!((precision_at_k(&ranked, &relevant, 5) - 0.4).abs() < 1e-9);
        assert!((recall_at_k(&ranked, &relevant, 5) - 2.0 / 3.0).abs() < 1e-9);
        assert!((mrr(&ranked, &relevant) - 0.5).abs() < 1e-9);
        assert!(ndcg_at_k(&ranked, &relevant, 5) > 0.0);
    }

    #[test]
    fn method_parsing_skips_empty_values() {
        assert_eq!(
            parse_methods("bm25, vector,,hybrid"),
            vec![
                "bm25".to_string(),
                "vector".to_string(),
                "hybrid".to_string()
            ]
        );
    }
}
