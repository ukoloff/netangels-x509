# powershell -c "Get-Date | Set-Content 'C:/Temp/out.txt'"

$Action = New-ScheduledTaskAction -Execute "powershell" -Argument "-c `"Get-Date | Set-Content 'C:/Temp/out.txt'`""
$Trigger = Get-CimClass -ClassName 'MSFT_TaskRegistrationTrigger' -Namespace 'Root/Microsoft/Windows/TaskScheduler'
New-ScheduledTaskTrigger -Once -At (Get-Date)
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger
$Options = New-ScheduledTaskSettingsSet -Priority 5 #-StartWhenAvailable
Register-ScheduledTask -TaskName "Now!" -TaskPath uxm -InputObject $Task -Force
