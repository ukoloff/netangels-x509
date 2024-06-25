# powershell -c "Get-Date | Set-Content 'C:/Temp/out.txt'"

$Action = New-ScheduledTaskAction -Execute "powershell" -Argument "-c `"Get-Date | Set-Content 'C:/Temp/out.txt'`""
$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date)
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger
Register-ScheduledTask -TaskName "TestX" -TaskPath uxm -InputObject $Task -Force
