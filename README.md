# netangels-x509
Загрузка сертификатов x509 с netangels.ru при помощи API.

## Установка сервера SSH на Windows

- [Загрузка][ssh-win32] MSI и установка

- Разрешить правило брандмаурэра для всех профилей

    *Почему-то разрешено только в частном профиле*

- В `C:\ProgramData\ssh\sshd_config` закомментировать
    ```
    ###Match Group administrators
    ###       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
    ###
    ```

- Перезапустить службу
    ```bat
    net stop sshd
    net start sshd
    ```

- Создать пользователя `root`
    ```bat
    net user root <LongStrongPassword> /add
    ```

- Добавить в группу `Administrators`/`Администраторы`

- Зайти с паролем
    ```bash
    ssh root@<Host>
    ```

- Добавить в `C:\Users\root` папочку [.ssh](.ssh)


[ssh-win32]: https://github.com/PowerShell/Win32-OpenSSH/releases/latest

## Обновление сертификата Remote Desktop Gateway

Скрипт [tsg.ekb.ru](/hosts.d/tsg.ekb.ru)
делает это сам,
но может оказаться удобнее обновлять сертификат RDG
по сертификату IIS.
Тогда запускайте [iis2rdg.ps1](/as.sys/iis2rdg.ps1)
по расписанию
(раз в сутки?)
из под службы System.
