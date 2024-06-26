#
# List process hierarchy
#

$id = $PID

$ps = while ($true) {
    $self = Get-CimInstance Win32_Process -Filter "ProcessId=$id" -KeyOnly
    if (!$self) { break }
    $id = $self.ParentProcessId
    $self
}

$ps |
Select-Object -Property ProcessId, CommandLine |
ConvertTo-Json |
Set-Content "C:\Temp\ps-$PID.json"
