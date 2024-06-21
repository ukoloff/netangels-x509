scp -qr /etc/ssl/uxm postgres@file.uralhimmash.ru:/etc/ssl/

ssh file.uralhimmash.ru killall -SIGHUP nginx postgres
