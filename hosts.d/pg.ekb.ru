scp -qr /etc/ssl/uxm postgres@pg.ekb.ru:/etc/ssl/

ssh pg.ekb.ru killall -SIGHUP postgres
