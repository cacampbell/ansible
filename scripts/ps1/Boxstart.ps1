# Description: Boxstarter Script
#
# Install boxstarter:
# 	. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
#
# You might need to set: Set-ExecutionPolicy RemoteSigned
#
# Run this boxstarter by calling the following from an **elevated** command-prompt:
# 	start http://boxstarter.org/package/nr/url?<URL-TO-RAW-GIST>
# OR
# 	Install-BoxstarterPackage -PackageName <URL-TO-RAW-GIST> -DisableReboots
#
# Learn more: http://boxstarter.org/Learn/WebLauncher

#---- TEMPORARY ---
Disable-UAC

#--- Windows Settings ---
Disable-BingSearch
Disable-GameBarTips
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions
Set-TaskbarOptions -Size Small -Dock Bottom -Combine Full -AlwaysShowIconsOn

#--- Enable Remoting ---
Enable-RemoteDesktop
Set-NetFirewallRule -Name RemoteDesktop-UserMode-In-TCP -Enabled True
Enable-PSRemoting -Force
Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
Enable-WSManCredSSP -Force -Role Server

# --- Remove Page File ---
Write-BoxstarterMessage "Removing Page file"
$pageFileMemoryKey = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
Set-ItemProperty -Path $pageFileMemoryKey -Name PagingFiles -Value ""

#--- Uninstall unnecessary applications that come with Windows out of the box ---
# 3D Builder
Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage

# Alarms
Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage

# Autodesk
Get-AppxPackage *Autodesk* | Remove-AppxPackage

# Bing Weather, News, Sports, and Finance (Money):
Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage
Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage
Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage
Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage

# BubbleWitch
Get-AppxPackage *BubbleWitch* | Remove-AppxPackage

# Candy Crush
Get-AppxPackage king.com.CandyCrush* | Remove-AppxPackage
Get-AppxPackage *CandyCrush* | Remove-AppxPackage

# Comms Phone
Get-AppxPackage Microsoft.CommsPhone | Remove-AppxPackage

# Dell
Get-AppxPackage *Dell* | Remove-AppxPackage

# Dropbox
Get-AppxPackage *Dropbox* | Remove-AppxPackage

# Facebook
Get-AppxPackage *Facebook* | Remove-AppxPackage

# Feedback Hub
Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage

# Get Started
Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage

# Keeper
Get-AppxPackage *Keeper* | Remove-AppxPackage

# Maps
Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage

# March of Empires
Get-AppxPackage *MarchofEmpires* | Remove-AppxPackage

# McAfee Security
Get-AppxPackage *McAfee* | Remove-AppxPackage

# Uninstall McAfee Security App
$mcafee = gci "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" | foreach { gp $_.PSPath } | ? { $_ -match "McAfee Security" } | select UninstallString
if ($mcafee) {
	$mcafee = $mcafee.UninstallString -Replace "C:\Program Files\McAfee\MSC\mcuihost.exe",""
	Write "Uninstalling McAfee..."
	start-process "C:\Program Files\McAfee\MSC\mcuihost.exe" -arg "$mcafee" -Wait
}

# Messaging
Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage

# Music
Get-AppxPackage Microsoft.Music.Preview | Remove-AppxPackage

# Minecraft
Get-AppxPackage *Minecraft* | Remove-AppxPackage

# Netflix
Get-AppxPackage *Netflix* | Remove-AppxPackage

# Office Hub
Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage

# One Connect
Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage

# OneNote
Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage

# People
Get-AppxPackage Microsoft.People | Remove-AppxPackage

# Phone
Get-AppxPackage Microsoft.WindowsPhone | Remove-AppxPackage

# Photos
Get-AppxPackage Microsoft.Windows.Photos | Remove-AppxPackage

# Plex
Get-AppxPackage *Plex* | Remove-AppxPackage

# Sound Recorder
Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage

# Solitaire
Get-AppxPackage *Solitaire* | Remove-AppxPackage

# Sticky Notes
Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage

# Sway
Get-AppxPackage Microsoft.Office.Sway | Remove-AppxPackage

# Twitter
Get-AppxPackage *Twitter* | Remove-AppxPackage

# Xbox
Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage
Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage

# Zune Music, Movies & TV
Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage
Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage

# Privacy: Let apps use my advertising ID: Disable
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo")) {
    New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo | Out-Null
}
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0

# WiFi Sense: HotSpot Sharing: Disable
If (-Not (Test-Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
    New-Item -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting | Out-Null
}
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0

# WiFi Sense: Shared HotSpot Auto-Connect: Disable
Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0

# Start Menu: Disable Bing Search Results
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0
# To Restore (Enabled):
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 1

# Disable Telemetry (requires a reboot to take effect)
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWord -Value 0
Get-Service DiagTrack,Dmwappushservice | Stop-Service | Set-Service -StartupType Disabled

# Change Explorer home screen back to "This PC"
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1
# Change it back to "Quick Access" (Windows 10 default)
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 2

# Better File Explorer
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 1
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarMode -Value 2

# These make "Quick Access" behave much closer to the old "Favorites"
# Disable Quick Access: Recent Files
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0
# Disable Quick Access: Frequent Folders
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0
# To Restore:
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 1
# Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 1

# Disable the Lock Screen (the one before password prompt - to prevent dropping the first character)
If (-Not (Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization)) {
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows -Name Personalization | Out-Null
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1
# To Restore:
# Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization -Name NoLockScreen -Type DWord -Value 1

# Disable Xbox Gamebar
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name AppCaptureEnabled -Type DWord -Value 0
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name GameDVR_Enabled -Type DWord -Value 0

# Turn off People in Taskbar
If (-Not (Test-Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
    New-Item -Path HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People | Out-Null
}
Set-ItemProperty -Path "HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name PeopleBand -Type DWord -Value 0

#--- Schedule updates to applications with chocolatey ---
schtasks.exe /create /s "localhost" /ru "System" /tn "Update Chocolatey packages" /tr "%ChocolateyInstall%\bin\cup all" /sc DAILY /st 06:00 /F
Write-BoxstarterMessage "Set update schedule for apps is finished"

#--- Enable System Restore ---
Enable-ComputerRestore -Drive "C:\"

#--- Remove Shortcuts ---
Get-ChildItem -Path "C:\Users\*\Desktop\*" -Recurse -Include *.lnk | Remove-Item -Force

#--- Remove Pinned Start Menu Items ---
function Pin-App {    param(
        [string]$appname,
        [switch]$unpin
    )
    try{
        if ($unpin.IsPresent){
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Von "Start" lösen|Unpin from Start'} | %{$_.DoIt()}
            return "App '$appname' unpinned from Start"
        }else{
            ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() | ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'An "Start" anheften|Pin to Start'} | %{$_.DoIt()}
            return "App '$appname' pinned to Start"
        }
    }catch{
        Write-Error "Error Pinning/Unpinning App! (App-Name correct?)"
    }
}

Pin-App "Mail" -unpin
Pin-App "Store" -unpin
Pin-App "Calendar" -unpin
Pin-App "Calculator" -unpin
Pin-App "Microsoft Edge" -unpin
Pin-App "Photos" -unpin
Pin-App "Cortana" -unpin
Pin-App "Weather" -unpin
Pin-App "Phone Companion" -unpin
Pin-App "Twitter" -unpin
Pin-App "Skype Video" -unpin
Pin-App "Candy Crush Soda Saga" -unpin
Pin-App "xbox" -unpin
Pin-App "Groove music" -unpin
Pin-App "movies & tv" -unpin
Pin-App "microsoft solitaire collection" -unpin
Pin-App "money" -unpin
Pin-App "get office" -unpin
Pin-App "onenote" -unpin
Pin-App "news" -unpin


#--- Restore Temporary Settings ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula

#--- Clean up ---
Write-BoxstarterMessage "Cleaning SxS..."
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase

@(
    "$env:localappdata\Nuget",
    "$env:localappdata\temp\*",
    "$env:windir\logs",
    "$env:windir\panther",
    "$env:windir\temp\*",
    "$env:windir\winsxs\manifestcache"
) | % {
        if(Test-Path $_) {
            Write-BoxstarterMessage "Removing $_"
            Takeown /d Y /R /f $_
            Icacls $_ /GRANT:r administrators:F /T /c /q  2>&1 | Out-Null
            Remove-Item $_ -Recurse -Force -ErrorAction SilentlyContinue | Out-Null
        }
    }

# --- Defrag ---
Write-BoxstarterMessage "Defragging..."
Optimize-Volume -DriveLetter C

#--- Overwrite Empty Space ---
Write-BoxstarterMessage "0ing out empty space..."
wget http://download.sysinternals.com/files/SDelete.zip -OutFile sdelete.zip
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem")
[System.IO.Compression.ZipFile]::ExtractToDirectory("sdelete.zip", ".")
./sdelete.exe /accepteula -z c:

# --- Recreate Pagefile ---
Write-BoxstarterMessage "Recreate Pagefile after sysprep"
$System = GWMI Win32_ComputerSystem -EnableAllPrivileges
$System.AutomaticManagedPagefile = $true
$System.Put()

#--- Reboot if necessary ---
if (Test-PendingReboot) { Invoke-Reboot }
