# --- DEVICE SUFFIX ---
device_partition_suffix() {
  case "$1" in
    *nvme*|*mmcblk*|*loop*) printf 'p' ;;
    *) printf '' ;;
  esac
}

# --- PARTITIONS ---
PART_SUFFIX=$(device_partition_suffix "$INSTALL_DISK")

EFI_PARTITION="${INSTALL_DISK}${PART_SUFFIX}1"
LUKS_PARTITION="${INSTALL_DISK}${PART_SUFFIX}2"

# --- LUKS RECOVERY ---
RECOVERY_DIR="$INSTALL_MOUNTPOINT/recovery"