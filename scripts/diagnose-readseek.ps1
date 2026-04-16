[CmdletBinding()]
param(
    [string]$BaseUrl = 'http://localhost:8010/readseek-service',
    [string]$Email = 'admin@booknook.local',
    [string]$Password = 'Admin123!'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Test-HttpEndpoint {
    param([string]$Url)

    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 5
        return [pscustomobject]@{
            ok = $true
            statusCode = [int]$response.StatusCode
            content = [string]$response.Content
            error = $null
        }
    } catch {
        return [pscustomobject]@{
            ok = $false
            statusCode = $null
            content = ''
            error = $_.Exception.Message
        }
    }
}

function Get-DockerContainerStatus {
    param([string]$Name)

    try {
        $status = docker inspect --format "{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}" $Name 2>$null
        $normalized = ($status | Out-String).Trim()
        if ([string]::IsNullOrWhiteSpace($normalized)) {
            return 'not-found'
        }
        return $normalized
    } catch {
        return 'not-found'
    }
}

function Invoke-JsonPost {
    param(
        [string]$Uri,
        [hashtable]$Body,
        [hashtable]$Headers = @{}
    )

    return Invoke-RestMethod `
        -Method Post `
        -Uri $Uri `
        -ContentType 'application/json' `
        -Headers $Headers `
        -Body ($Body | ConvertTo-Json)
}

$swagger = Test-HttpEndpoint -Url "$BaseUrl/swagger-ui/index.html"
$loginPage = Test-HttpEndpoint -Url "$BaseUrl/ui/login.html"
$configJs = Test-HttpEndpoint -Url "$BaseUrl/ui/assets/js/config.js"

$loginResult = [pscustomobject]@{
    ok = $false
    statusCode = $null
    hasAccessToken = $false
    currentUserOk = $false
    currentUserEmail = $null
    error = $null
}

try {
    $login = Invoke-JsonPost -Uri "$BaseUrl/api/auth/log-in" -Body @{
        email = $Email
        password = $Password
    }
    $token = $login.body.accessToken
    $loginResult.ok = [bool]$login.success
    $loginResult.hasAccessToken = -not [string]::IsNullOrWhiteSpace($token)

    if ($loginResult.hasAccessToken) {
        $current = Invoke-RestMethod `
            -Method Get `
            -Uri "$BaseUrl/api/auth/current" `
            -Headers @{ Authorization = "Bearer $token" }
        $loginResult.currentUserOk = [bool]$current.success
        $loginResult.currentUserEmail = $current.body.email
    }
} catch {
    $errorDetails = $_.ErrorDetails
    $loginResult.error = if ($errorDetails -and $errorDetails.Message) { $errorDetails.Message } else { $_.Exception.Message }
    try {
        $loginResult.statusCode = [int]$_.Exception.Response.StatusCode
    } catch {
        $loginResult.statusCode = $null
    }
}

$loginPageHasForm = $loginPage.content.Contains('id="login-form"')
$loginPageHasReadSeek = $loginPage.content.Contains('ReadSeek')
$loginPageHasEndTag = $loginPage.content.Contains('</html>')
$loginPageLooksBroken = $loginPage.ok -and (-not $loginPageHasForm -or -not $loginPageHasEndTag)

[pscustomobject]@{
    baseUrl = $BaseUrl
    docker = [pscustomobject]@{
        postgres = Get-DockerContainerStatus -Name 'readseek-db'
        elasticsearch = Get-DockerContainerStatus -Name 'readseek-search'
    }
    backend = [pscustomobject]@{
        swaggerOk = $swagger.ok
        swaggerStatusCode = $swagger.statusCode
        swaggerError = $swagger.error
    }
    frontend = [pscustomobject]@{
        loginPageOk = $loginPage.ok
        loginPageHasForm = $loginPageHasForm
        loginPageHasReadSeek = $loginPageHasReadSeek
        loginPageLooksBroken = $loginPageLooksBroken
        configOk = $configJs.ok
        configUsesCurrentBackend = $configJs.content.Contains('currentBackendBase')
    }
    auth = $loginResult
    hints = @(
        'If backend.swaggerOk is false, restart backend or run .\start-readseek.bat.',
        'If frontend.loginPageLooksBroken is true, run mvn process-resources or restart backend and hard-refresh browser.',
        'If auth.ok is false, verify the login password. Database password is not the login password.',
        'If browser still fails while this script is green, clear site data/localStorage and press Ctrl+F5.'
    )
} | ConvertTo-Json -Depth 8
