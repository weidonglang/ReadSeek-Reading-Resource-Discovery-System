[CmdletBinding()]
param(
    [string]$Cargo = "$env:USERPROFILE\.cargo\bin\cargo.exe",
    [string]$EnvFile = '..\.env',
    [string]$Queries = '..\docs\evaluation\search_queries_100.json',
    [string]$OutputDir = '..\docs\evaluation\generated\rust',
    [int]$Limit = 10,
    [int]$QueryLimit = -1,
    [int]$MetricK = 5,
    [string]$Methods = 'bm25,vector,hybrid,hybrid_reranker'
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

Push-Location $benchRoot
try {
    $arguments = @(
        'run', '--release', '--', 'retrieval',
        '--env-file', $EnvFile,
        '--queries', $Queries,
        '--output-dir', $OutputDir,
        '--limit', $Limit,
        '--metric-k', $MetricK,
        '--methods', $Methods
    )
    if ($QueryLimit -ge 0) {
        $arguments += @('--query-limit', $QueryLimit)
    }
    & $Cargo @arguments
} finally {
    Pop-Location
}
