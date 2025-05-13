#!/usr/bin/env bash
set -euxo pipefail

echo "remove linux-headers"
dpkg --list \
  | awk '{ print $2 }' \
  | grep 'linux-headers' || true \
  | xargs -r apt-get -y purge;

echo "remove specific Linux kernels, such as linux-image-4.9.0-13-amd64 but keeps the current kernel and does not touch the virtual packages"
dpkg --list \
    | awk '{ print $2 }' \
    | grep 'linux-image-[1-9].*' \
    | grep -v "$(uname -r)" || true \
    | xargs -r apt-get -y purge;

echo "remove linux-source package"
dpkg --list \
    | awk '{ print $2 }' \
    | grep linux-source || true \
    | xargs -r apt-get -y purge;

echo "remove all development packages"
dpkg --list \
    | awk '{ print $2 }' \
    | grep -- '-dev\(:[a-z0-9]\+\)\?$' || true \
    | xargs -r apt-get -y purge;

echo "remove X11 libraries"
apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6;

echo "remove obsolete networking packages"
apt-get -y purge ppp pppconfig pppoeconf;

echo "remove popularity-contest package"
apt-get -y purge popularity-contest;

echo "remove installation-report package"
apt-get -y purge installation-report;

echo "autoremoving packages and cleaning apt data"
apt-get -y autoremove;
apt-get -y clean;

echo "wipe APT lists entirely (they survive apt-clean)"
rm -rf /var/lib/apt/lists/*

echo "remove /var/cache"
find /var/cache -type f -exec rm -f {} \;

echo "truncate any logs that have built up during the install"
find /var/log -type f -exec truncate --size=0 {} \;

echo "drop docs, man-pages, info"
rm -rf /usr/share/doc/* /usr/share/info/* /usr/share/man/*

echo "blank netplan machine-id (DUID) so machines get unique ID generated on boot"
truncate -s 0 /etc/machine-id
if test -f /var/lib/dbus/machine-id
then
  truncate -s 0 /var/lib/dbus/machine-id  # if not symlinked to "/etc/machine-id"
fi

echo "remove the contents of /tmp and /var/tmp"
rm -rf /tmp/* /var/tmp/* || true

echo "force a new random seed to be generated"
rm -f /var/lib/systemd/random-seed

echo "clear the history so our install isn't there"
rm -f /root/.wget-hsts

echo "Очистка файловой истории оболочки"
rm -f /root/.bash_history
for u in /home/*; do
  [ -f "$u/.bash_history" ] && rm -f "$u/.bash_history"
done

echo "Zero-filling disk to reduce box size..."
dd if=/dev/zero of=/EMPTY bs=1M status=none || true
rm -f /EMPTY

sync