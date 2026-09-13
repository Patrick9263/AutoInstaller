#requires -Version 7.0
<#
.SYNOPSIS
Compatibility entry point for the winget-based installer.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string[]]$Bundles,
    [switch]$Force,
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'config/apps.json')
)

& (Join-Path $PSScriptRoot 'Install-Apps.ps1') @PSBoundParameters
exit $LASTEXITCODE
