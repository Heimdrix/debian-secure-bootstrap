chroot_bind_mounts() {
  mkdir --parents --      \
    "$INSTALL_MOUNTPOINT/proc" || return 1
  
  mount --types proc proc \
    "$INSTALL_MOUNTPOINT/proc" || return 1

  for fs in dev run sys; do
    mount     \
      --mkdir \
      --rbind \
      "/$fs" "$INSTALL_MOUNTPOINT/$fs"  || return 1
    
    mount           \
      --make-rslave \
      "$INSTALL_MOUNTPOINT/$fs" || return 1
  done
}


crypttab_configure() {
  printf '%s\tUUID=%s\tnone\tluks,discard\n' \
    "$LUKS_NAME" "$LUKS_UUID" \
    > "$INSTALL_MOUNTPOINT/etc/crypttab" || return 1
}


fstab_configure() {
  _uuid=$(blk_uuid "$LUKS_DEVICE") || return 1

  printf '# %s\n'   \
    "$LUKS_DEVICE"  \
    > "$INSTALL_MOUNTPOINT/etc/fstab" || return 1

  printf '%s\n' "$BTRFS_LAYOUT" |
    while IFS='|' read -r _sub _mp _opts _dump _pass; do
      [ -n "$_sub" ] || continue

      printf 'UUID=%s\t%s\tbtrfs\trw,%s,subvol=/%s\t%s\t%s\n' \
        "$_uuid" "$_mp" "$_opts" "$_sub" "${_dump:-0}" "${_pass:-0}" \
        >> "$INSTALL_MOUNTPOINT/etc/fstab" || return 1
    done

  printf 'UUID=%s\t%s\tvfat\tnoatime,nodev,nosuid,noexec\t0\t2\n' \
    "$(blk_uuid "$EFI_PARTITION")" "$EFI_MOUNTPOINT" \
    >> "$INSTALL_MOUNTPOINT/etc/fstab" || return 1

  printf 'tmpfs\t/tmp\ttmpfs\trw,nosuid,nodev,mode=1777,size=2G\t0\t0\n' \
    >> "$INSTALL_MOUNTPOINT/etc/fstab" || return 1
}