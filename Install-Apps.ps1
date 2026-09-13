#requires -Version 7.0
[CmdletBinding(SupportsShouldProcess)]
param(
    [string[]]$Bundles,
    [switch]$Force,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'config/apps.json')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
Import-Module (Join-Path $PSScriptRoot 'AutoInstaller.psm1') -Force

function Test-WingetAvailable {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Error @'
Windows Package Manager (winget) was not found.

Install or update App Installer from the Microsoft Store, then open a new PowerShell 7 window and run this script again:
https://apps.microsoft.com/detail/9NBLGGH4NNS1

On managed devices, ask your IT administrator to install or enable App Installer.
'@
        return $false
    }
    return $true
}

function Show-Selection {
    param([Parameter(Mandatory)][object[]]$Applications)
    Write-Host ''
    Write-Host 'Selected applications:' -ForegroundColor Cyan
    $Applications | Select-Object Name, Id, Source | Format-Table -AutoSize | Out-Host
}

function Confirm-Selection {
    param([Parameter(Mandatory)][object[]]$Applications)
    if ($Force -or $WhatIfPreference) { return $true }
    return (Read-Host "Install $($Applications.Count) application(s)? [y/N]") -match '^(?i:y|yes)$'
}

try {
    $catalog = Get-AppCatalog -ConfigPath $ConfigPath
    if (-not $Bundles -or $Bundles.Count -eq 0) { $Bundles = Get-InteractiveBundleSelection -Catalog $catalog }
    $applications = @(Resolve-SelectedApplications -Catalog $catalog -Bundles $Bundles)
    Show-Selection -Applications $applications
    if (-not (Confirm-Selection -Applications $applications)) {
        Write-Host 'No changes were made.' -ForegroundColor Yellow
        exit 0
    }
    if (-not (Test-WingetAvailable)) { exit 1 }

    $results = [System.Collections.Generic.List[object]]::new()
    foreach ($app in $applications) {
        if ($WhatIfPreference) {
            Write-Host "What if: Install $($app.Name) [$($app.Id)]" -ForegroundColor Yellow
            $results.Add([pscustomobject]@{ Name = $app.Name; Id = $app.Id; Status = 'Dry run'; ExitCode = $null })
            continue
        }
        Write-Host "Installing $($app.Name) [$($app.Id)]..." -ForegroundColor Cyan
        try {
            & winget install --id $app.Id --exact --source $app.Source --accept-package-agreements --accept-source-agreements --disable-interactivity
            $exitCode = $LASTEXITCODE
            if ($exitCode -eq 0) {
                Write-Host "Succeeded: $($app.Name)" -ForegroundColor Green
                $results.Add([pscustomobject]@{ Name = $app.Name; Id = $app.Id; Status = 'Succeeded'; ExitCode = 0 })
            }
            else {
                Write-Warning "Failed: $($app.Name) (winget exit code $exitCode)"
                $results.Add([pscustomobject]@{ Name = $app.Name; Id = $app.Id; Status = 'Failed'; ExitCode = $exitCode })
            }
        }
        catch {
            Write-Warning "Failed: $($app.Name) ($($_.Exception.Message))"
            $results.Add([pscustomobject]@{ Name = $app.Name; Id = $app.Id; Status = 'Failed'; ExitCode = $null })
        }
    }
    Write-Host ''
    Write-Host 'Installation summary:' -ForegroundColor Cyan
    $results | Format-Table Name, Id, Status, ExitCode -AutoSize | Out-Host
    $failed = @($results | Where-Object Status -eq 'Failed')
    if ($failed.Count -gt 0) {
        Write-Warning "$($failed.Count) application(s) failed. Review the output above and rerun after resolving the issue."
        exit 1
    }
}
catch {
    Write-Error $_.Exception.Message
    exit 1
}
