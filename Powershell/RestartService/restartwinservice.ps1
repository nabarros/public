##-------------------NAB_2021-10-12--------------------##
##.\restartwinservice.ps1 -user MCH\1NABARROS -scriptpath 'C:\Users\1NABARROS\Desktop\RestartService_NAB' -service 'newrelic-infra'

param($user,$service,$scriptpath)

#Set-PSSessionConfiguration -ShowSecurityDescriptorUI -Name Microsoft.PowerShell
$Servers = Get-Content "$scriptpath\Servers\servers.txt"
foreach ($Server in $Servers) {New-PSSession -ComputerName $Server -Credential $user -ErrorAction SilentlyContinue}


ForEach ($Server in $Servers)
{
Get-Service $service -ComputerName $Server -verbose | restart-Service
}

Remove-PSSession *