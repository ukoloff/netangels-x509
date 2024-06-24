scp -qr /etc/ssl/uxm tsg.ekb.ru:/inetpub/x509

cat <<"EOF"  | ssh tsg.ekb.ru powershell -c -
$crt = Import-PfxCertificate -FilePath "C:\inetpub\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My
echo $crt.Thumbprint
EOF
