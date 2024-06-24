scp -qr /etc/ssl/uxm ad.ekb.ru:/inetpub/x509

cat <<"EOF"  | ssh ad.ekb.ru powershell -c -
# Import PFX
$crt = Import-PfxCertificate -FilePath "C:\inetpub\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My

# Update IIS
Get-WebBinding | Where-Object { $_.certificateHash } | ForEach-Object { $_.AddSslCertificate($crt.Thumbprint, 'My') }
EOF
