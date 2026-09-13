# AutoInstaller

AutoInstaller is a lightweight Windows post-install setup tool. It installs curated application bundles through [Windows Package Manager (`winget`)](https://learn.microsoft.com/windows/package-manager/winget/) instead of downloading and launching installer files itself.

The tool requires PowerShell 7 or newer and Windows 10/11. Administrator rights are not normally required; `winget` and individual packages may request elevation when needed.

## Quick start

1. Install [PowerShell 7](https://learn.microsoft.com/powershell/scripting/install/installing-powershell-on-windows) and ensure **App Installer** (which provides `winget`) is installed or updated from the Microsoft Store.
2. Clone or download this repository, inspect `config/apps.json`, and open PowerShell 7 in the repository folder.
3. Run either interactively or with a bundle list:

```powershell
pwsh -File .\Install-Apps.ps1
.\Install-Apps.ps1 -Bundles developer,gaming
.\Install-Apps.ps1 -Bundles general -WhatIf
.\Install-Apps.ps1 -Bundles developer,streaming -Force
```

Interactive mode lists the available bundles and asks for a comma-separated selection. The script always displays the resolved application list before installing. It asks for confirmation unless `-Force` is supplied. `-WhatIf` is a dry run: no installers are invoked.

`Main.ps1` is retained as a compatibility entry point and forwards the same parameters to `Install-Apps.ps1`.

## Bundles

| Bundle | Applications |
| --- | --- |
| `developer` | Python 3, Visual Studio Code, JetBrains Toolbox, CMake, Node.js LTS, Cygwin, Android Studio, 7-Zip |
| `gaming` | Steam, Discord |
| `general` | Google Chrome, 7-Zip, VLC, Notepad++, Gyazo |
| `streaming` | Streamlabs Desktop, VLC, Discord |

Apps that occur in more than one selected bundle are installed only once. The original NVIDIA app/GeForce Experience equivalent is not currently available from the default `winget` source, so it is intentionally not automated; install it through NVIDIA's official channels if needed.

## Customize the catalog

Edit [`config/apps.json`](config/apps.json). Each entry under `applications` has a friendly `name`, an explicit `winget` package `id`, and the fixed `winget` source. Bundles reference application keys, so add the application first and then add its key to one or more bundle arrays.

Find package IDs before editing with:

```powershell
winget search "Application name"
```

Keep IDs explicit and use packages from sources you trust. The configuration validator rejects entries whose source is not `winget` and rejects bundles that name unknown applications.

## Security notes

This project does not download or execute hard-coded EXE/MSI URLs. It delegates installation to `winget` using `install --id <id> --exact --source winget`, package/source agreement flags, and non-interactive package execution. You should still review `config/apps.json` before running it: package managers execute publisher-supplied installers and package availability can change over time.

The script stops early with instructions if `winget` is not available. It continues if an individual installation fails, prints an outcome for every application, summarizes all results, and exits with code `1` if any installation failed.

## Tests

The tests use [Pester](https://pester.dev/) and do not install software:

```powershell
Invoke-Pester .\tests\AutoInstaller.Tests.ps1
```

They validate the checked-in configuration, invalid bundle references, comma-separated bundle input, duplicate handling, and unknown-bundle errors.
