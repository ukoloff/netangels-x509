# powershell -c "Get-Date | Set-Content 'C:/Temp/out.txt'"

$Action = New-ScheduledTaskAction -Execute "powershell" -Argument "-c `" whoami | Set-Content 'C:/Temp/out.txt'`""
$Trigger = Get-CimClass -ClassName 'MSFT_TaskRegistrationTrigger' -Namespace 'Root/Microsoft/Windows/TaskScheduler'
$Settings = New-ScheduledTaskSettingsSet -DeleteExpiredTaskAfter 00:00:01
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
$Task.Triggers[0].EndBoundary = (Get-Date).AddSeconds(5).ToString('s')
Register-ScheduledTask -TaskName "Now!" -TaskPath uxm -InputObject $Task -User "System" -Force
