scp -qr /etc/ssl/uxm pbx.ekb.ru:/etc/ssl/

ssh pbx.ekb.ru killall -SIGHUP httpd
