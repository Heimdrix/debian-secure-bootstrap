secureboot_sign() {
  secureboot_sign_dir() {
    _dir=${1:?secureboot_sign: missing directory}

    for _efi in "$INSTALL_MOUNTPOINT$_dir"/*.efi; do
      [ -f "$_efi" ] || continue

      _efi_rel=${_efi#"$INSTALL_MOUNTPOINT"}

      chroot "$INSTALL_MOUNTPOINT"  \
        sbsign                      \
          --key "$MOK_KEY_PATH"     \
          --cert "$MOK_CERT_PATH"   \
          --output "$_efi_rel"      \
          "$_efi_rel" || return 1
    done
  }

  secureboot_sign_dir "$EFI_MOUNTPOINT/EFI/systemd" || return 1
  secureboot_sign_dir "$EFI_MOUNTPOINT/EFI/Linux" || return 1
}