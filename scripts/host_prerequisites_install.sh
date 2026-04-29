#!/bin/sh
set -eu

host_prerequisites_install() {
export DEBIAN_FRONTEND=noninteractive

apt-get install --yes
systemd-timesync
dosfstools 
btrfs-progs 
cryptsetup 
wget

systemctl enable systemd-timesyncd >/dev/null 2>&1 || true
systemctl start systemd-timesyncd  >/dev/null 2>&1 || true

}

host_prerequisites_install