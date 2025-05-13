## Сборка `.box` через Packer
Настоящая инструкция описывает процесс сборки `.box`-образа
для VirtualBox из ISO-файла с помощью [Packer](https://developer.hashicorp.com/packer).
---
### Требования
- [Packerv 1.10.0](https://developer.hashicorp.com/packer/install) или выше
- [VirtualBox v7.1.8](https://download.virtualbox.org/virtualbox/7.1.8/) или выше
- [VBoxGuestAdditions_7.1.8.iso](https://download.virtualbox.org/virtualbox/7.1.8/VBoxGuestAdditions_7.1.8.iso)
- [debian-12.10.0-amd64-netinst.iso](https://cdimage.debian.org/cdimage/release/current/amd64/iso-cd/debian-12.10.0-amd64-netinst.iso)

Важно! Версии `VirtualBox` и `VBoxGuestAdditions` должны совпадать, иначе корректная работа не гарантируется.
### Порядок запуска
- Убедиться, что в одном каталоге находятся все 5 файлов:
  - `debian-12.10.0-amd64-netinst.iso`
  - `VBoxGuestAdditions_7.1.8.iso`
  - [`build.pkr.hcl`](bak/build.pkr.hcl)
  - [`preseed.cfg`](http/preseed.cfg)
  - [`setup.sh`](scripts/setup.sh)
- Выполнить (из этого каталога) команды:
```bash
packer init .
packer build .
```
- На выходе вы получите виртуалку в - VirtualBox и `.box`-файл со сборкой.

### Входные параметры
В файле `build.pkr.hcl` можно скорректировать следующие параметры:
- `debian_iso` → имя iso-файла с дистрибутивом Debian
- `ga_iso` → имя iso-файла с Guest Additions
- `vm_name` → имя виртуалки и `.box`-файла
