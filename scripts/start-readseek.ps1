[CmdletBinding()]
param(
    [string]$JavaHome = '',
    [string]$DbPassword = '',
    [string]$AiPythonExe = 'python',
    [int]$AiPort = 8001,
    [int]$VuePort = 5173,
    [ValidateSet('vue', 'login', 'home', 'search', 'swagger')]
    [string]$StartPage = 'vue',
    [switch]$NoAi,
    [switch]$NoVue,
    [switch]$NoBrowser,
    [switch]$SkipWait,
    [switch]$StrictStartup
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$backendProbeUrl = 'http://localhost:8010/readseek-service/actuator/health'
$backendSwaggerUrl = 'http://localhost:8010/readseek-service/swagger-ui/index.html'
$aiHealthUrl = "http://127.0.0.1:$AiPort/health"
$envFilePath = Join-Path $projectRoot '.env'
$envExamplePath = Join-Path $projectRoot '.env.example'

function Get-ExistingContainerEnvValue {
    param(
        [string]$ContainerName,
        [string]$Key
    )

    if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
        return ''
    }

    try {
        $lines = docker inspect --format '{{range .Config.Env}}{{println .}}{{end}}' $ContainerName 2>$null
        foreach ($line in $lines) {
            if ($line -like "$Key=*") {
                return $line.Substring($Key.Length + 1)
            }
        }
    } catch {
        return ''
    }

    return ''
}

function Set-DotEnvValue {
    param(
        [string]$Path,
        [string]$Key,
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return
    }

    $lines = @(Get-Content -Path $Path -Encoding UTF8)
    $found = $false
    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -match "^$([regex]::Escape($Key))=") {
            $lines[$i] = "$Key=$Value"
            $found = $true
        }
    }
    if (-not $found) {
        $lines += "$Key=$Value"
    }
    Set-Content -Path $Path -Value $lines -Encoding UTF8
}

function Initialize-LocalEnvFile {
    if (Test-Path $envFilePath) {
        return
    }
    if (-not (Test-Path $envExamplePath)) {
        throw "Missing .env.example at $envExamplePath"
    }

    Copy-Item -Path $envExamplePath -Destination $envFilePath
    $existingDbPassword = Get-ExistingContainerEnvValue -ContainerName 'readseek-db' -Key 'POSTGRES_PASSWORD'
    if (-not [string]::IsNullOrWhiteSpace($existingDbPassword)) {
        Set-DotEnvValue -Path $envFilePath -Key 'POSTGRES_PASSWORD' -Value $existingDbPassword
        Set-DotEnvValue -Path $envFilePath -Key 'SPRING_DATASOURCE_PASSWORD' -Value $existingDbPassword
        Write-Host 'Created .env from .env.example and reused the password from the existing readseek-db container.'
    } else {
        Write-Host 'Created .env from .env.example. Review local passwords before sharing this machine.'
    }
}

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

function Resolve-StartUrl {
    param([string]$Page)

    switch ($Page) {
        'vue' { return "http://127.0.0.1:$VuePort" }
        'home' { return 'http://localhost:8010/readseek-service/ui/index.html' }
        'search' { return 'http://localhost:8010/readseek-service/ui/books.html' }
        'swagger' { return 'http://localhost:8010/readseek-service/swagger-ui/index.html' }
        default { return 'http://localhost:8010/readseek-service/ui/login.html' }
    }
}

$appUrl = Resolve-StartUrl -Page $StartPage
$vueUrl = "http://127.0.0.1:$VuePort"

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

function ConvertTo-PowerShellSingleQuotedLiteral {
    param([string]$Value)

    if ($null -eq $Value) {
        return "''"
    }

    return "'" + $Value.Replace("'", "''") + "'"
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
    if (-not [string]::IsNullOrWhiteSpace($env:POSTGRES_PASSWORD)) {
        return $env:POSTGRES_PASSWORD
    }

    return 'readseek-local-postgres-change-me'
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

function Start-DockerDependencies {
    Write-Step 'Starting Docker dependencies'
    Assert-CommandExists 'docker'
    Remove-StaleSearchContainer
    docker compose up -d db elasticsearch redis
    if (-not $SkipWait) {
        Write-Step 'Waiting for PostgreSQL, Elasticsearch, and Redis'
        Wait-ForDockerHealth -ContainerName 'readseek-db'
        Wait-ForDockerHealth -ContainerName 'readseek-search'
        Wait-ForDockerHealth -ContainerName 'readseek-redis'
    }
}

function Start-ReadSeekAiService {
    if (Test-HttpEndpoint -Url $aiHealthUrl) {
        Write-Host "AI service is already running: $aiHealthUrl"
        return
    }

    Write-Step 'Starting AI service'
    $aiCommand = "& $(ConvertTo-PowerShellSingleQuotedLiteral "$projectRoot\scripts\start-ai-service.ps1") " +
        "-PythonExe $(ConvertTo-PowerShellSingleQuotedLiteral $AiPythonExe) " +
        "-Port $AiPort"
    Start-Process powershell -ArgumentList @(
        '-NoLogo',
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-NoExit',
        '-Command', $aiCommand
    ) | Out-Null

    if (-not $SkipWait) {
        Wait-ForHttpEndpoint -Url $aiHealthUrl -TimeoutSeconds 300
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
    $backendCommand = "& $(ConvertTo-PowerShellSingleQuotedLiteral "$projectRoot\scripts\run-readseek-backend.ps1") " +
        "-JavaHome $(ConvertTo-PowerShellSingleQuotedLiteral $ResolvedJavaHome) " +
        "-DbPassword $(ConvertTo-PowerShellSingleQuotedLiteral $ResolvedDbPassword) " +
        "-AiPort $AiPort"
    if (-not $NoAi) {
        $backendCommand += ' -WithAi'
    }

    Start-Process powershell -ArgumentList @(
        '-NoLogo',
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-NoExit',
        '-Command', $backendCommand
    ) | Out-Null

    if (-not $SkipWait) {
        Wait-ForHttpEndpoint -Url $backendProbeUrl -TimeoutSeconds 180
    }
}

function Start-ReadSeekVueFrontend {
    $frontendDir = Join-Path $projectRoot 'frontend'

    if (-not (Test-Path $frontendDir)) {
        throw "Missing Vue frontend directory: $frontendDir"
    }

    if (Test-HttpEndpoint -Url $vueUrl) {
        Write-Host "Vue frontend is already running: $vueUrl"
        return
    }

    Write-Step 'Starting Vue frontend'
    Assert-CommandExists 'npm'

    $nodeModulesDir = Join-Path $frontendDir 'node_modules'
    if (-not (Test-Path $nodeModulesDir)) {
        Write-Host 'Vue dependencies are missing. Running npm install...'
        Push-Location $frontendDir
        try {
            npm install
        } finally {
            Pop-Location
        }
    }

    Start-Process powershell -WorkingDirectory $frontendDir -ArgumentList @(
        '-NoLogo',
        '-NoProfile',
        '-ExecutionPolicy', 'Bypass',
        '-NoExit',
        '-Command', "npm run dev -- --host 127.0.0.1 --port $VuePort"
    ) | Out-Null

    if (-not $SkipWait) {
        Wait-ForHttpEndpoint -Url $vueUrl -TimeoutSeconds 60
    }
}

Initialize-LocalEnvFile
Import-DotEnvFile

$resolvedJavaHome = Resolve-ReadSeekJavaHome -ProvidedJavaHome $JavaHome
$resolvedDbPassword = Resolve-DatabasePassword -ProvidedPassword $DbPassword

Write-Host 'ReadSeek one-click startup' -ForegroundColor Green
Write-Host "Project: $projectRoot"
Write-Host "JAVA_HOME: $resolvedJavaHome"
Write-Host 'Database password: <hidden>'

Start-DockerDependencies

$aiReady = $NoAi
if (-not $NoAi) {
    try {
        Start-ReadSeekAiService
        $aiReady = $true
    } catch {
        Write-Warning "AI service did not become ready: $($_.Exception.Message)"
        if ($StrictStartup) {
            throw
        }
    }
}

$backendReady = $false
try {
    Start-ReadSeekBackend -ResolvedJavaHome $resolvedJavaHome -ResolvedDbPassword $resolvedDbPassword
    $backendReady = $true
} catch {
    Write-Warning "Backend did not become ready: $($_.Exception.Message)"
    Write-Warning 'The backend PowerShell window was left open. Check it for the real Spring Boot error.'
    if ($StrictStartup) {
        throw
    }
}

$vueReady = $NoVue
if (-not $NoVue) {
    try {
        Start-ReadSeekVueFrontend
        $vueReady = $true
    } catch {
        Write-Warning "Vue frontend did not become ready: $($_.Exception.Message)"
        if ($StrictStartup) {
            throw
        }
    }
}

if (-not $NoBrowser) {
    Write-Step 'Opening browser'
    Start-Process $appUrl
    if (-not $NoVue -and $appUrl -ne $vueUrl) {
        Start-Process $vueUrl
    }
}

Write-Host "`nStartup completed." -ForegroundColor Green
Write-Host "UI: $appUrl"
Write-Host "Backend health: $backendProbeUrl"
Write-Host "Swagger: $backendSwaggerUrl"
if (-not $NoVue) {
    Write-Host "Vue: $vueUrl"
}
if (-not $aiReady) {
    Write-Host "AI status: not ready. Check the AI PowerShell window." -ForegroundColor Yellow
}
if (-not $backendReady) {
    Write-Host "Backend status: not ready. Vue can open, but API calls will fail until 8010 is healthy." -ForegroundColor Yellow
}
if (-not $vueReady) {
    Write-Host "Vue status: not ready. Check whether npm is installed and port $VuePort is free." -ForegroundColor Yellow
}
