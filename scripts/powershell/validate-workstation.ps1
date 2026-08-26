[CmdletBinding()]
param()

$ErrorActionPreference = "Continue"
$ProgressPreference = "SilentlyContinue"
$results = @()

function Write-Section {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Title
    )

    Write-Host ""
    Write-Host "=== $Title ===" -ForegroundColor Cyan
}

function Add-ValidationResult {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Check,

        [Parameter(Mandatory = $true)]
        [ValidateSet("PASS", "WARN", "FAIL")]
        [string]$Status,

        [Parameter(Mandatory = $true)]
        [string]$Details
    )

    $script:results += [PSCustomObject]@{
        Check   = $Check
        Status  = $Status
        Details = $Details
    }

    $color = switch ($Status) {
        "PASS" { "Green" }
        "WARN" { "Yellow" }
        "FAIL" { "Red" }
    }

    Write-Host ("[{0}] {1}: {2}" -f $Status, $Check, $Details) `
        -ForegroundColor $color
}

Write-Host ""
Write-Host "Zabbix NOC Lab - Workstation Validation" `
    -ForegroundColor White
Write-Host ("Execution time: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"))
Write-Host "Mode: read-only validation"

Write-Section -Title "Operating System"

try {
    $operatingSystem = Get-CimInstance Win32_OperatingSystem
    $computerSystem = Get-CimInstance Win32_ComputerSystem
    $processor = Get-CimInstance Win32_Processor |
        Select-Object -First 1

    if ($operatingSystem.OSArchitecture -match "64") {
        Add-ValidationResult `
            -Check "Windows architecture" `
            -Status "PASS" `
            -Details $operatingSystem.OSArchitecture
    }
    else {
        Add-ValidationResult `
            -Check "Windows architecture" `
            -Status "FAIL" `
            -Details $operatingSystem.OSArchitecture
    }

    $logicalProcessors = [int]$computerSystem.NumberOfLogicalProcessors

    if ($logicalProcessors -ge 4) {
        Add-ValidationResult `
            -Check "Logical processors" `
            -Status "PASS" `
            -Details "$logicalProcessors available"
    }
    else {
        Add-ValidationResult `
            -Check "Logical processors" `
            -Status "FAIL" `
            -Details "$logicalProcessors available; at least 4 required"
    }

    $physicalMemoryGB = [math]::Round(
        $computerSystem.TotalPhysicalMemory / 1GB,
        2
    )

    if ($physicalMemoryGB -ge 8) {
        Add-ValidationResult `
            -Check "Physical memory" `
            -Status "PASS" `
            -Details "$physicalMemoryGB GB available"
    }
    else {
        Add-ValidationResult `
            -Check "Physical memory" `
            -Status "FAIL" `
            -Details "$physicalMemoryGB GB available; at least 8 GB required"
    }

    Write-Host ("OS caption: {0}" -f $operatingSystem.Caption)
    Write-Host ("OS build: {0}" -f $operatingSystem.BuildNumber)
    Write-Host ("Processor: {0}" -f $processor.Name)
}
catch {
    Add-ValidationResult `
        -Check "Operating system inventory" `
        -Status "FAIL" `
        -Details $_.Exception.Message
}

Write-Section -Title "Disk Capacity"

try {
    $systemDrive = Get-CimInstance Win32_LogicalDisk `
        -Filter "DeviceID='$env:SystemDrive'"

    $freeDiskGB = [math]::Round(
        $systemDrive.FreeSpace / 1GB,
        2
    )

    if ($freeDiskGB -ge 20) {
        Add-ValidationResult `
            -Check "Free disk space" `
            -Status "PASS" `
            -Details "$freeDiskGB GB available on $env:SystemDrive"
    }
    else {
        Add-ValidationResult `
            -Check "Free disk space" `
            -Status "FAIL" `
            -Details "$freeDiskGB GB available; at least 20 GB required"
    }
}
catch {
    Add-ValidationResult `
        -Check "Free disk space" `
        -Status "FAIL" `
        -Details $_.Exception.Message
}

Write-Section -Title "PowerShell"

$powerShellDetails = "{0} {1}" -f `
    $PSVersionTable.PSEdition,
    $PSVersionTable.PSVersion.ToString()

Add-ValidationResult `
    -Check "PowerShell" `
    -Status "PASS" `
    -Details $powerShellDetails

Write-Section -Title "WSL 2"

try {
    $wslStatusOutput = (
        & wsl.exe --status 2>&1 |
        Out-String
    ).Trim()

    $wslStatusExitCode = $LASTEXITCODE

    $wslKernel = (
        & wsl.exe --exec uname -r 2>&1 |
        Out-String
    ).Trim()

    $wslKernelExitCode = $LASTEXITCODE

    if (
        $wslStatusExitCode -eq 0 -and
        $wslKernelExitCode -eq 0 -and
        $wslKernel -match "WSL2|microsoft-standard"
    ) {
        Add-ValidationResult `
            -Check "WSL 2" `
            -Status "PASS" `
            -Details "Kernel $wslKernel"
    }
    elseif ($wslStatusExitCode -eq 0) {
        Add-ValidationResult `
            -Check "WSL 2" `
            -Status "WARN" `
            -Details "WSL responded, but its version 2 kernel was not confirmed"
    }
    else {
        Add-ValidationResult `
            -Check "WSL 2" `
            -Status "FAIL" `
            -Details "WSL status command returned exit code $wslStatusExitCode"
    }

}
catch {
    Add-ValidationResult `
        -Check "WSL 2" `
        -Status "FAIL" `
        -Details $_.Exception.Message
}

Write-Section -Title "Docker Engine"

$dockerCommand = Get-Command docker -ErrorAction SilentlyContinue

if (-not $dockerCommand) {
    Add-ValidationResult `
        -Check "Docker CLI" `
        -Status "FAIL" `
        -Details "docker command not found"
}
else {
    Add-ValidationResult `
        -Check "Docker CLI" `
        -Status "PASS" `
        -Details $dockerCommand.Source

    try {
        $dockerServerVersion = (
            docker info --format '{{.ServerVersion}}' 2>$null
        ).Trim()

        if ($LASTEXITCODE -eq 0 -and $dockerServerVersion) {
            Add-ValidationResult `
                -Check "Docker server" `
                -Status "PASS" `
                -Details "Version $dockerServerVersion"
        }
        else {
            Add-ValidationResult `
                -Check "Docker server" `
                -Status "FAIL" `
                -Details "Docker Desktop or the Linux backend is unavailable"
        }
    }
    catch {
        Add-ValidationResult `
            -Check "Docker server" `
            -Status "FAIL" `
            -Details $_.Exception.Message
    }
}

Write-Section -Title "Docker Compose"

try {
    $composeVersion = (
        docker compose version --short 2>$null
    ).Trim()

    if ($LASTEXITCODE -eq 0 -and $composeVersion) {
        Add-ValidationResult `
            -Check "Docker Compose" `
            -Status "PASS" `
            -Details "Version $composeVersion"
    }
    else {
        Add-ValidationResult `
            -Check "Docker Compose" `
            -Status "FAIL" `
            -Details "docker compose command is unavailable"
    }
}
catch {
    Add-ValidationResult `
        -Check "Docker Compose" `
        -Status "FAIL" `
        -Details $_.Exception.Message
}

Write-Section -Title "Docker Resources"

try {
    $dockerInfo = docker info --format '{{json .}}' 2>$null |
        ConvertFrom-Json

    $dockerCPUs = [int]$dockerInfo.NCPU
    $dockerMemoryGB = [math]::Round(
        $dockerInfo.MemTotal / 1GB,
        2
    )

    if ($dockerCPUs -ge 4) {
        Add-ValidationResult `
            -Check "Docker CPU capacity" `
            -Status "PASS" `
            -Details "$dockerCPUs logical processors"
    }
    else {
        Add-ValidationResult `
            -Check "Docker CPU capacity" `
            -Status "WARN" `
            -Details "$dockerCPUs logical processors; 4 recommended"
    }

    if ($dockerMemoryGB -ge 4) {
        Add-ValidationResult `
            -Check "Docker memory capacity" `
            -Status "PASS" `
            -Details "$dockerMemoryGB GB"
    }
    else {
        Add-ValidationResult `
            -Check "Docker memory capacity" `
            -Status "FAIL" `
            -Details "$dockerMemoryGB GB; at least 4 GB required"
    }
}
catch {
    Add-ValidationResult `
        -Check "Docker resources" `
        -Status "FAIL" `
        -Details $_.Exception.Message
}

Write-Section -Title "Required TCP Ports"

$requiredPorts = @(
    [PSCustomObject]@{
        Port = 8080
        Purpose = "Zabbix web interface"
    }
    [PSCustomObject]@{
        Port = 8443
        Purpose = "Optional HTTPS interface"
    }
    [PSCustomObject]@{
        Port = 10050
        Purpose = "Zabbix Agent 2"
    }
    [PSCustomObject]@{
        Port = 10051
        Purpose = "Zabbix Server"
    }
)

foreach ($requiredPort in $requiredPorts) {
    $listeners = Get-NetTCPConnection `
        -LocalPort $requiredPort.Port `
        -State Listen `
        -ErrorAction SilentlyContinue

    if ($listeners) {
        $processNames = foreach ($listener in $listeners) {
            $process = Get-Process `
                -Id $listener.OwningProcess `
                -ErrorAction SilentlyContinue

            if ($process) {
                $process.ProcessName
            }
            else {
                "PID $($listener.OwningProcess)"
            }
        }

        $uniqueProcesses = $processNames |
            Sort-Object -Unique

        Add-ValidationResult `
            -Check "TCP $($requiredPort.Port)" `
            -Status "WARN" `
            -Details (
                "{0}; in use by {1}" -f `
                    $requiredPort.Purpose,
                    ($uniqueProcesses -join ", ")
            )
    }
    else {
        Add-ValidationResult `
            -Check "TCP $($requiredPort.Port)" `
            -Status "PASS" `
            -Details "$($requiredPort.Purpose); available"
    }
}

Write-Section -Title "DNS Resolution"

foreach ($dnsTarget in @("github.com", "zabbix.com")) {
    try {
        $dnsResult = Resolve-DnsName `
            -Name $dnsTarget `
            -Type A `
            -ErrorAction Stop |
            Select-Object -First 1

        Add-ValidationResult `
            -Check "DNS $dnsTarget" `
            -Status "PASS" `
            -Details $dnsResult.IPAddress
    }
    catch {
        Add-ValidationResult `
            -Check "DNS $dnsTarget" `
            -Status "FAIL" `
            -Details $_.Exception.Message
    }
}

Write-Section -Title "HTTPS Connectivity"

foreach ($httpsTarget in @("github.com", "zabbix.com")) {
    try {
        $httpsResult = Test-NetConnection `
            -ComputerName $httpsTarget `
            -Port 443 `
            -InformationLevel Quiet `
            -WarningAction SilentlyContinue

        if ($httpsResult) {
            Add-ValidationResult `
                -Check "HTTPS $httpsTarget" `
                -Status "PASS" `
                -Details "TCP 443 reachable"
        }
        else {
            Add-ValidationResult `
                -Check "HTTPS $httpsTarget" `
                -Status "FAIL" `
                -Details "TCP 443 unavailable"
        }
    }
    catch {
        Add-ValidationResult `
            -Check "HTTPS $httpsTarget" `
            -Status "FAIL" `
            -Details $_.Exception.Message
    }
}

Write-Section -Title "Git Repository"

$gitCommand = Get-Command git -ErrorAction SilentlyContinue

if (-not $gitCommand) {
    Add-ValidationResult `
        -Check "Git" `
        -Status "FAIL" `
        -Details "git command not found"
}
else {
    $insideRepository = (
        git rev-parse --is-inside-work-tree 2>$null
    ).Trim()

    if ($LASTEXITCODE -eq 0 -and $insideRepository -eq "true") {
        $currentBranch = (
            git branch --show-current 2>$null
        ).Trim()

        Add-ValidationResult `
            -Check "Git repository" `
            -Status "PASS" `
            -Details "Current branch: $currentBranch"
    }
    else {
        Add-ValidationResult `
            -Check "Git repository" `
            -Status "FAIL" `
            -Details "Run the script from the repository directory"
    }
}

Write-Section -Title "Existing Docker Resources"

if ($dockerCommand) {
    Write-Host "Containers:"
    docker ps --all `
        --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

    Write-Host ""
    Write-Host "Networks:"
    docker network ls `
        --format "table {{.Name}}\t{{.Driver}}\t{{.Scope}}"

    Write-Host ""
    Write-Host "Volumes:"
    docker volume ls `
        --format "table {{.Name}}\t{{.Driver}}"
}

Write-Section -Title "Validation Summary"

$results |
    Format-Table Status, Check, Details -AutoSize |
    Out-String -Width 220 |
    Write-Host

$passedChecks = @(
    $results |
        Where-Object {
            $_.Status -eq "PASS"
        }
).Count

$warningChecks = @(
    $results |
        Where-Object {
            $_.Status -eq "WARN"
        }
).Count

$failedChecks = @(
    $results |
        Where-Object {
            $_.Status -eq "FAIL"
        }
).Count

Write-Host ("Passed:   {0}" -f $passedChecks) `
    -ForegroundColor Green
Write-Host ("Warnings: {0}" -f $warningChecks) `
    -ForegroundColor Yellow
Write-Host ("Failed:   {0}" -f $failedChecks) `
    -ForegroundColor Red

if ($failedChecks -gt 0) {
    Write-Host ""
    Write-Host "RESULT: WORKSTATION NOT APPROVED" `
        -ForegroundColor Red
    exit 1
}

Write-Host ""

if ($warningChecks -gt 0) {
    Write-Host "RESULT: WORKSTATION APPROVED WITH WARNINGS" `
        -ForegroundColor Yellow
}
else {
    Write-Host "RESULT: WORKSTATION APPROVED" `
        -ForegroundColor Green
}

exit 0
