scp -qr -P 2201 /etc/ssl/uxm zbx.ekb.ru:/etc/ssl/

ssh -p 2201 zbx.ekb.ru killall -SIGHUP apache2
