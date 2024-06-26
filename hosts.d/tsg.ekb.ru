scp -qr /etc/ssl/uxm tsg.ekb.ru:/inetpub/x509

cat <<"EOF"  | ssh tsg.ekb.ru powershell -c -
# Import PFX
$crt = Import-PfxCertificate -FilePath "C:\inetpub\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My

# Update IIS
Get-WebBinding | Where-Object { $_.certificateHash } | ForEach-Object { $_.AddSslCertificate($crt.Thumbprint, 'My') }

# Update TSG / RDS
$cmd = "Set-RDCertificate -Role RDGateway -Thumbprint $($crt.Thumbprint) -Force"
$restart = "Restart-Service TSGateway"
$cmd = "$cmd ; $restart"

# psexec -accepteula -nobanner -s powershell -c $cmd
# restart service: TSGateway

# Run as System service via Scheduled Task
$Action = New-ScheduledTaskAction -Execute "powershell" -Argument "-c '$cmd'"
$Trigger = Get-CimClass -ClassName 'MSFT_TaskRegistrationTrigger' -Namespace 'Root/Microsoft/Windows/TaskScheduler'
$Settings = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter 00:01:00
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
$Task.Triggers[0].EndBoundary = (Get-Date).AddMinutes(1).ToString('s')
Register-ScheduledTask -TaskName "RDGateway.x509" -TaskPath uxm -InputObject $Task -User "System" -Force

EOF
