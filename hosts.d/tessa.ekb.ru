scp -qr /etc/ssl/uxm tessa.ekb.ru:/etc/ssl/

ssh tessa.ekb.ru killall -SIGHUP nginx
