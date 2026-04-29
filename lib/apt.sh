apt_install() { # usage: apt_install <MOUNT POINT> <PKG1> [PKG2...]
  _mnt=${1:? "apt_install: missing MOUNT POINT"}
  shift
  [ "$#" -ge 1 ] || return 0


  chroot "$_mnt" /usr/bin/env DEBIAN_FRONTEND=noninteractive \
    apt-get -qqq install --yes --no-install-recommends -- "$@" || return 1
}

apt_update() {
  chroot "$INSTALL_MOUNTPOINT" /usr/bin/env DEBIAN_FRONTEND=noninteractive \
    apt-get -qqq update || return 1
}