scp -qr /etc/ssl/uxm ad.ekb.ru:/inetpub/x509

cat <<"EOF"  | ssh ad.ekb.ru powershell -c -
$crt = Import-PfxCertificate -FilePath "C:\inetpub\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My
Get-WebBinding | Where-Object { $_.certificateHash } | ForEach-Object { $_.AddSslCertificate($crt.Thumbprint, 'My') }
EOF
