[CmdletBinding()]
param(
    [string]$SqlPath = 'scripts/generated/reset_from_json.sql',
    [switch]$RebuildIndex,
    [string]$BaseUrl = 'http://localhost:8010/readseek-service',
    [string]$AdminEmail = '',
    [string]$AdminPassword = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

function Import-DotEnv {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return
    }

    Get-Content $Path | ForEach-Object {
        $line = $_.Trim()
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) {
            return
        }
        $parts = $line -split '=', 2
        if ($parts.Count -ne 2) {
            return
        }
        $name = $parts[0].Trim()
        $value = $parts[1].Trim().Trim('"').Trim("'")
        if ($name -and -not [Environment]::GetEnvironmentVariable($name, 'Process')) {
            [Environment]::SetEnvironmentVariable($name, $value, 'Process')
        }
    }
}

Import-DotEnv -Path (Join-Path $projectRoot '.env')

$resolvedSql = Resolve-Path $SqlPath
$dbName = if ($env:POSTGRES_DB) { $env:POSTGRES_DB } else { 'book_recommendation_system' }
$dbUser = if ($env:POSTGRES_USER) { $env:POSTGRES_USER } else { 'postgres' }

Write-Host "[ReadSeek] Importing demo catalog from $resolvedSql" -ForegroundColor Cyan
Write-Host "[ReadSeek] Target container: readseek-db, database: $dbName, user: $dbUser" -ForegroundColor Cyan

$container = docker ps --filter "name=readseek-db" --filter "status=running" --format "{{.Names}}" | Select-Object -First 1
if ($container -ne 'readseek-db') {
    throw "Docker container readseek-db is not running. Start dependencies first with .\start-readseek.bat or docker compose up -d db."
}

Get-Content -Raw $resolvedSql | docker exec -i readseek-db psql -v ON_ERROR_STOP=1 -U $dbUser -d $dbName
if ($LASTEXITCODE -ne 0) {
    throw "Demo catalog import failed."
}

Write-Host "[ReadSeek] Demo catalog imported successfully." -ForegroundColor Green

if ($RebuildIndex) {
    if ([string]::IsNullOrWhiteSpace($AdminEmail)) {
        $AdminEmail = if ($env:LIBRARY_BOOTSTRAP_ADMIN_EMAIL) { $env:LIBRARY_BOOTSTRAP_ADMIN_EMAIL } else { 'admin@booknook.local' }
    }
    if ([string]::IsNullOrWhiteSpace($AdminPassword)) {
        $AdminPassword = $env:LIBRARY_BOOTSTRAP_ADMIN_PASSWORD
    }
    if ([string]::IsNullOrWhiteSpace($AdminPassword)) {
        throw "Admin password is required for -RebuildIndex. Set LIBRARY_BOOTSTRAP_ADMIN_PASSWORD in .env or pass -AdminPassword."
    }

    Write-Host "[ReadSeek] Rebuilding search index..." -ForegroundColor Cyan
    & "$PSScriptRoot\rebuild-search-index.ps1" -BaseUrl $BaseUrl -Email $AdminEmail -Password $AdminPassword
}

