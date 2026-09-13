$projectRoot = Split-Path -Parent $PSScriptRoot
Import-Module (Join-Path $projectRoot 'AutoInstaller.psm1') -Force
$configPath = Join-Path $projectRoot 'config/apps.json'

Describe 'Application catalog' {
    It 'loads the checked-in configuration' {
        $catalog = Get-AppCatalog -ConfigPath $configPath
        if ($catalog.schemaVersion -ne 1) { throw 'Expected schema version 1.' }
        foreach ($bundle in 'developer', 'gaming', 'general', 'streaming') {
            if ($catalog.bundles.Keys -notcontains $bundle) { throw "Missing bundle '$bundle'." }
        }
    }

    It 'rejects a bundle that references an unknown app' {
        $invalid = @{ schemaVersion = 1; applications = @{ known = @{ name = 'Known'; id = 'Contoso.Known'; source = 'winget' } }; bundles = @{ broken = @('missing') } }
        try {
            Test-AppCatalog -Catalog $invalid
            throw 'Expected validation to fail.'
        }
        catch {
            if ($_.Exception.Message -notlike '*unknown application*') { throw }
        }
    }
}

Describe 'Bundle selection' {
    It 'combines comma-separated bundles and removes duplicate applications' {
        $catalog = Get-AppCatalog -ConfigPath $configPath
        $apps = @(Resolve-SelectedApplications -Catalog $catalog -Bundles 'general,streaming')
        if ($apps.Id -notcontains 'VideoLAN.VLC') { throw 'Expected VLC to be selected.' }
        if (@($apps | Where-Object Id -eq 'VideoLAN.VLC').Count -ne 1) { throw 'Expected VLC only once.' }
    }

    It 'rejects an unknown bundle' {
        $catalog = Get-AppCatalog -ConfigPath $configPath
        try {
            Resolve-SelectedApplications -Catalog $catalog -Bundles 'unknown'
            throw 'Expected bundle selection to fail.'
        }
        catch {
            if ($_.Exception.Message -notlike '*Unknown bundle*') { throw }
        }
    }
}
