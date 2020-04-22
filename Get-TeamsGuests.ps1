<#
.SYNOPSIS
  Get assigned guests in all teams.
.DESCRIPTION
  Query Teams PowerShell for any guest users.
  Needs to be run as admin the first time.
  Will install NuGet package provider and MicroftTeams PowerShell module if required.  
.NOTES
  Version:        1.0
  Author:         Coert Kastelein <ckastelein@asapcloud.com>
  Creation Date:  20-4-2020
  Purpose/Change: New
#>
if (Get-Module -ListAvailable -Name MicrosoftTeams){Connect-MicrosoftTeams -ErrorAction Stop} 
else {Write-Host ""
Write-Host "MicrosoftTeams PowerShell module is not installed"
Write-Host ""
$isadmin = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isadmin = $isadmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isadmin -eq "True") {if(!(Get-PackageProvider -ListAvailable -Name NuGet)) {Write-Host "Installing NuGet 2.8.5.208"
Install-PackageProvider -name NuGet -requiredversion 2.8.5.208 -Force}
Write-Host "Installing MicrosoftTeams PowerShell module"
Install-Module MicrosoftTeams -Force -ErrorAction Stop
sleep 3
Connect-MicrosoftTeams -ErrorAction Stop}
else {Write-Host "Not running as administrator, cannot install MicrosoftTeams PowerShell module"
Write-Host ""
Read-Host -Prompt "Press Enter to exit"
exit}}
Write-Host "Getting teams"
Write-Host ""
$teams = Get-Team | sort DisplayName
$teamcount = $teams.Count
$teamcounter = 0
$guestcount = 0
$membercount = 0
Write-Host "$teamcount teams found"
Write-Host ""
Write-Host "Checking teams for guests"
foreach ($team in $teams) {
$teamcounter = $teamcounter + 1
$guests = Get-TeamUser -GroupId $team.GroupId | Where-Object {$_.role -eq 'guest'}
foreach ($guest in $guests) {
$guestcount = $guestcount + 1}
$membercount = $guests.count
if ($guests -ne $null) { $owner = Get-TeamUser -GroupId $team.GroupId | Where-Object {$_.role -eq 'owner'}
Write-Host ""
Write-Host "Name:"$team.DisplayName
Write-Host "Owners:"$owner.Name
Write-Host "Guests:"$membercount
Write-Host ""
$guests.User
Write-Host ""
Write-Host "----------------------------------------------------------------"}}
Write-Host ""
Write-Host "Found a total of $guestcount guest assignments in $teamcount teams"
Write-Host ""
Read-Host -Prompt "Press Enter to exit"