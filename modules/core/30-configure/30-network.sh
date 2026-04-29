network_configure() {
  printf '%s\n'         \
    "$SYSTEM_HOSTNAME"  \
    > "$INSTALL_MOUNTPOINT/etc/hostname"

  printf '%s\n'                                                          \
    "127.0.0.1   localhost"                                              \
    "127.0.1.1   ${SYSTEM_HOSTNAME}.${SYSTEM_DOMAIN} ${SYSTEM_HOSTNAME}" \
    "::1         localhost ip6-localhost ip6-loopback"                   \
    > "$INSTALL_MOUNTPOINT/etc/hosts"

  mkdir --parents \
    "$INSTALL_MOUNTPOINT/etc/systemd/network"

  printf '%s\n'   \
    "[Match]"     \
    "Type=ether"  \
    ""            \
    "[Network]"   \
    "DHCP=yes"    \
    > "$INSTALL_MOUNTPOINT/etc/systemd/network/20-wired.network"
}


network_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    systemd-resolved                \
    systemd-timesyncd || return 1

  chroot "$INSTALL_MOUNTPOINT"  \
    systemctl enable            \
      systemd-networkd          \
      systemd-resolved          \
      systemd-timesyncd || return 1
}