ukify_configure() {
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/etc/kernel" || return 1

  printf '%s\n'  \
    "layout=uki" \
    > "$INSTALL_MOUNTPOINT/etc/kernel/install.conf" || return 1

  chmod 0644 -- \
    "$INSTALL_MOUNTPOINT/etc/kernel/install.conf" || return 1
  
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/etc/kernel" || return 1

  printf '%s\n'                             \
    "[UKI]"                                 \
    "SecureBootPrivateKey=$MOK_KEY_PATH"    \
    "SecureBootCertificate=$MOK_CERT_PATH"  \
    > "$INSTALL_MOUNTPOINT/etc/kernel/uki.conf" || return 1

  chmod 0600 -- \
    "$INSTALL_MOUNTPOINT/etc/kernel/uki.conf" || return 1
}


ukify_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    sbsigntool                      \
    systemd-ukify                   \
    systemd-boot-efi || return 1

  # systemd-boot-efi provides the EFI stub (linuxx64.efi.stub)
  # required by systemd-ukify to build Unified Kernel Images (UKI)
}


ukify_regenerate() {
  _kver="$(chroot "$INSTALL_MOUNTPOINT" sh -c 'ls /lib/modules | sort -V | tail -n 1')" || return 1

  if [ -z "$_kver" ]; then
    log_status error "no kernel version found in /lib/modules"
    return 1
  fi

  if [ ! -f "$INSTALL_MOUNTPOINT/boot/vmlinuz-$_kver" ]; then
    log_status error "missing kernel image: /boot/vmlinuz-$_kver"
    return 1
  fi

  rm --recursive --force -- \
    "$INSTALL_MOUNTPOINT$EFI_MOUNTPOINT/$MACHINE_ID" \
    "$INSTALL_MOUNTPOINT$EFI_MOUNTPOINT/loader/entries"
  
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/$EFI_MOUNTPOINT/loader/entries"

  chroot "$INSTALL_MOUNTPOINT"  \
    kernel-install add          \
      "$_kver"                  \
      "/boot/vmlinuz-$_kver" || return 1
}