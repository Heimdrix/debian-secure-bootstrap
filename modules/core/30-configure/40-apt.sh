apt_configure() {
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/etc/apt/apt.conf.d" || return 1

  printf '%s\n'                         \
    'APT::Install-Recommends "false";'  \
    'APT::Install-Suggests "false";'    \
    > "$INSTALL_MOUNTPOINT/etc/apt/apt.conf.d/99no-recommends" || return 1

  chmod 0644 -- \
    "$INSTALL_MOUNTPOINT/etc/apt/apt.conf.d/99no-recommends" || return 1
}


apt_sources() {
  mkdir --parents -- \
    "$INSTALL_MOUNTPOINT/etc/apt"

  printf '%s\n'                                                                                                         \
    "deb https://deb.debian.org/debian                ${DEBIAN_SUITE}          main contrib non-free non-free-firmware" \
    "deb https://deb.debian.org/debian                ${DEBIAN_SUITE}-updates  main contrib non-free non-free-firmware" \
    "deb https://security.debian.org/debian-security  ${DEBIAN_SUITE}-security main contrib non-free non-free-firmware" \
    > "$INSTALL_MOUNTPOINT/etc/apt/sources.list"
}