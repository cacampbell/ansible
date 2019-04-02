# Hi, I'm Windows 10. Searching me doesn't work by default, so you need to run this on every computer that runs me; fuck you!
# The following gets all installed packages, then re-registers them, making Cortana "see" them
Get-AppXPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}