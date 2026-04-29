shim_install() {
  export DEBIAN_FRONTEND=noninteractive

  apt_install "$INSTALL_MOUNTPOINT"                   \
    dialog                                            \
    efibootmgr                                        \
    shim-signed                                       \
    "systemd-boot-efi-${DEBIAN_ARCHITECTURE}-signed" || return 1
}