scp -qr /etc/ssl/uxm postgres@db.tessa.ekb.ru:/etc/ssl/

ssh db.tessa.ekb.ru killall -SIGHUP postgres
