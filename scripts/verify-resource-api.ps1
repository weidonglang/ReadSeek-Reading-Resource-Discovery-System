[CmdletBinding()]
param(
    [string]$BaseUrl = 'http://localhost:8010/readseek-service',
    [string]$Query = 'Pride and Prejudice',
    [int]$Limit = 8,
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

$headers = @{ Authorization = "Bearer $token" }
$encodedQuery = [System.Uri]::EscapeDataString($Query)
$search = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/search/resources?q=$encodedQuery&limit=$Limit" -Headers $headers
$categories = Invoke-RestMethod -Method Get -Uri "$BaseUrl/api/resources/categories" -Headers $headers

[pscustomobject]@{
    resourceSearchStatus = $search.success
    query = $search.body.query
    strategy = $search.body.strategy
    returnedCount = $search.body.returnedCount
    firstHit = if ($search.body.hits.Count -gt 0) { $search.body.hits[0].book.name } else { $null }
    categoryStatus = $categories.success
    categoryCount = if ($categories.body -is [array]) { $categories.body.Count } else { 0 }
} | ConvertTo-Json -Depth 6
