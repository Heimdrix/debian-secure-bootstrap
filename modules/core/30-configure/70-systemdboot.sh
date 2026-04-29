systemdboot_configure() {
  mkdir --parents -- \
    "${INSTALL_MOUNTPOINT}${EFI_MOUNTPOINT}/loader" || return 1

  printf '%s\n' \
    "timeout 0" \
    "editor no" \
    > "${INSTALL_MOUNTPOINT}${EFI_MOUNTPOINT}/loader/loader.conf" || return 1

  chmod 0644 -- \
    "${INSTALL_MOUNTPOINT}${EFI_MOUNTPOINT}/loader/loader.conf" || return 1
}


systemdboot_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    systemd-boot || return 1

  chroot "$INSTALL_MOUNTPOINT" \
    bootctl install || return 1
}