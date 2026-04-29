efi_format() {
  assert_blk "$EFI_PARTITION" || return 1

  mkfs.fat -F 32 -n EFI -- "$EFI_PARTITION" || return 1
}


efi_mount() {
  assert_blk "$EFI_PARTITION" || return 1

  mount                                   \
    --mkdir                               \
    --options noatime,nodev,nosuid,noexec \
    --                                    \
    "$EFI_PARTITION" "${INSTALL_MOUNTPOINT}${EFI_MOUNTPOINT}" || return 1
}