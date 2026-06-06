[CmdletBinding()]
param(
    [string]$PythonExe = '',
    [string]$BindHost = '127.0.0.1',
    [int]$Port = 8001,
    [int]$Dimensions = 1024,
    [string]$Model = 'BAAI/bge-m3',
    [int]$MaxLength = 512,
    [string]$RerankerModel = 'BAAI/bge-reranker-v2-m3',
    [int]$RerankerMaxLength = 512,
    [switch]$AllowModelDownload
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

function Resolve-PythonExe {
    param([string]$ProvidedPythonExe)

    $venvPython = Join-Path $projectRoot '.venv-ai\Scripts\python.exe'
    if (Test-Path $venvPython) {
        return $venvPython
    }

    if (-not [string]::IsNullOrWhiteSpace($ProvidedPythonExe)) {
        return $ProvidedPythonExe
    }

    throw "Missing .venv-ai Python environment. Run scripts\setup-bge-m3-ai-env.bat first, or create .venv-ai with Python 3.11."
}

function Test-HttpEndpoint {
    param([string]$Url)

    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 3
        return ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500)
    } catch {
        return $false
    }
}

function Test-LocalPortListening {
    param([int]$LocalPort)

    try {
        $connection = Get-NetTCPConnection -LocalPort $LocalPort -State Listen -ErrorAction SilentlyContinue |
            Select-Object -First 1
        return $null -ne $connection
    } catch {
        return $false
    }
}

function Ensure-Directory {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

$resolvedPython = Resolve-PythonExe -ProvidedPythonExe $PythonExe
$healthUrl = "http://$BindHost`:$Port/health"

if (Test-HttpEndpoint -Url $healthUrl) {
    Write-Host "[ReadSeek] AI service is already running: $healthUrl" -ForegroundColor Green
    exit 0
}

if (Test-LocalPortListening -LocalPort $Port) {
    Write-Host "[ReadSeek] Port $Port is already listening. AI service appears to be running." -ForegroundColor Green
    Write-Host "[ReadSeek] Health endpoint did not respond cleanly yet; wait a moment and retry /health if needed."
    exit 0
}

if ([string]::IsNullOrWhiteSpace($env:READSEEK_MODEL_HOME)) {
    $env:READSEEK_MODEL_HOME = 'E:\AIModels\readseek\huggingface'
}

$env:HF_HOME = $env:READSEEK_MODEL_HOME
$env:HF_HUB_CACHE = Join-Path $env:READSEEK_MODEL_HOME 'hub'
$env:HF_XET_CACHE = Join-Path $env:READSEEK_MODEL_HOME 'xet'
$env:HF_HUB_DOWNLOAD_TIMEOUT = '300'
$env:HF_HUB_ETAG_TIMEOUT = '60'
$env:HF_HUB_DISABLE_SYMLINKS_WARNING = '1'
$env:HF_HUB_DISABLE_XET = '1'
$env:HF_HUB_VERBOSITY = 'info'

if (Test-Path Env:TRANSFORMERS_CACHE) {
    Remove-Item Env:TRANSFORMERS_CACHE -ErrorAction SilentlyContinue
}

$downloadEnabledByEnv = $env:READSEEK_ALLOW_MODEL_DOWNLOAD -match '^(1|true|yes|on)$'
if ($AllowModelDownload -or $downloadEnabledByEnv) {
    Remove-Item Env:HF_HUB_OFFLINE -ErrorAction SilentlyContinue
    Remove-Item Env:TRANSFORMERS_OFFLINE -ErrorAction SilentlyContinue
    $modelLoadMode = 'online download/check enabled'
} else {
    $env:HF_HUB_OFFLINE = '1'
    $env:TRANSFORMERS_OFFLINE = '1'
    $modelLoadMode = 'offline cache first'
}

Ensure-Directory -Path $env:HF_HOME
Ensure-Directory -Path $env:HF_HUB_CACHE
Ensure-Directory -Path $env:HF_XET_CACHE

Write-Host "[ReadSeek] Model cache: $($env:HF_HOME)" -ForegroundColor Cyan
Write-Host "[ReadSeek] Hub cache: $($env:HF_HUB_CACHE)" -ForegroundColor Cyan
Write-Host "[ReadSeek] Model load mode: $modelLoadMode" -ForegroundColor Cyan
Write-Host "[ReadSeek] Starting BGE-M3 AI service on http://$BindHost`:$Port" -ForegroundColor Cyan
Write-Host "[ReadSeek] Embedding model: $Model"
Write-Host "[ReadSeek] Reranker model: $RerankerModel"
Write-Host "[ReadSeek] Python: $resolvedPython"
Write-Host ''

& $resolvedPython -u "$projectRoot\ai-service\server_bge_m3.py" `
    --host $BindHost `
    --port $Port `
    --model $Model `
    --dimensions $Dimensions `
    --max-length $MaxLength `
    --reranker-model $RerankerModel `
    --reranker-max-length $RerankerMaxLength
