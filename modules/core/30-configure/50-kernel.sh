kernel_configure() {
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/etc/kernel" || return 1

  printf '%s\n'           \
    "root=$LUKS_DEVICE"   \
    "rootfstype=btrfs"    \
    "rootflags=subvol=/@" \
    "rw quiet"            \
    > "$INSTALL_MOUNTPOINT/etc/kernel/cmdline" || return 1

  chmod 0644 -- \
    "$INSTALL_MOUNTPOINT/etc/kernel/cmdline" || return 1
}


kernel_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    "linux-image-$DEBIAN_ARCHITECTURE" || return 1
}