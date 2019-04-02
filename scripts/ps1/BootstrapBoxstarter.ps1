# --- Elevate this script to Administrator ---
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Update-ExecutionPolicy -Policy Unrestricted

# --- Run BoxStarter Bootstrap ---

# --- Boxstarter Credentials ---
$username = "kls"
$password = ConvertTo-SecureString -String "kls" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -argumentList $username, $password

#--- Remove Existing Startup items ---
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\" -Recurse -Force

#--- Setup ---
. { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force
$Boxstarter.RebootOk=$true
$Boxstarter.AutoLogin=$true

#--- BoxStart ---
Install-BoxstarterPackage -PackageName \\kls-dms.kls.intranet\dist\install\Ansible\Boxstart.ps1 -Credential $credential
