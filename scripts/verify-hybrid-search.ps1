[CmdletBinding()]
param(
    [string]$BaseUrl = 'http://localhost:8010/book-service',
    [string]$Query = 'classic romance'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$encodedQuery = [System.Uri]::EscapeDataString($Query)
$response = Invoke-RestMethod -Uri "$BaseUrl/api/search/books?q=$encodedQuery&limit=8"
$body = $response.body

[PSCustomObject]@{
    query = $body.query
    intent = $body.queryIntent
    strategy = $body.strategy
    fallbackApplied = $body.fallbackApplied
    returnedCount = $body.returnedCount
    firstHit = if ($body.hits -and $body.hits.Count -gt 0) { $body.hits[0].book.name } else { $null }
    firstMatchType = if ($body.hits -and $body.hits.Count -gt 0) { $body.hits[0].matchType } else { $null }
} | ConvertTo-Json -Depth 6
