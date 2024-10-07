scp -qr /etc/ssl/uxm sd-old.ekb.ru:/etc/ssl/

ssh sd-old.ekb.ru killall -SIGHUP postgres
