crypttab_tpm_configure() {
  printf '%s\tUUID=%s\tnone\tluks,discard,tpm2-device=auto,tpm2-pcrs=7\n' \
    "$LUKS_NAME" "$LUKS_UUID" \
    > "$INSTALL_MOUNTPOINT/etc/crypttab" || return 1
}