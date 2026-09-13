Set-StrictMode -Version Latest

function Get-AppCatalog {
    [CmdletBinding()]
    param([Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$ConfigPath)

    if (-not (Test-Path -LiteralPath $ConfigPath -PathType Leaf)) {
        throw "Configuration file was not found: $ConfigPath"
    }
    try {
        $catalog = Get-Content -LiteralPath $ConfigPath -Raw -ErrorAction Stop |
            ConvertFrom-Json -AsHashtable -Depth 20 -ErrorAction Stop
    }
    catch {
        throw "Could not parse configuration '$ConfigPath': $($_.Exception.Message)"
    }
    Test-AppCatalog -Catalog $catalog
    return $catalog
}

function Test-AppCatalog {
    [CmdletBinding()]
    param([Parameter(Mandatory)][hashtable]$Catalog)

    if ($Catalog.schemaVersion -ne 1) { throw 'Configuration schemaVersion must be 1.' }
    if ($Catalog.applications -isnot [System.Collections.IDictionary] -or $Catalog.applications.Count -eq 0) {
        throw 'Configuration must contain a non-empty applications object.'
    }
    if ($Catalog.bundles -isnot [System.Collections.IDictionary] -or $Catalog.bundles.Count -eq 0) {
        throw 'Configuration must contain a non-empty bundles object.'
    }
    foreach ($appKey in $Catalog.applications.Keys) {
        $app = $Catalog.applications[$appKey]
        if ($app -isnot [System.Collections.IDictionary]) { throw "Application '$appKey' must be an object." }
        foreach ($property in 'name', 'id', 'source') {
            if ($app[$property] -isnot [string] -or [string]::IsNullOrWhiteSpace($app[$property])) {
                throw "Application '$appKey' must define a non-empty '$property'."
            }
        }
        if ($app.source -ne 'winget') {
            throw "Application '$appKey' has unsupported source '$($app.source)'. Only 'winget' is permitted."
        }
    }
    foreach ($bundleName in $Catalog.bundles.Keys) {
        $appKeys = $Catalog.bundles[$bundleName]
        if ($appKeys -isnot [System.Collections.IEnumerable] -or $appKeys -is [string]) {
            throw "Bundle '$bundleName' must be an array of application keys."
        }
        foreach ($appKey in $appKeys) {
            if ($appKey -isnot [string] -or -not $Catalog.applications.ContainsKey($appKey)) {
                throw "Bundle '$bundleName' references unknown application '$appKey'."
            }
        }
    }
}

function Resolve-SelectedApplications {
    [CmdletBinding()]
    param([Parameter(Mandatory)][hashtable]$Catalog, [Parameter(Mandatory)][string[]]$Bundles)

    $normalizedBundles = @(
        foreach ($bundle in $Bundles) {
            $bundle -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
        }
    )
    if ($normalizedBundles.Count -eq 0) { throw 'Select at least one bundle.' }

    $selected = [System.Collections.Generic.List[object]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($bundle in $normalizedBundles) {
        if (-not $Catalog.bundles.ContainsKey($bundle)) {
            throw "Unknown bundle '$bundle'. Available bundles: $($Catalog.bundles.Keys -join ', ')"
        }
        foreach ($appKey in $Catalog.bundles[$bundle]) {
            if ($seen.Add($appKey)) {
                $app = $Catalog.applications[$appKey]
                $selected.Add([pscustomobject]@{ Key = $appKey; Name = $app.name; Id = $app.id; Source = $app.source })
            }
        }
    }
    return $selected
}

function Get-InteractiveBundleSelection {
    [CmdletBinding()]
    param([Parameter(Mandatory)][hashtable]$Catalog)

    Write-Host 'Available bundles:'
    foreach ($bundleName in $Catalog.bundles.Keys) {
        Write-Host "  $bundleName ($(@($Catalog.bundles[$bundleName]).Count) apps)"
    }
    $answer = Read-Host 'Enter one or more bundle names, separated by commas'
    return @($answer -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

Export-ModuleMember -Function Get-AppCatalog, Test-AppCatalog, Resolve-SelectedApplications, Get-InteractiveBundleSelection
