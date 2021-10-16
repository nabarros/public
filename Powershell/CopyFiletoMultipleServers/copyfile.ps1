##-------------------NAB_2021-10-12-------------------##
##.\copyfile.ps1 -user MCH\1NABARROS -scriptpath C:\Users\1NABARROS\Desktop\CopyFiletoMultipleServers_NAB

param($user,$scriptpath)

Set-PSSessionConfiguration -ShowSecurityDescriptorUI -Name Microsoft.PowerShell
$Servers = Get-Content "$scriptpath\Servers\servers.txt"
foreach ($Server in $Servers) {New-PSSession -ComputerName $Server -Credential $user -ErrorAction SilentlyContinue}

# This file contains the list of servers you want to copy files/folders to
##$computers = gc "C:\Users\NLBARROS\OneDrive - SONAE\Documents\1.SONAE\Scripts\CopyFiletoMultipleServers_NAB\Servers\servers.txt"
 
# This is the file/folder(s) you want to copy to the servers in the $computer variable
$source = "$scriptpath\SourceFiles\*.yml"
 
# The destination location you want the file/folder(s) to be copied to
$destination = "C$\Program Files\New Relic\newrelic-infra\integrations.d\"
 
#The command below pulls all the variables above and performs the file copy

try{
foreach ($Server in $Servers) 
{ if (Test-Path -Path \\$Server\$destination){
Copy-Item -Path $source -Destination "\\$Server\$destination" -Recurse -Verbose -Force}
}
}
catch [UnauthorizedAccessException] {
write-host "Erro de autorização."
}

Remove-PSSession *