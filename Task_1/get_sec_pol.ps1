# get_sec_pol.ps1
# Must be run as Administrator

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-Not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script must be run as Administrator!" -ForegroundColor Red
    exit
}

secedit /export /cfg secpol.txt
Write-Host "Security policy exported to secpol.txt"