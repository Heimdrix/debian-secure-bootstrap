#!/bin/sh
set -eu

: "${SCRIPT_DIR:?uki/stage.sh: missing SCRIPT_DIR}"

for f in "$SCRIPT_DIR/modules/extras/uki"/[0-9][0-9]-*.sh; do
  [ -f "$f" ] && . "$f"
done


stage_uki() {
  export PATH=/sbin:/usr/sbin:$PATH

  assert_var            \
    EFI_MOUNTPOINT      \
    INSTALL_MOUNTPOINT  \
    MOK_CERT_DIR        \
    MOK_KEY_DIR

  [ -s "$INSTALL_MOUNTPOINT/etc/machine-id" ] || return 1

  MACHINE_ID="$(cat "$INSTALL_MOUNTPOINT/etc/machine-id")"
  MOK_KEY_PATH="${MOK_KEY_DIR}/${MACHINE_ID}.key"
  MOK_CERT_PATH="${MOK_CERT_DIR}/${MACHINE_ID}.crt"
  MOK_DER_PATH="${MOK_CERT_DIR}/${MACHINE_ID}.der"

  export MACHINE_ID MOK_KEY_PATH MOK_CERT_PATH MOK_DER_PATH

  assert_cmd \
    chroot   \
    mkdir

  step_run "Installing MOK packages"     mok_install
  step_run "Creating MOK keys"           mok_create

  step_run "Configuring ukify signing"   ukify_configure
  step_run "Installing ukify signing"    ukify_install
  step_run "Regenerating UKI"            ukify_regenerate
  
  step_run "Signing EFI binaries"        secureboot_sign
  step_run "Enrolling MOK key"           mok_enroll
}