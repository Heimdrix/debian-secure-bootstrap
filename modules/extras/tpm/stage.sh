#!/bin/sh
set -eu

: "${SCRIPT_DIR:?tpm/stage.sh: missing SCRIPT_DIR}"

for f in "$SCRIPT_DIR/modules/extras/tpm"/[0-9][0-9]-*.sh; do
  [ -f "$f" ] && . "$f"
done

stage_tpm() {
  export PATH=/sbin:/usr/sbin:$PATH

  assert_cmd \
    chroot \
    gpg

  assert_var \
    LUKS_PARTITION

  [ -n "${LUKS_UUID:-}" ] || LUKS_UUID=$(blk_uuid "$LUKS_PARTITION")
  [ -n "${LUKS_NAME:-}" ] || LUKS_NAME="luks-${LUKS_UUID}"
  [ -n "${LUKS_DEVICE:-}" ] || LUKS_DEVICE="/dev/mapper/$LUKS_NAME"

  CHROOT_KEYFILE_PATH="/tmp/luks-keyfile"
  CHROOT_KEYFILE="${INSTALL_MOUNTPOINT}${CHROOT_KEYFILE_PATH}"
  MACHINE_ID="$(cat "$INSTALL_MOUNTPOINT/etc/machine-id")"

  export LUKS_UUID LUKS_NAME LUKS_DEVICE
  export CHROOT_KEYFILE CHROOT_KEYFILE_PATH MACHINE_ID
  
  cp "$LUKS_KEYFILE" "$CHROOT_KEYFILE"
  chmod 0600 "$CHROOT_KEYFILE"

  assert_var            \
    BACKUP_PASSPHRASE   \
    INSTALL_MOUNTPOINT  \
    LUKS_NAME           \
    LUKS_KEYFILE        \
    LUKS_UUID

  step_run "Installing TPM packages"          tpm_install
  step_run "Configuring crypttab for TPM"     crypttab_tpm_configure
  step_run "Enrolling LUKS recovery key"      recovery_key_enroll
  step_run "Encrypting LUKS recovery key"     recovery_key_encrypt
  step_run "Enrolling TPM unlock"             tpm_enroll
}