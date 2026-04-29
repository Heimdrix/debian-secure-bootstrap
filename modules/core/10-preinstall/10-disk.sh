disk_partition() {
  assert_blk "$INSTALL_DISK" || return 1

  printf '%s\n'                                                   \
    "label: gpt"                                                  \
    "unit: sectors"                                               \
    ""                                                            \
    "start=2048, size=$EFI_PARTITION_SIZE, type=U, name=\"EFI\""  \
    "start=, size=, type=L, name=\"LUKS\"" |
    sfdisk                      \
      --wipe always             \
      --wipe-partitions always  \
      "$INSTALL_DISK" || return 1
    
  sync

  blockdev      \
    --rereadpt  \
    --          \
    "$INSTALL_DISK" || true
  
  udevadm settle || true
}