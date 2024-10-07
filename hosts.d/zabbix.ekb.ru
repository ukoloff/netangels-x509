scp -qr -P 2201 /etc/ssl/uxm zbx.ekb.ru:/etc/ssl/

ssh -p 2201 zbx.ekb.ru killall -SIGHUP apache2

ssh -p 2201 zbx.ekb.ru sendmail -i -t -r zabbix@omzglobal.com <<MSG
To: boss <Stanislav.Ukolov@omzglobal.com>
Subject: *.ekb.ru update

New NetAngels <https://panel.netangels.ru/certificates/> X509 certificate issued...
MSG
