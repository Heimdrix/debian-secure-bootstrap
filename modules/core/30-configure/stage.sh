#!/bin/sh
set -eu

for f in "$SCRIPT_DIR/modules/core/30-configure"/[0-9][0-9]-*.sh; do
  [ -f "$f" ] && . "$f"
done


stage_configure() {
  export PATH=/sbin:/usr/sbin:$PATH

  assert_var \
    LUKS_PARTITION

  [ -n "${LUKS_UUID:-}" ] || LUKS_UUID=$(blk_uuid "$LUKS_PARTITION")
  [ -n "${LUKS_NAME:-}" ] || LUKS_NAME="luks-${LUKS_UUID}"
  [ -n "${LUKS_DEVICE:-}" ] || LUKS_DEVICE="/dev/mapper/$LUKS_NAME"

  export LUKS_UUID LUKS_NAME LUKS_DEVICE

  assert_cmd \
    chroot   \
    cp       \
    mount

  assert_var            \
    ADMIN_PASSWORD_HASH \
    ADMIN_SSH_PUB       \
    ADMIN_USERNAME      \
    BTRFS_LAYOUT        \
    DEBIAN_ARCHITECTURE \
    DEBIAN_SUITE        \
    EFI_MOUNTPOINT      \
    EFI_PARTITION       \
    INSTALL_MOUNTPOINT  \
    LUKS_DEVICE         \
    LUKS_NAME           \
    LUKS_UUID           \
    PROJECT_ASSETS      \
    SYSTEM_DOMAIN       \
    SYSTEM_HOSTNAME

  step_run "Configuring fstab"              fstab_configure
  step_run "Mounting chroot filesystems"    chroot_bind_mounts
  step_run "Configuring crypttab"           crypttab_configure

  step_run "Configuring network"            network_configure
  step_run "Installing network stack"       network_install

  step_run "Configuring APT sources"        apt_sources
  step_run "Configuring APT"                apt_configure
  step_run "Updating package index"         apt_update

  step_run "Configuring kernel"             kernel_configure
  step_run "Installing kernel"              kernel_install

  step_run "Configuring dracut"             dracut_configure
  step_run "Installing dracut"              dracut_install

  step_run "Configuring systemd-boot"       systemdboot_configure
  step_run "Installing systemd-boot"        systemdboot_install

  step_run "Installing user packages"       user_install
  step_run "Creating admin user"            user_create
  step_run "Configuring SSH Auth keys"      user_authorized_keys_configure

  step_run "Installing shim"                shim_install
}