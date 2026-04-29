debootstrap_install() {
  if [ -x /usr/sbin/debootstrap ]; then
    debootstrap_run /usr/sbin/debootstrap && return 0
  fi

  (
    set -eu

    _dir=$(mktemp -d -p /tmp) || exit 1
    trap 'rm -rf -- "$_dir"' EXIT INT HUP TERM

    wget -q -O "$_dir/debootstrap.deb" -- "$DEBOOTSTRAP_PACKAGE_URL" || exit 1

    (
      cd "$_dir" || exit 1
      ar x -- debootstrap.deb
    ) || exit 1

    mkdir -p -- "$_dir/pkg" || exit 1
    tar -C "$_dir/pkg" -xf "$_dir"/data.tar.* --no-same-owner || exit 1

    DEBOOTSTRAP_DIR="$_dir/pkg/usr/share/debootstrap" \
      debootstrap_run "$_dir/pkg/usr/sbin/debootstrap"
  )
}


debootstrap_run() {
  : "${1:?debootstrap_run: missing DEBOOTSTRAP_BIN}"

  "$1"                                    \
    --arch="$DEBIAN_ARCHITECTURE"         \
    --variant="$DEBIAN_VARIANT"           \
    --components=main                     \
    --include=ca-certificates             \
    "$DEBIAN_SUITE" "$INSTALL_MOUNTPOINT" \
    "http://deb.debian.org/debian"
}