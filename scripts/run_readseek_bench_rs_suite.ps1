[CmdletBinding()]
param(
    [string]$Cargo = "$env:USERPROFILE\.cargo\bin\cargo.exe",
    [string]$OutputDir = '..\docs\evaluation\generated\rust-suite',
    [int]$RetrievalQueryLimit = -1,
    [int]$RagQuestionLimit = -1,
    [int]$LoadRequests = 100,
    [int]$LoadConcurrency = 8,
    [string]$OllamaModel = 'qwen2.5:7b',
    [string]$CoderModel = 'qwen2.5-coder:7b'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$benchRoot = Join-Path $repoRoot 'readseek-bench-rs'

if (-not (Test-Path $Cargo)) {
    $cargoCommand = Get-Command cargo -ErrorAction SilentlyContinue
    if ($cargoCommand) {
        $Cargo = $cargoCommand.Source
    } else {
        throw "cargo.exe not found. Install Rust from https://rustup.rs or pass -Cargo <path-to-cargo.exe>."
    }
}

function Invoke-Bench {
    param([string[]]$Arguments)
    Push-Location $benchRoot
    try {
        & $Cargo @Arguments
    } finally {
        Pop-Location
    }
}

$common = @('run', '--release', '--')
$envFile = '..\.env'

$retrievalArgs = $common + @(
    'retrieval',
    '--env-file', $envFile,
    '--queries', '..\docs\evaluation\search_queries_100.json',
    '--output-dir', $OutputDir,
    '--limit', '10',
    '--metric-k', '5',
    '--methods', 'bm25,vector,hybrid,hybrid_reranker'
)
if ($RetrievalQueryLimit -ge 0) {
    $retrievalArgs += @('--query-limit', [string]$RetrievalQueryLimit)
}
Invoke-Bench $retrievalArgs

$recommendationArgs = $common + @(
    'recommendation',
    '--env-file', $envFile,
    '--queries', '..\docs\evaluation\search_queries_100.json',
    '--output-dir', $OutputDir,
    '--metric-k', '10',
    '--similar-anchor-limit', '25'
)
Invoke-Bench $recommendationArgs

$ragArgs = $common + @(
    'rag',
    '--env-file', $envFile,
    '--questions', '..\docs\evaluation\rag_questions_60.json',
    '--output-dir', $OutputDir,
    '--mode', 'standard',
    '--provider', 'ollama',
    '--limit', '8'
)
if ($RagQuestionLimit -ge 0) {
    $ragArgs += @('--question-limit', [string]$RagQuestionLimit)
}
Invoke-Bench $ragArgs

$loadArgs = $common + @(
    'load',
    '--env-file', $envFile,
    '--output-dir', $OutputDir,
    '--scenarios', 'search,recommendation',
    '--requests', [string]$LoadRequests,
    '--concurrency', [string]$LoadConcurrency
)
Invoke-Bench $loadArgs

$dashboardArgs = $common + @(
    'dashboard',
    '--input-dir', $OutputDir,
    '--output', (Join-Path $OutputDir 'index.html'),
    '--ollama-model', $OllamaModel,
    '--coder-model', $CoderModel
)
Invoke-Bench $dashboardArgs
