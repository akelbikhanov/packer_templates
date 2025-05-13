#!/usr/bin/env bash
set -euxo pipefail

ISO="/home/vagrant/VBoxGuestAdditions"
MOUNT_POINT="/mnt/vbga"

# Проверка: существует ли ISO-файл
if [ ! -f "$ISO" ]; then
  echo "Файл $ISO не найден. Установка Guest Additions невозможна."
  exit 1
fi

# Монтирование ISO
mkdir -p "$MOUNT_POINT"
mount -o loop "$ISO" "$MOUNT_POINT"

# Установка VBox Guest Additions (если смонтированы)
if [ -x "$MOUNT_POINT/VBoxLinuxAdditions.run" ]; then
  apt-get update
  apt-get install -y build-essential dkms "linux-headers-$(uname -r)"
  bash "$MOUNT_POINT/VBoxLinuxAdditions.run" --nox11 || true
  apt-get purge -y build-essential dkms "linux-headers-$(uname -r)"
fi

# Размонтирование и удаление ISO
umount "$MOUNT_POINT"
rm -f "$ISO"

# Установка базовых пакетов
apt-get update
apt-get install -y sudo openssh-server curl ca-certificates jq gnupg iproute2

# Настройка пользователя vagrant
mkdir -p /home/vagrant/.ssh
curl -fsSL https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub \
  -o /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
echo "vagrant ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/vagrant > /dev/null
chmod 0440 /etc/sudoers.d/vagrant
