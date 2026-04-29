recovery_key_enroll() {
  mkdir --parents -- \
    "$RECOVERY_DIR" || return 1

  chroot "$INSTALL_MOUNTPOINT"                  \
    systemd-cryptenroll                         \
      --unlock-key-file="$CHROOT_KEYFILE_PATH"  \
      --recovery-key                            \
      "$LUKS_PARTITION"                         \
      > "$RECOVERY_DIR/$MACHINE_ID.key" || return 1

  chmod 0600 -- \
    "$RECOVERY_DIR/$MACHINE_ID.key" || return 1
}


recovery_key_encrypt() {
  for _recovery_key in "$RECOVERY_DIR"/*.key; do
    [ -f "$_recovery_key" ] || continue

    printf '%s' "$BACKUP_PASSPHRASE" | \
      gpg                             \
        --symmetric                   \
        --cipher-algo AES256          \
        --batch                       \
        --passphrase-fd 0             \
        --output "$_recovery_key.gpg" \
        "$_recovery_key"

    chmod 0600 -- \
      "$_recovery_key.gpg" || return 1

    rm "$_recovery_key"
  done
}