#!/bin/sh
set -eu

for f in "$SCRIPT_DIR/modules/core/10-preinstall"/[0-9][0-9]-*.sh; do
  [ -f "$f" ] || continue
  . "$f"
done


stage_preinstall() {
  assert_cmd    \
    blkid       \
    blockdev    \
    btrfs       \
    cryptsetup  \
    mkfs.btrfs  \
    mkfs.fat    \
    mount       \
    sfdisk      \
    udevadm     \
    umount

  assert_var            \
    BTRFS_LAYOUT        \
    EFI_MOUNTPOINT      \
    EFI_PARTITION       \
    EFI_PARTITION_SIZE  \
    LUKS_KEYFILE        \
    LUKS_PARTITION      \
    INSTALL_DISK        \
    INSTALL_MOUNTPOINT


  step_run "Partitioning disk"              disk_partition
  step_run "Formatting LUKS partition"      luks_format

  LUKS_UUID=$(blk_uuid "$LUKS_PARTITION")
  LUKS_NAME=${LUKS_NAME:-"luks-${LUKS_UUID}"}
  LUKS_DEVICE="/dev/mapper/$LUKS_NAME"
  export LUKS_UUID LUKS_NAME LUKS_DEVICE

  step_run "Opening LUKS container"         luks_open
  step_run "Formatting Btrfs filesystem"    btrfs_format
  step_run "Creating Btrfs subvolumes"      btrfs_subvolumes_create
  step_run "Mounting Btrfs subvolumes"      btrfs_subvolumes_mount

  step_run "Formatting EFI partition"       efi_format
  step_run "Mounting EFI partition"         efi_mount
}