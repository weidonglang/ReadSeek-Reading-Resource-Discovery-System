[CmdletBinding()]
param(
    [ValidateSet('all', 'deps', 'app')]
    [string]$Mode = 'all',
    [string]$JavaHome = 'C:\Program Files\Java\jdk-17.0.18+8',
    [string]$DbPassword = '',
    [switch]$WithAi,
    [string]$AiPythonExe = 'python',
    [int]$AiPort = 8001,
    [switch]$SkipWait
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

function Write-Step {
    param([string]$Message)
    Write-Host "`n== $Message ==" -ForegroundColor Cyan
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

    # Keep local development aligned with the user's current persisted database.
    return '20041117'
}

function Assert-CommandExists {
    param([string]$CommandName)

    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        throw "Missing required command: $CommandName"
    }
}

function Wait-ForDockerHealth {
    param(
        [string]$ContainerName,
        [int]$TimeoutSeconds = 120
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

function Wait-ForHttpEndpoint {
    param(
        [string]$Url,
        [int]$TimeoutSeconds = 60
    )

    $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
    while ((Get-Date) -lt $deadline) {
        try {
            $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 300) {
                Write-Host "$Url is ready"
                return
            }
        } catch {
        }
        Start-Sleep -Seconds 2
    }

    throw "Timed out waiting for endpoint $Url"
}

function Start-Dependencies {
    Write-Step 'Starting Docker dependencies'
    Assert-CommandExists 'docker'
    docker compose up -d db elasticsearch
    if (-not $SkipWait) {
        Write-Step 'Waiting for PostgreSQL and Elasticsearch'
        Wait-ForDockerHealth -ContainerName 'book-recommendation-db'
        Wait-ForDockerHealth -ContainerName 'book-recommendation-search'
    }
}

function Start-Application {
    param([string]$ResolvedDbPassword)

    Write-Step 'Preparing Java environment'
    if (-not (Test-Path $JavaHome)) {
        throw "JAVA_HOME not found: $JavaHome"
    }
    $env:JAVA_HOME = $JavaHome
    $env:Path = "$JavaHome\bin;$env:Path"

    $env:SPRING_DATASOURCE_URL = 'jdbc:postgresql://localhost:5043/book_recommendation_system'
    $env:SPRING_DATASOURCE_USERNAME = 'postgres'
    $env:SPRING_DATASOURCE_PASSWORD = $ResolvedDbPassword
    $env:SPRING_ELASTICSEARCH_URIS = 'http://localhost:9200'
    if ($WithAi) {
        $env:LIBRARY_SEARCH_EMBEDDING_ENABLED = 'true'
        $env:LIBRARY_SEARCH_VECTOR_ENABLED = 'true'
        $env:LIBRARY_SEARCH_EMBEDDING_BASE_URL = "http://127.0.0.1:$AiPort"
    }

    Write-Host "JAVA_HOME=$($env:JAVA_HOME)"
    Write-Host "SPRING_DATASOURCE_PASSWORD=<hidden>"
    if ($WithAi) {
        Write-Host "LIBRARY_SEARCH_EMBEDDING_BASE_URL=http://127.0.0.1:$AiPort"
    }

    Write-Step 'Starting Spring Boot application'
    & "$projectRoot\mvnw.cmd" spring-boot:run
}

function Start-AiService {
    Write-Step 'Starting local AI service'
    Start-Process powershell -ArgumentList @(
        '-NoLogo',
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-File', "$projectRoot\scripts\start-ai-service.ps1",
        '-PythonExe', $AiPythonExe,
        '-Port', "$AiPort"
    ) | Out-Null
    Write-Host "Book AI service started in a new PowerShell window on port $AiPort"
    if (-not $SkipWait) {
        Wait-ForHttpEndpoint -Url "http://127.0.0.1:$AiPort/health"
    }
}

$resolvedDbPassword = Resolve-DatabasePassword -ProvidedPassword $DbPassword

switch ($Mode) {
    'deps' {
        Start-Dependencies
    }
    'app' {
        if ($WithAi) {
            Start-AiService
        }
        Start-Application -ResolvedDbPassword $resolvedDbPassword
    }
    'all' {
        Start-Dependencies
        if ($WithAi) {
            Start-AiService
        }
        Start-Application -ResolvedDbPassword $resolvedDbPassword
    }
}
