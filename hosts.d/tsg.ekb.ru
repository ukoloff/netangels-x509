scp -qr /etc/ssl/uxm tsg.ekb.ru:/inetpub/x509

cat <<"EOF"  | ssh tsg.ekb.ru powershell -c -
# Import PFX
$crt = Import-PfxCertificate -FilePath "C:\inetpub\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My

# Update IIS
Get-WebBinding | Where-Object { $_.certificateHash } | ForEach-Object { $_.AddSslCertificate($crt.Thumbprint, 'My') }

# Update TSG / RDS
$cmd = "Set-RDCertificate -Role RDGateway -Thumbprint $($crt.Thumbprint) -Force"
psexec -accepteula -nobanner -s powershell -c $cmd
# restart service: TSGateway
EOF
