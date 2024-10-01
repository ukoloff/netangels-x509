scp -qr /etc/ssl/uxm sd.ekb.ru:/inetpub/x509

cat <<"EOF"  | ssh sd.ekb.ru powershell -c -
# Import PFX
$crt = Import-PfxCertificate -FilePath "C:\inetpub\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My

# Update IIS
Get-WebBinding | Where-Object { $_.certificateHash } | ForEach-Object { $_.AddSslCertificate($crt.Thumbprint, 'My') }
EOF
