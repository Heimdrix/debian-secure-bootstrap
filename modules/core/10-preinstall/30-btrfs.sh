btrfs_format() {
  mkfs.btrfs              \
    --force               \
    --label 'Filesystem'  \
    --quiet               \
    --                    \
    "$LUKS_DEVICE" || return 1

  mount     \
    --mkdir \
    --      \
    "$LUKS_DEVICE" "$INSTALL_MOUNTPOINT" || return 1
}


btrfs_subvolumes_create() {
  printf '%s\n' "$BTRFS_LAYOUT" |
    while IFS='|' read -r _sub _rest; do
      [ -z "$_sub" ] && continue

      btrfs subvolume create -- "$INSTALL_MOUNTPOINT/$_sub" || return 1
    done
}


btrfs_subvolumes_mount() {
  umount --recursive -- "$INSTALL_MOUNTPOINT" 2>/dev/null || true

  printf '%s\n' "$BTRFS_LAYOUT" |
    while IFS='|' read -r _sub _mp _opts _dump _pass; do
      [ -n "$_sub" ] || continue

      mount                              \
        --mkdir                          \
        --options "$_opts,subvol=/$_sub" \
        --                               \
        "$LUKS_DEVICE" "$INSTALL_MOUNTPOINT$_mp" || return 1
    done
}