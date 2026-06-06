[CmdletBinding()]
param(
    [string]$ReportDir = 'docs\evaluation\generated\rust-suite',
    [int]$Port = 8765
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$fullReportDir = Resolve-Path (Join-Path $repoRoot $ReportDir)

$python = Join-Path $repoRoot '.venv-ai\Scripts\python.exe'
if (-not (Test-Path $python)) {
    $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonCommand) {
        $python = $pythonCommand.Source
    } else {
        throw 'python.exe not found.'
    }
}

Write-Host "Serving ReadSeek report from $fullReportDir" -ForegroundColor Cyan
Write-Host "Open: http://127.0.0.1:$Port/index.html" -ForegroundColor Green
Write-Host 'Press Ctrl+C to stop.' -ForegroundColor DarkGray

Push-Location $fullReportDir
try {
    & $python -m http.server $Port --bind 127.0.0.1
} finally {
    Pop-Location
}
