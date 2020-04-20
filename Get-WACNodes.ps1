<#
.SYNOPSIS
  Get all WAC eligible objects from AD.

.DESCRIPTION
  Query Active Directory for all Windows Admin Center eligible objects, Windows Server 2008 R2 and newer, Windows 10 clients and clusters.

.NOTES
  Version:        1.1
  Author:         Coert Kastelein <coert@asapnet.com>
  Creation Date:  21-6-2018
  Purpose/Change: Made compatible with Windows Admin Center Preview 1806
  
.PARAMETER -export
  Exports inventory files.

.PARAMETER -server
  Find all servers with Windows Server 2008 R2 or newer.  

.PARAMETER -client
  Find all eligible Windows 10 clients.

.PARAMETER -cluster
  Includes clusters (BETA).  
  
.OUTPUTS
  Using the -export parameter three inventory files are generated: C:\Output\servers.txt, C:\Output\clients.txt and C:\Output\clusters.txt

.EXAMPLE
  PS C:>Get-WACNodes

.EXAMPLE
  PS C:>Get-WACNodes -export
  
.EXAMPLE
  PS C:>Get-WACNodes -server -cluster  
#>

Function Get-WACNodes {

param (
[switch]$showAll = $true,
[switch]$server = $false,
[switch]$client = $false,
[switch]$cluster = $false,
[switch]$export = $false)

#Check if Active Directory module is installed
If (Get-Module -ListAvailable -Name ActiveDirectory) {
} else {
    Write-Host "ActiveDirectory Module is not installed, exiting script"
    Start-Sleep -Seconds 5
    Exit}

If ($server -or $showAll) {

#Get servers
$servers=@(Get-ADComputer -Filter {(OperatingSystem -Like "*server*") -and (OperatingSystemVersion -Like "10.*") -or (OperatingSystemVersion -Like "6.3*") -and (OperatingSystem -Like "*server*") -or (OperatingSystemVersion -Like "6.2*") -and (OperatingSystem -Like "*server*") -or (OperatingSystemVersion -Like "6.1*") -and (OperatingSystem -Like "*server*")} -Properties DnsHostName,OperatingSystem | Sort-Object DnsHostName | select -ExpandProperty DnsHostName)}

If ($client -or $showAll) {

#Get clients
$clients=@(Get-ADComputer -Filter {(OperatingSystem -NotLike "*server*") -and (OperatingSystemVersion -Like "10.*") -and (OperatingSystem -NotLike "*team*")} -Properties DnsHostName,OperatingSystem | Sort-Object DnsHostName | select -ExpandProperty DnsHostName)}

If ($cluster -or $showAll) {

#Get clusters (BETA)
$clusters=@(Get-ADComputer -Filter {Description -Like "* cluster *"} -Properties DnsHostName | Sort-Object DnsHostName | select -ExpandProperty DnsHostName)}

If ($export) {

#Create folder
New-Item -ItemType Directory -Force -Name "Output" -Path c:\

#Create text file of servers nodes
Out-File -FilePath c:\output\servers.txt -InputObject $servers -Force

#Create text file of client nodes
Out-File -FilePath c:\output\clients.txt -InputObject $clients -Force

#Create text file of clusters
Out-File -FilePath c:\output\clusters.txt -InputObject $clusters -Force

#Open Output folder
explorer c:\output}

#Write collected data

If ($server){Write-Output -InputObject "`n| SERVERS"
Write-Output -InputObject "------------------------"
Write-Output -InputObject $servers
$showAll = $false}

If ($client){Write-Output -InputObject "`n| CLIENTS"
Write-Output -InputObject "------------------------"
Write-Output -InputObject $clients
$showAll = $false}

If ($cluster){Write-Output -InputObject "`n| CLUSTERS"
Write-Output -InputObject "------------------------"
Write-Output -InputObject $clusters
$showAll = $false}

If ($showAll){

Write-Output -InputObject "`n| SERVERS"
Write-Output -InputObject "------------------------"
Write-Output -InputObject $servers

Write-Output -InputObject "`n| CLIENTS"
Write-Output -InputObject "------------------------"
Write-Output -InputObject $clients

Write-Output -InputObject "`n| CLUSTERS (BETA)"
Write-Output -InputObject "------------------------"
Write-Output -InputObject $clusters}}