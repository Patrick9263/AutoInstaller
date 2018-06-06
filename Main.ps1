
################################### paths for each installer ###################################
$googleChromePath = "$env:TEMP\GoogleChrome.exe"
################################################################################################

Write-Host "Begin downloading the files..."
Start-BitsTransfer -Source http://dl.google.com/chrome/install/chrome_installer.exe $googleChromePath
Write-Host "Finished Downloading programs"


Write-Host "Running the installers..."

Start-Process -FilePath $googleChromePath -ArgumentList "/silent /install" -Wait
Write-Host "Finished Installing Chrome"

Write-Host "Finished Installing programs"

Write-Host "Deleting installers..."

################################### Delete the installers once they finish ###################################
Remove-Item -LiteralPath $googleChromePath

Write-Host "Installers deleted"

