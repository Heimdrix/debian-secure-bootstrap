# If TPM 2.0 is enabled:
  # slot 0 -> recovery key
  # slot 1 -> TPM 2.0
  # slot 2 -> keyfile (temporary)


luks_format() {
  assert_blk  "$LUKS_PARTITION" || return 1
  assert_file "$LUKS_KEYFILE"   || return 1
  
  cryptsetup luksFormat         \
    --batch-mode                \
    --key-file "$LUKS_KEYFILE"  \
    --key-slot 2                \
    --type luks2                \
    --                          \
    "$LUKS_PARTITION" || return 1
}


luks_open() {
  assert_blk  "$LUKS_PARTITION" || return 1
  assert_file "$LUKS_KEYFILE"   || return 1

  cryptsetup open               \
    --allow-discards            \
    --persistent                \
    --key-file "$LUKS_KEYFILE"  \
    "$LUKS_PARTITION" "$LUKS_NAME" || return 1
}