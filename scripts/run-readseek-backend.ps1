[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$JavaHome,
    [string]$DbPassword = '20041117',
    [switch]$WithAi,
    [int]$AiPort = 8001
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

if (-not (Test-Path $JavaHome)) {
    throw "JAVA_HOME not found: $JavaHome"
}

$env:JAVA_HOME = $JavaHome
$env:Path = "$JavaHome\bin;$env:Path"

$env:SPRING_DATASOURCE_URL = 'jdbc:postgresql://localhost:5043/book_recommendation_system'
$env:SPRING_DATASOURCE_USERNAME = 'postgres'
$env:SPRING_DATASOURCE_PASSWORD = $DbPassword
$env:SPRING_ELASTICSEARCH_URIS = 'http://localhost:9200'
$env:SPRING_JPA_SHOW_SQL = 'false'
$env:SPRING_JPA_FORMAT_SQL = 'false'
$env:LIBRARY_SEARCH_ENABLED = 'true'
$env:MANAGEMENT_HEALTH_ELASTICSEARCH_ENABLED = 'false'

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
