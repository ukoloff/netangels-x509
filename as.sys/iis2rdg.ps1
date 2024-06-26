#
# Update RDGateway certificate from IIS' one
#

$iis = Get-WebBinding |
ForEach-Object { $_.certificateHash } |
Where-Object { $_ } |
Select-Object -Unique -First 1

$rdg = (Get-RDCertificate -Role RDGateway).Thumbprint

if ($rdg -ne $iis) {
    Set-RDCertificate -Role RDGateway -Thumbprint $iis -Force
    Restart-Service TSGateway
}
