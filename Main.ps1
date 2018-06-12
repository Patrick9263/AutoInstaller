
################################### links for each installer ###################################
$links = @(
    "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe"
    "https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe"
    "https://discordapp.com/api/download?platform=win"
    "https://code.visualstudio.com/docs/?dv=win"
    "https://updates.twitchapp.net/windows/installer/TwitchSetup.exe"
    "https://download.jetbrains.com/product?code=TBA&distribution=windows"
    "https://dl.google.com/dl/android/studio/install/3.1.2.0/android-studio-ide-173.4720617-windows.exe"
    "https://cygwin.com/setup-x86_64.exe"
    "https://cfhcable.dl.sourceforge.net/project/qbittorrent/qbittorrent-win32/qbittorrent-4.1.0/qbittorrent_4.1.0_x64_setup.exe"
    "https://www.7-zip.org/a/7z1805-x64.exe"
    "https://streamlabs.com/slobs/download"
    "https://git-scm.com/download/win"
    "https://cmake.org/files/v3.11/cmake-3.11.2-win64-x64.msi"
    #"https://riotgamespatcher-a.akamaihd.net/releases/live/installer/deploy/League%20of%20Legends%20installer%20NA.exe"
    "http://videolan.mirrors.hivelocity.net/vlc/3.0.2/win64/vlc-3.0.2-win64.exe"
    "https://notepad-plus-plus.org/repository/7.x/7.5.4/npp.7.5.4.Installer.x64.exe"
    "https://us.download.nvidia.com/GFE/GFEClient/3.13.1.30/GeForce_Experience_v3.13.1.30.exe"
    "https://nodejs.org/dist/v10.1.0/node-v10.1.0-x64.msi"
    "https://files.gyazo.com/setup/Gyazo-3.3.5.exe"
    )
################################################################################################


################################### paths for each installer ###################################
$paths = @(
    "$env:TEMP\steam.exe"
    "$env:TEMP\python.exe"
    "$env:TEMP\discord.exe"
    "$env:TEMP\VSCode.exe"
    "$env:TEMP\twitch.exe"
    "$env:TEMP\toolbox.exe"
    "$env:TEMP\androidStudio.exe"
    "$env:TEMP\cygwin.exe"
    "$env:TEMP\qbittorrent.exe"
    "$env:TEMP\7zip.exe"
    "$env:TEMP\streamLabs.exe"
    "$env:TEMP\git.exe"
    "$env:TEMP\cmake.msi"
    "$env:TEMP\vlc.exe"
    "$env:TEMP\NPpp.exe"
    "$env:TEMP\nvidia.exe"
    "$env:TEMP\node.msi"
    "$env:TEMP\gyazo.exe"
    "$env:TEMP\GoogleChrome.exe"
)

################################################################################################

Write-Host "Downloading the files..."
$i = 0
foreach ($link in $links) {
    try {
        Write-Host "Downloading #$i..."
        Start-BitsTransfer -Source $link $paths[$i]
    }
    catch {
        Write-Host "Could not download $paths[$i]"
    }
    $i = $i + 1
}
Write-Host "Finished downloading."

Write-Host "Installing the files..."
$i = 0
foreach ($path in $paths) {
    try {
        Write-Host "Installing #$i..."
        Start-Process -FilePath $path -Wait
    }
    catch {
        Write-Host "Could not install $paths[$i]"
    }
    $i = $i + 1
}
Write-Host "Installed the files."
################################### Delete the installers once they finish ###################################

Write-Host "Deleting installers..."
$i = 0
foreach ($path in $paths) {
    try {
        Write-Host "Installing #$i..."
        Remove-Item -LiteralPath $path
    }
    catch {
        Write-Host "Could not remove $paths[$i]"
    }
    $i = $i + 1
}
Write-Host "Installers deleted"

#### Links: 
# "https://sourceforge.net/projects/qbittorrent/files/qbittorrent-win32/qbittorrent-4.1.0/qbittorrent_4.1.0_x64_setup.exe/download"
# "https://dl.google.com/dl/android/studio/install/3.1.2.0/android-studio-ide-173.4720617-windows.exe"
# "https://get.videolan.org/vlc/3.0.2/win64/vlc-3.0.2-win64.exe"
# "https://www.7-zip.org/a/7z1805-x64.exe"
# "https://cmake.org/files/v3.11/cmake-3.11.2-win64-x64.msi"
# "https://notepad-plus-plus.org/repository/7.x/7.5.4/npp.7.5.4.Installer.x64.exe"
# "https://us.download.nvidia.com/GFE/GFEClient/3.13.1.30/GeForce_Experience_v3.13.1.30.exe"
# "https://nodejs.org/dist/v10.1.0/node-v10.1.0-x64.msi"
# "http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-windows-x64.exe"
# "https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.00.42_x64_Logitech.exe"
