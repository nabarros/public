##-------------------NAB_2022-01-10-------------------##
##.\copyfile.ps1 -user DOMAIN\USER

param($user)
##$user = "DOMAIN\USER"
$tmp = [System.IO.Path]::GetTempFileName()
secedit.exe /export /cfg $tmp
$settings = Get-Content -Path $tmp
$account = New-Object System.Security.Principal.NTAccount($user)
$sid = $account.Translate([System.Security.Principal.SecurityIdentifier])
for($i=0;$i -lt $settings.Count;$i++){
    if($settings[$i] -match "SeServiceLogonRight")
    {
        $settings[$i] += ",*$($sid.Value)"
    }
}
$settings | Out-File $tmp
secedit.exe /configure /db secedit.sdb /cfg $tmp  /areas User_RIGHTS
Remove-Item -Path $tmp