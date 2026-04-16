[CmdletBinding()]
param(
    [string]$PythonExe = 'python',
    [string]$BindHost = '127.0.0.1',
    [int]$Port = 8001,
    [int]$Dimensions = 384,
    [string]$Model = 'hash-bow-384'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$env:BOOK_AI_HOST = $BindHost
$env:BOOK_AI_PORT = [string]$Port
$env:BOOK_AI_EMBED_DIMENSIONS = [string]$Dimensions
$env:BOOK_AI_MODEL = $Model

Write-Host "Starting Book AI service on http://$BindHost`:$Port (model=$Model, dimensions=$Dimensions)" -ForegroundColor Cyan
& $PythonExe "$projectRoot\ai-service\server.py"
