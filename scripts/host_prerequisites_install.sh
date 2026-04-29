#!/bin/sh
set -eu

host_prerequisites_install() {
  export DEBIAN_FRONTEND=noninteractive

  apt-get install --yes \
    systemd-timesyncd

  systemctl start systemd-timesyncd >/dev/null 2>&1 || true
  sleep 2

  apt-get update -qq

  apt-get install --yes \
    dosfstools          \
    btrfs-progs         \
    cryptsetup          \
    wget

}

host_prerequisites_install