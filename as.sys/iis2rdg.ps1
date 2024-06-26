#
# Update RDGateway certificate from IIS' one
#
param(
    [switch]$install,
    [switch]$remove
)

if ($install) {
    $me = Split-Path $PSCommandPath -Leaf
    $dir = Split-Path $PSCommandPath -Parent
    $Action = New-ScheduledTaskAction -Execute "powershell" -Argument ".\$me" -WorkingDirectory $dir
    $Trigger = New-ScheduledTaskTrigger -At 04:00 -Daily
    $Task = New-ScheduledTask -Action $Action -Trigger $Trigger
    Register-ScheduledTask -TaskName "$me" -TaskPath uxm -InputObject $Task -User "System" -Force
    exit
}

if ($remove) {
    $me = Split-Path $PSCommandPath -Leaf
    Unregister-ScheduledTask -TaskName "$me" -TaskPath '\uxm\' -Confirm:$false
    exit
}


$iis = Get-WebBinding |
ForEach-Object { $_.certificateHash } |
Where-Object { $_ } |
Select-Object -Unique -First 1

$rdg = (Get-RDCertificate -Role RDGateway).Thumbprint

if ($rdg -ne $iis) {
    Set-RDCertificate -Role RDGateway -Thumbprint $iis -Force
    Restart-Service TSGateway
}
