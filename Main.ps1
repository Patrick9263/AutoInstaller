
$uri = "https://www.jetbrains.com/toolbox/download/download-thanks.html"
$HTML = Invoke-WebRequest -Uri $uri
$test = $HTML.AllElements | Where-Object Class -eq "sub-title no-margin-bottom" | Select-Object -ExpandProperty innerHTML

Write-Host $test
#Start-BitsTransfer -Source $test ~/Downloads
# $steamLink = "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe"
# $pythonLink = "https://www.python.org/ftp/python/3.6.5/python-3.6.5.exe"
# $Link = "https://discordapp.com/api/download?platform=win"
# $Link = "https://code.visualstudio.com/docs/?dv=win"
# $Link = "https://updates.twitchapp.net/windows/installer/TwitchSetup.exe"
# $Link = 
# $Link = 
# $Link = 
# $Link = 
# $Link = "https://cygwin.com/setup-x86_64.exe"
# $Link = 
# $Link = 
# $Link = "https://streamlabs.com/slobs/download"
# $Link = "https://git-scm.com/download/win"
# $Link = 
# $Link = 
# $Link = 
# $Link = 
# $Link = 
# $Link = 
# $Link = "https://gyazo.com/download?dl=now"



# ################################### paths for each installer ###################################
# $googleChromePath = "$env:TEMP\GoogleChrome.exe"
# ################################################################################################

# Write-Host "Begin downloading the files..."
# Start-BitsTransfer -Source http://dl.google.com/chrome/install/chrome_installer.exe $googleChromePath
# Write-Host "Finished Downloading programs"


# Write-Host "Running the installers..."

# Start-Process -FilePath $googleChromePath -ArgumentList "/silent /install" -Wait
# Write-Host "Finished Installing Chrome"

# Write-Host "Finished Installing programs"

# Write-Host "Deleting installers..."

# ################################### Delete the installers once they finish ###################################
# Remove-Item -LiteralPath $googleChromePath

# Write-Host "Installers deleted"


# "https://sourceforge.net/projects/qbittorrent/files/qbittorrent-win32/qbittorrent-4.1.0/qbittorrent_4.1.0_x64_setup.exe/download"
# "https://dl.google.com/dl/android/studio/install/3.1.2.0/android-studio-ide-173.4720617-windows.exe"
# "https://get.videolan.org/vlc/3.0.2/win64/vlc-3.0.2-win64.exe"
# "https://www.7-zip.org/a/7z1805-x64.exe"

# "https://cmake.org/files/v3.11/cmake-3.11.2-win64-x64.msi"
# "https://notepad-plus-plus.org/repository/7.x/7.5.4/npp.7.5.4.Installer.x64.exe"


# "https://us.download.nvidia.com/GFE/GFEClient/3.13.1.30/GeForce_Experience_v3.13.1.30.exe"
# "https://riotgamespatcher-a.akamaihd.net/releases/live/installer/deploy/League%20of%20Legends%20installer%20NA.exe"
# "https://nodejs.org/dist/v10.1.0/node-v10.1.0-x64.msi"
# "http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-windows-x64.exe"
# "https://download01.logi.com/web/ftp/pub/techsupport/gaming/LGS_9.00.42_x64_Logitech.exe"
# "https://www.jetbrains.com/toolbox/download/download-thanks.html"
