scp -qr /etc/ssl/uxm ad.ekb.ru:/inetpub/x509

cat <<"EOF"  | ssh ad.ekb.ru powershell -c -
#$pass = ConvertTo-SecureString -String "ekb-ru@netangels" -AsPlainText -Force
$crt = Import-PfxCertificate -FilePath "C:\inetpub\x509\uxm\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My
echo $crt.Thumbprint
EOF
