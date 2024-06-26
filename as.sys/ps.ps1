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

$ps | Format-Table ProcessId,CommandLine
