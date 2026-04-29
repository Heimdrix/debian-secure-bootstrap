# NOTE:
# TPM enrollment with PCR 7 is intentionally environment-sensitive.
#
# PCR 7 does not only represent "Secure Boot enabled/disabled".
# It also depends on the active Secure Boot trust chain, including shim,
# enrolled MOK keys, DB/DBX state, and the boot environment used at
# enrollment time.
#
# When using a custom-signed UKI, TPM enrollment from the live installer
# may not match the final installed boot environment. In that case,
# automatic LUKS unlock can fail after reboot even if Secure Boot is enabled.
#
# For fully automated installations, either:
#   1. enroll TPM without PCR binding, or
#   2. perform TPM enrollment after the first boot into the final system.


tpm_enroll() {
  if [ ! -c "$INSTALL_MOUNTPOINT/dev/tpmrm0" ] && \
     [ ! -c "$INSTALL_MOUNTPOINT/dev/tpm0" ]; then
    log_status error "No TPM device found. Ensure /dev is mounted in chroot or TPM is available"
    return 1
  fi

  chroot "$INSTALL_MOUNTPOINT"                  \
    systemd-cryptenroll                         \
      --unlock-key-file="$CHROOT_KEYFILE_PATH"  \
      --tpm2-device=auto                        \
      --tpm2-pcrs=7                             \
      --wipe-slot=tpm2                          \
      "$LUKS_PARTITION" || return 1
  
  rm -f -- "$CHROOT_KEYFILE"
}


tpm_install() {
  apt_install "$INSTALL_MOUNTPOINT" \
    systemd-cryptsetup \
    tpm2-tools || return 1
}