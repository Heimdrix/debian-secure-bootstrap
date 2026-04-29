dracut_configure() {
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/etc/dracut.conf.d" || return 1

  cp -- \
    "$PROJECT_ASSETS/dracut/10-main.conf" \
    "$INSTALL_MOUNTPOINT/etc/dracut.conf.d/10-main.conf" || return 1
}


dracut_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    cryptsetup                      \
    dracut                          \
    systemd-cryptsetup              \
    systemd-sysv                    \
    zstd || return 1
}