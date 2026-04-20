[CmdletBinding()]
param(
    [string]$JavaHome = '',
    [string]$DbPassword = '',
    [string]$AiPythonExe = 'python',
    [int]$AiPort = 8001,
    [ValidateSet('login', 'home', 'search', 'swagger')]
    [string]$StartPage = 'login',
    [switch]$NoAi,
    [switch]$NoBrowser,
    [switch]$SkipWait
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$backendProbeUrl = 'http://localhost:8010/readseek-service/swagger-ui/index.html'
$aiHealthUrl = "http://127.0.0.1:$AiPort/health"

function Resolve-StartUrl {
    param([string]$Page)

    switch ($Page) {
        'home' { return 'http://localhost:8010/readseek-service/ui/index.html' }
        'search' { return 'http://localhost:8010/readseek-service/ui/books.html' }
        'swagger' { return 'http://localhost:8010/readseek-service/swagger-ui/index.html' }
        default { return 'http://localhost:8010/readseek-service/ui/login.html' }
    }
}

$appUrl = Resolve-StartUrl -Page $StartPage

function Write-Step {
    param([string]$Message)
    Write-Host "`n== $Message ==" -ForegroundColor Cyan
}

function Assert-CommandExists {
    param([string]$CommandName)

    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        throw "Missing required command: $CommandName"
    }
}

function Resolve-ReadSeekJavaHome {
    param([string]$ProvidedJavaHome)

    $candidates = @(
        $ProvidedJavaHome,
        $env:JAVA_HOME,
        "$env:USERPROFILE\.jdks\ms-17.0.18",
        'C:\Program Files\Java\jdk-17.0.18+8'
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    foreach ($candidate in $candidates) {
        if ((Test-Path $candidate) -and (Test-Path (Join-Path $candidate 'bin\java.exe'))) {
            return $candidate
        }
    }

    $jdkRoot = Join-Path $env:USERPROFILE '.jdks'
    if (Test-Path $jdkRoot) {
        $detected = Get-ChildItem -Path $jdkRoot -Directory -ErrorAction SilentlyContinue |
            Where-Object { Test-Path (Join-Path $_.FullName 'bin\java.exe') } |
            Sort-Object Name -Descending |
            Select-Object -First 1
        if ($detected) {
            return $detected.FullName
        }
    }

    throw 'Could not find JDK 17. Pass -JavaHome "C:\path\to\jdk17" or fix JAVA_HOME.'
}

function Resolve-DatabasePassword {
    param([string]$ProvidedPassword)

    if (-not [string]::IsNullOrWhiteSpace($ProvidedPassword)) {
        return $ProvidedPassword
    }
    if (-not [string]::IsNullOrWhiteSpace($env:BOOK_DB_PASSWORD)) {
        return $env:BOOK_DB_PASSWORD
    }
    if (-not [string]::IsNullOrWhiteSpace($env:SPRING_DATASOURCE_PASSWORD)) {
        return $env:SPRING_DATASOURCE_PASSWORD
    }

    return '20041117'
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

function Wait-ForHttpEndpoint {
    param(
        [string]$Url,
        [int]$TimeoutSeconds = 180
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        if (Test-HttpEndpoint -Url $Url) {
            Write-Host "$Url is ready"
            return
        }
        Start-Sleep -Seconds 2
    }

    throw "Timed out waiting for endpoint $Url"
}

function Wait-ForDockerHealth {
    param(
        [string]$ContainerName,
        [int]$TimeoutSeconds = 180
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        $status = docker inspect --format "{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}" $ContainerName 2>$null
        $normalized = ($status | Out-String).Trim()
        if ($normalized -eq 'healthy' -or $normalized -eq 'running') {
            Write-Host "$ContainerName is $normalized"
            return
        }
        Start-Sleep -Seconds 2
    }

    throw "Timed out waiting for container $ContainerName to become healthy."
}

function Remove-StaleSearchContainer {
    $containerId = (docker ps -a --filter 'name=^/readseek-search$' --format '{{.ID}}' 2>$null | Select-Object -First 1)
    if ([string]::IsNullOrWhiteSpace($containerId)) {
        return
    }

    $state = (docker inspect --format '{{.State.Status}}' readseek-search 2>$null | Out-String).Trim()
    if ($state -eq 'running') {
        return
    }

    Write-Host "Removing stale Elasticsearch container readseek-search ($state)."
    docker rm readseek-search | Out-Null
}

function Ensure-DatabaseContainer {
    $containerId = (docker ps -a --filter 'name=^/readseek-db$' --format '{{.ID}}' 2>$null | Select-Object -First 1)
    if ([string]::IsNullOrWhiteSpace($containerId)) {
        return $false
    }

    $state = (docker inspect --format '{{.State.Status}}' readseek-db 2>$null | Out-String).Trim()
    if ($state -eq 'running') {
        Write-Host 'Reusing running PostgreSQL container readseek-db.'
        return $true
    }

    Write-Host "Starting existing PostgreSQL container readseek-db ($state)."
    docker start readseek-db | Out-Null
    return $true
}

function Start-DockerDependencies {
    Write-Step 'Starting Docker dependencies'
    Assert-CommandExists 'docker'
    $hasDatabaseContainer = Ensure-DatabaseContainer
    Remove-StaleSearchContainer
    if ($hasDatabaseContainer) {
        docker compose up -d elasticsearch
    } else {
        docker compose up -d db elasticsearch
    }
    if (-not $SkipWait) {
        Write-Step 'Waiting for PostgreSQL and Elasticsearch'
        Wait-ForDockerHealth -ContainerName 'readseek-db'
        Wait-ForDockerHealth -ContainerName 'readseek-search'
    }
}

function Apply-LocalSchemaPatches {
    Write-Step 'Applying database schema patches'
    powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "$projectRoot\scripts\apply-local-schema-patches.ps1"
}

function Start-ReadSeekAiService {
    if (Test-HttpEndpoint -Url $aiHealthUrl) {
        Write-Host "AI service is already running: $aiHealthUrl"
        return
    }

    Write-Step 'Starting AI service'
    Start-Process powershell -ArgumentList @(
        '-NoLogo',
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-File', "$projectRoot\scripts\start-ai-service.ps1",
        '-PythonExe', $AiPythonExe,
        '-Port', "$AiPort"
    ) | Out-Null

    if (-not $SkipWait) {
        Wait-ForHttpEndpoint -Url $aiHealthUrl -TimeoutSeconds 60
    }
}

function Start-ReadSeekBackend {
    param(
        [string]$ResolvedJavaHome,
        [string]$ResolvedDbPassword
    )

    if (Test-HttpEndpoint -Url $backendProbeUrl) {
        Write-Host "Backend is already running: $backendProbeUrl"
        return
    }

    Write-Step 'Starting backend'
    $arguments = @(
        '-NoLogo',
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-File', "$projectRoot\scripts\run-readseek-backend.ps1",
        '-JavaHome', $ResolvedJavaHome,
        '-DbPassword', $ResolvedDbPassword,
        '-AiPort', "$AiPort"
    )
    if (-not $NoAi) {
        $arguments += '-WithAi'
    }

    Start-Process powershell -ArgumentList $arguments | Out-Null

    if (-not $SkipWait) {
        Wait-ForHttpEndpoint -Url $backendProbeUrl -TimeoutSeconds 180
    }
}

$resolvedJavaHome = Resolve-ReadSeekJavaHome -ProvidedJavaHome $JavaHome
$resolvedDbPassword = Resolve-DatabasePassword -ProvidedPassword $DbPassword

Write-Host 'ReadSeek one-click startup' -ForegroundColor Green
Write-Host "Project: $projectRoot"
Write-Host "JAVA_HOME: $resolvedJavaHome"
Write-Host 'Database password: <hidden>'

Start-DockerDependencies
Apply-LocalSchemaPatches

if (-not $NoAi) {
    Start-ReadSeekAiService
}

Start-ReadSeekBackend -ResolvedJavaHome $resolvedJavaHome -ResolvedDbPassword $resolvedDbPassword

if (-not $NoBrowser) {
    Write-Step 'Opening browser'
    Start-Process $appUrl
}

Write-Host "`nStartup completed." -ForegroundColor Green
Write-Host "UI: $appUrl"
Write-Host "Swagger: $backendProbeUrl"
