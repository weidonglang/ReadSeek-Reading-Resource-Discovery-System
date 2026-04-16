[CmdletBinding()]
param(
    [string]$BaseUrl = 'http://localhost:8010/book-service',
    [string]$Email = 'admin@booknook.local',
    [string]$Password = 'Admin123!'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

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

Write-Host "Logging in as $Email ..." -ForegroundColor Cyan
$login = Invoke-JsonPost -Uri "$BaseUrl/api/auth/log-in" -Body @{
    email = $Email
    password = $Password
}

$token = $login.body.accessToken
if ([string]::IsNullOrWhiteSpace($token)) {
    throw 'Failed to obtain access token.'
}

Write-Host 'Rebuilding book search index ...' -ForegroundColor Cyan
$response = Invoke-RestMethod `
    -Method Post `
    -Uri "$BaseUrl/api/search/index/books/rebuild" `
    -Headers @{ Authorization = "Bearer $token" }

$response | ConvertTo-Json -Depth 6
