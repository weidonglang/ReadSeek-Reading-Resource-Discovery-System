[CmdletBinding()]
param(
    [ValidateSet('Process', 'User', 'Machine')]
    [string]$Scope = '',
    [string[]]$SearchRoots = @(),
    [switch]$NonInteractive,
    [int]$Selection = 0
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Title {
    param([string]$Text)
    Write-Host "`n========== $Text ==========" -ForegroundColor Cyan
}

function Normalize-Path {
    param([string]$Path)
    if ([string]::IsNullOrWhiteSpace($Path)) { return $null }
    try {
        return [System.IO.Path]::GetFullPath($Path.Trim())
    } catch {
        return $null
    }
}

function Get-InferredVersionFromName {
    param([string]$Name)
    if ([string]::IsNullOrWhiteSpace($Name)) { return 'Unknown' }
    $patterns = @(
        '([0-9]+\.[0-9]+\.[0-9]+(?:_[0-9]+)?)',
        '([0-9]+\.[0-9]+(?:_[0-9]+)?)',
        '([0-9]+(?:\.[0-9]+)?)'
    )
    foreach ($p in $patterns) {
        $m = [regex]::Match($Name, $p)
        if ($m.Success) { return $m.Groups[1].Value }
    }
    return 'Unknown'
}

function Read-ReleaseFile {
    param([string]$JavaHome)
    $releaseFile = Join-Path $JavaHome 'release'
    $map = @{}
    if (-not (Test-Path $releaseFile)) { return $map }
    foreach ($line in Get-Content -Path $releaseFile -ErrorAction SilentlyContinue) {
        if ($line -match '^([A-Z0-9_]+)=(.*)$') {
            $key = $Matches[1]
            $value = $Matches[2].Trim('"')
            $map[$key] = $value
        }
    }
    return $map
}

function Get-JavaCandidate {
    param([string]$Folder)

    $full = Normalize-Path $Folder
    if (-not $full) { return $null }
    if (-not (Test-Path $full -PathType Container)) { return $null }

    $javaExe = Join-Path $full 'bin\java.exe'
    if (-not (Test-Path $javaExe)) { return $null }

    $javacExe = Join-Path $full 'bin\javac.exe'
    $type = if (Test-Path $javacExe) { 'JDK' } else { 'JRE' }
    $dir = Get-Item -LiteralPath $full
    $release = Read-ReleaseFile -JavaHome $full

    $version = if ($release.ContainsKey('JAVA_VERSION')) {
        $release['JAVA_VERSION']
    } else {
        Get-InferredVersionFromName -Name $dir.Name
    }

    $vendor = if ($release.ContainsKey('IMPLEMENTOR')) { $release['IMPLEMENTOR'] } elseif ($release.ContainsKey('IMPLEMENTOR_VERSION')) { $release['IMPLEMENTOR_VERSION'] } else { '' }
    $runtime = if ($release.ContainsKey('JAVA_RUNTIME_VERSION')) { $release['JAVA_RUNTIME_VERSION'] } else { $version }

    [PSCustomObject]@{
        Name     = $dir.Name
        Type     = $type
        Version  = $version
        Runtime  = $runtime
        Vendor   = $vendor
        Home     = $full
        Bin      = (Join-Path $full 'bin')
        JavaExe  = $javaExe
        JavacExe = $javacExe
    }
}

function Test-IsJavaBinPath {
    param([string]$PathEntry)
    if ([string]::IsNullOrWhiteSpace($PathEntry)) { return $false }

    $trimmed = $PathEntry.Trim()
    if ($trimmed -match '^(?i)%JAVA_HOME%\\bin$') { return $true }
    if ($trimmed -match '^(?i)%JRE_HOME%\\bin$') { return $true }
    if ($trimmed -match '^(?i)\$env:JAVA_HOME\\bin$') { return $true }
    if ($trimmed -match '^(?i)\$env:JRE_HOME\\bin$') { return $true }

    $expanded = [Environment]::ExpandEnvironmentVariables($trimmed)
    $expanded = Normalize-Path $expanded
    if (-not $expanded) { return $false }
    if (-not $expanded.ToLower().EndsWith('\bin')) { return $false }

    $javaExe = Join-Path $expanded 'java.exe'
    $javacExe = Join-Path $expanded 'javac.exe'
    if ((Test-Path $javaExe) -or (Test-Path $javacExe)) { return $true }

    $parent = Split-Path -Parent $expanded
    if ($parent) {
        $leaf = Split-Path -Leaf $parent
        if ($leaf -match '^(?i)(jdk|jre|java)') { return $true }
        if (Test-Path (Join-Path $parent 'release')) { return $true }
    }
    return $false
}

function Remove-OldJavaPathEntries {
    param([string]$PathValue)
    if ([string]::IsNullOrWhiteSpace($PathValue)) { return '' }

    $items = $PathValue -split ';'
    $kept = New-Object System.Collections.Generic.List[string]
    foreach ($item in $items) {
        if ([string]::IsNullOrWhiteSpace($item)) { continue }
        if (-not (Test-IsJavaBinPath -PathEntry $item)) {
            $kept.Add($item.Trim())
        }
    }
    return ($kept -join ';')
}

function Get-ScopeInteractive {
    while ($true) {
        Write-Host ''
        Write-Host '选择环境变量生效范围：'
        Write-Host '  1) 仅当前窗口（Process）'
        Write-Host '  2) 当前用户（User，默认）'
        Write-Host '  3) 整台机器（Machine，需要管理员）'
        $raw = Read-Host '请输入 1 / 2 / 3，直接回车默认 2'
        switch ($raw) {
            '' { return 'User' }
            '1' { return 'Process' }
            '2' { return 'User' }
            '3' { return 'Machine' }
            default { Write-Host '输入无效，请重新选择。' -ForegroundColor Yellow }
        }
    }
}

function Get-SelectionInteractive {
    param([object[]]$Candidates)
    while ($true) {
        $raw = Read-Host '请输入要切换的编号（输入 q 退出）'
        if ($raw -match '^(?i)q$') { return 0 }
        $num = 0
        if ([int]::TryParse($raw, [ref]$num)) {
            if ($num -ge 1 -and $num -le $Candidates.Count) { return $num }
        }
        Write-Host '编号无效，请重新输入。' -ForegroundColor Yellow
    }
}

function Set-EnvVarSafe {
    param(
        [string]$Name,
        [AllowNull()][string]$Value,
        [ValidateSet('Process', 'User', 'Machine')][string]$ScopeName
    )

    if ($ScopeName -eq 'Process') {
        if ($null -eq $Value) {
            Remove-Item -Path "Env:$Name" -ErrorAction SilentlyContinue
        } else {
            Set-Item -Path "Env:$Name" -Value $Value
        }
        return
    }

    [Environment]::SetEnvironmentVariable($Name, $Value, $ScopeName)
    if ($null -eq $Value) {
        Remove-Item -Path "Env:$Name" -ErrorAction SilentlyContinue
    } else {
        Set-Item -Path "Env:$Name" -Value $Value
    }
}

function Collect-SearchRoots {
    param([string[]]$InputRoots)

    $roots = New-Object System.Collections.Generic.List[string]

    if ($PSScriptRoot) { $roots.Add($PSScriptRoot) }
    $cwd = (Get-Location).Path
    if ($cwd) { $roots.Add($cwd) }

    foreach ($r in $InputRoots) {
        if (-not [string]::IsNullOrWhiteSpace($r)) {
            $roots.Add($r)
        }
    }

    $common = @(
        "$env:ProgramFiles\Java",
        "$env:ProgramFiles\Eclipse Adoptium",
        "$env:ProgramFiles\AdoptOpenJDK",
        "$env:ProgramFiles\Zulu",
        "$env:ProgramFiles\Amazon Corretto",
        "$env:SystemDrive\Java",
        "$env:SystemDrive\dev",
        "$env:SystemDrive\sdk",
        "$env:SystemDrive\tools"
    )

    if (${env:ProgramFiles(x86)}) {
        $common += "${env:ProgramFiles(x86)}\Java"
    }

    if ($env:JAVA_HOME) {
        $common += $env:JAVA_HOME
        $javaHomeParent = Split-Path -Parent $env:JAVA_HOME
        if ($javaHomeParent) { $common += $javaHomeParent }
    }

    foreach ($r in $common) {
        if (-not [string]::IsNullOrWhiteSpace($r)) {
            $roots.Add($r)
        }
    }

    try {
        Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
            if ($_.DeviceID) {
                $roots.Add(($_.DeviceID + '\'))
            }
        }
    }
    catch {
        Get-PSDrive -PSProvider FileSystem | ForEach-Object {
            if ($_.Root) {
                $roots.Add($_.Root)
            }
        }
    }

    $normalized = $roots |
        ForEach-Object { Normalize-Path $_ } |
        Where-Object { $_ -and (Test-Path $_ -PathType Container) } |
        Select-Object -Unique

    return ,$normalized
}

function Find-JavaCandidates {
    param([string[]]$Roots)

    $found = New-Object System.Collections.Generic.List[object]
    $seen = New-Object 'System.Collections.Generic.HashSet[string]'

    $containerPattern = '^(?i)(java|jdk|jre|dev|sdk|tools|apps|software|programs?|runtime|env)$'

    foreach ($root in $Roots) {
        $rootNorm = Normalize-Path $root
        if (-not $rootNorm) { continue }
        if (-not (Test-Path $rootNorm -PathType Container)) { continue }

        $toCheck = New-Object System.Collections.Generic.List[string]
        $toCheck.Add($rootNorm)

        $level1 = @(Get-ChildItem -LiteralPath $rootNorm -Directory -ErrorAction SilentlyContinue)

        foreach ($d in $level1) {
            $toCheck.Add($d.FullName)
        }

        $isDriveRoot = $rootNorm -match '^[A-Za-z]:\\$'

        foreach ($d in $level1) {
            if ($isDriveRoot -or $d.Name -match $containerPattern) {
                Get-ChildItem -LiteralPath $d.FullName -Directory -ErrorAction SilentlyContinue | ForEach-Object {
                    $toCheck.Add($_.FullName)
                }
            }
        }

        foreach ($folder in ($toCheck | Select-Object -Unique)) {
            $candidate = Get-JavaCandidate -Folder $folder
            if ($candidate -and $seen.Add($candidate.Home.ToLower())) {
                $found.Add($candidate)
            }
        }
    }

    return $found |
        Sort-Object @{Expression = { if ($_.Type -eq 'JDK') { 0 } else { 1 } } }, @{Expression = { $_.Version } ; Descending = $true }, Name
}

Write-Title '本地 Java 环境检测'
$roots = Collect-SearchRoots -InputRoots $SearchRoots
$candidates = @(Find-JavaCandidates -Roots $roots)

if (-not $candidates -or $candidates.Count -eq 0) {
    Write-Host '没有检测到可用的 Java 环境。' -ForegroundColor Red
    Write-Host '建议：把脚本放到包含 jdk/jre 文件夹的父目录中，或者传入 -SearchRoots 指定扫描目录。'
    exit 1
}

Write-Host '检测到以下 Java 环境：' -ForegroundColor Green
for ($i = 0; $i -lt $candidates.Count; $i++) {
    $item = $candidates[$i]
    $vendorText = if ([string]::IsNullOrWhiteSpace($item.Vendor)) { '' } else { " | $($item.Vendor)" }
    Write-Host ('[{0}] {1} | {2} | {3}{4}' -f ($i + 1), $item.Type.PadRight(3), $item.Version.PadRight(12), $item.Home, $vendorText)
}

if ([string]::IsNullOrWhiteSpace($Scope)) {
    if ($NonInteractive) {
        $Scope = 'User'
    } else {
        $Scope = Get-ScopeInteractive
    }
}

if ($Selection -lt 1 -or $Selection -gt $candidates.Count) {
    if ($NonInteractive) {
        $Selection = 1
    } else {
        $Selection = Get-SelectionInteractive -Candidates $candidates
    }
}

if ($Selection -eq 0) {
    Write-Host '已取消。'
    exit 0
}

$selected = $candidates[$Selection - 1]
Write-Title '开始设置环境变量'
Write-Host "已选择：[$Selection] $($selected.Type) $($selected.Version)"
Write-Host "JAVA_HOME = $($selected.Home)"

try {
    $existingPath = switch ($Scope) {
        'Process' { $env:Path }
        'User'    { [Environment]::GetEnvironmentVariable('Path', 'User') }
        'Machine' { [Environment]::GetEnvironmentVariable('Path', 'Machine') }
    }

    $cleanPath = Remove-OldJavaPathEntries -PathValue $existingPath
    $newPath = if ([string]::IsNullOrWhiteSpace($cleanPath)) {
        $selected.Bin
    } else {
        "$($selected.Bin);$cleanPath"
    }

    Set-EnvVarSafe -Name 'JAVA_HOME' -Value $selected.Home -ScopeName $Scope

    $candidateJreHome = $null
    if ($selected.Type -eq 'JRE') {
        $candidateJreHome = $selected.Home
    } else {
        $jdkInnerJre = Join-Path $selected.Home 'jre'
        if (Test-Path $jdkInnerJre -PathType Container) {
            $candidateJreHome = $jdkInnerJre
        }
    }

    if ($candidateJreHome) {
        Set-EnvVarSafe -Name 'JRE_HOME' -Value $candidateJreHome -ScopeName $Scope
        Write-Host "JRE_HOME  = $candidateJreHome"
    } else {
        Set-EnvVarSafe -Name 'JRE_HOME' -Value $null -ScopeName $Scope
        Write-Host 'JRE_HOME  = 已清理（当前所选版本不需要单独 JRE_HOME）'
    }

    Set-EnvVarSafe -Name 'Path' -Value $newPath -ScopeName $Scope
    Write-Host "Path 已更新：$($selected.Bin) 已置顶"
}
catch {
    Write-Host "设置失败：$($_.Exception.Message)" -ForegroundColor Red
    if ($Scope -eq 'Machine') {
        Write-Host '提示：Machine 级别通常需要用管理员身份运行 PowerShell。' -ForegroundColor Yellow
    }
    exit 1
}

Write-Title '校验结果'
try {
    & $selected.JavaExe -version 2>&1 | ForEach-Object { Write-Host $_ }
}
catch {
    Write-Host 'java -version 执行失败。' -ForegroundColor Yellow
}

if ($selected.Type -eq 'JDK' -and (Test-Path $selected.JavacExe)) {
    try {
        & $selected.JavacExe -version 2>&1 | ForEach-Object { Write-Host $_ }
    }
    catch {
        Write-Host 'javac -version 执行失败。' -ForegroundColor Yellow
    }
} else {
    Write-Host '当前选择的是 JRE，仅包含运行环境，不包含 javac 编译器。' -ForegroundColor Yellow
}

Write-Title '完成'
Write-Host "环境变量作用域：$Scope"
if ($Scope -eq 'Process') {
    Write-Host '仅当前窗口生效；关闭窗口后失效。'
} else {
    Write-Host '新开的 CMD / PowerShell 窗口会自动生效。当前窗口也已同步更新。'
}
Write-Host '默认不设置 CLASSPATH；大多数现代 Java 项目不需要手工配置它。'