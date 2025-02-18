scp -qr /etc/ssl/uxm wac.ekb.ru:/ProgramData/x509/

cat <<"EOF"  | ssh wac.ekb.ru powershell -c -

# Import PFX
$crt = Import-PfxCertificate -FilePath "C:\ProgramData\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My
$Thumbprint = $crt.Thumbprint
$appid = -split (
    netsh http show sslcert ipport=0.0.0.0:443 |
    Select-String Application |
    Select-Object -First 1) |
Select-Object -Last 1

netsh http delete sslcert ipport=0.0.0.0:443

netsh http add sslcert ipport=0.0.0.0:443 certhash=$Thumbprint appid=$appid

EOF
