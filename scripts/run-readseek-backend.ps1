[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$JavaHome,
    [string]$DbPassword = '',
    [switch]$WithAi,
    [int]$AiPort = 8001
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot
$envFilePath = Join-Path $projectRoot '.env'

function Import-DotEnvFile {
    if (-not (Test-Path $envFilePath)) {
        return
    }

    foreach ($line in Get-Content -Path $envFilePath -Encoding UTF8) {
        $trimmed = $line.Trim()
        if ([string]::IsNullOrWhiteSpace($trimmed) -or $trimmed.StartsWith('#')) {
            continue
        }
        $separatorIndex = $trimmed.IndexOf('=')
        if ($separatorIndex -le 0) {
            continue
        }
        $key = $trimmed.Substring(0, $separatorIndex).Trim()
        $value = $trimmed.Substring($separatorIndex + 1).Trim().Trim('"').Trim("'")
        if ([string]::IsNullOrWhiteSpace([Environment]::GetEnvironmentVariable($key, 'Process'))) {
            [Environment]::SetEnvironmentVariable($key, $value, 'Process')
        }
    }
}

function Resolve-Value {
    param(
        [string]$Current,
        [string]$Fallback
    )

    if (-not [string]::IsNullOrWhiteSpace($Current)) {
        return $Current
    }
    return $Fallback
}

if (-not (Test-Path $JavaHome)) {
    throw "JAVA_HOME not found: $JavaHome"
}

Import-DotEnvFile

$env:JAVA_HOME = $JavaHome
$env:Path = "$JavaHome\bin;$env:Path"

$resolvedDbPassword = if (-not [string]::IsNullOrWhiteSpace($DbPassword)) {
    $DbPassword
} elseif (-not [string]::IsNullOrWhiteSpace($env:SPRING_DATASOURCE_PASSWORD)) {
    $env:SPRING_DATASOURCE_PASSWORD
} elseif (-not [string]::IsNullOrWhiteSpace($env:POSTGRES_PASSWORD)) {
    $env:POSTGRES_PASSWORD
} else {
    'readseek-local-postgres-change-me'
}

$env:SPRING_DATASOURCE_URL = Resolve-Value -Current $env:SPRING_DATASOURCE_URL -Fallback 'jdbc:postgresql://localhost:5043/book_recommendation_system'
$env:SPRING_DATASOURCE_USERNAME = Resolve-Value -Current $env:SPRING_DATASOURCE_USERNAME -Fallback 'postgres'
$env:SPRING_DATASOURCE_PASSWORD = $resolvedDbPassword
$env:SPRING_ELASTICSEARCH_URIS = Resolve-Value -Current $env:SPRING_ELASTICSEARCH_URIS -Fallback 'http://localhost:9200'
$env:SPRING_JPA_SHOW_SQL = Resolve-Value -Current $env:SPRING_JPA_SHOW_SQL -Fallback 'false'
$env:SPRING_JPA_FORMAT_SQL = Resolve-Value -Current $env:SPRING_JPA_FORMAT_SQL -Fallback 'false'
$env:LIBRARY_SEARCH_ENABLED = Resolve-Value -Current $env:LIBRARY_SEARCH_ENABLED -Fallback 'true'
$env:MANAGEMENT_HEALTH_ELASTICSEARCH_ENABLED = Resolve-Value -Current $env:MANAGEMENT_HEALTH_ELASTICSEARCH_ENABLED -Fallback 'false'

if ($WithAi) {
    $env:LIBRARY_SEARCH_EMBEDDING_ENABLED = 'true'
    $env:LIBRARY_SEARCH_VECTOR_ENABLED = 'true'
    $env:LIBRARY_SEARCH_EMBEDDING_BASE_URL = "http://127.0.0.1:$AiPort"
}

Write-Host 'Starting ReadSeek Spring Boot backend...' -ForegroundColor Cyan
Write-Host "JAVA_HOME=$JavaHome"
Write-Host 'Database=localhost:5043/book_recommendation_system'
if ($WithAi) {
    Write-Host "AI service=http://127.0.0.1:$AiPort"
}

& "$projectRoot\mvnw.cmd" spring-boot:run

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nBackend exited with code $LASTEXITCODE." -ForegroundColor Red
    Read-Host 'Press Enter to close this window'
    exit $LASTEXITCODE
}
