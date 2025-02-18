scp -qr /etc/ssl/uxm wac.ekb.ru:/ProgramData/x509

cat <<"EOF"  | ssh wac.ekb.ru powershell -c -
# Import PFX
$crt = Import-PfxCertificate -FilePath "C:\ProgramData\x509\ekb-ru.pfx" -CertStoreLocation Cert:\LocalMachine\My

EOF
