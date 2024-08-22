scp -qr /etc/ssl/uxm gitlab.ekb.ru:/etc/ssl/

ssh gitlab.ekb.ru killall -SIGHUP postgres
