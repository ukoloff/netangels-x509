scp -qr /etc/ssl/uxm kcloak.ekb.ru:/etc/ssl/

ssh kcloak.ekb.ru systemctl restart keycloak
