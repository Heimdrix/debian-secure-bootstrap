# --- BTRFS ---

BTRFS_LAYOUT='
@|/|noatime,discard=async,compress=zstd:3|0|0
@home|/home|noatime,discard=async,compress=zstd:3,nodev,nosuid|0|0
@var|/var|noatime,discard=async,compress=zstd:3|0|0
@var_cache|/var/cache|noatime,discard=async,nodev,nosuid,noexec|0|0
@var_log|/var/log|noatime,discard=async,nodev,nosuid|0|0
@var_log_audit|/var/log/audit|noatime,discard=async,nodev,nosuid|0|0
@var_tmp|/var/tmp|noatime,discard=async,nodev,nosuid|0|0
@snapshots|/.snapshots|noatime,discard=async,compress=zstd:3|0|0
'
readonly BTRFS_LAYOUT

# --- DEBIAN ---

DEBIAN_ARCHITECTURE="amd64"
DEBIAN_VARIANT="minbase"
DEBIAN_SUITE="trixie"
readonly DEBIAN_ARCHITECTURE DEBIAN_VARIANT DEBIAN_SUITE

# --- DEBOOTSTRAP ---

DEBOOTSTRAP_PACKAGE_URL="https://ftp.debian.org/debian/pool/main/d/debootstrap/debootstrap_VERSION_all.deb"
readonly DEBOOTSTRAP_PACKAGE_URL

# --- EFI ---

EFI_PARTITION_SIZE="256MiB"
EFI_MOUNTPOINT="/efi"
readonly EFI_PARTITION_SIZE EFI_MOUNTPOINT

# --- INSTALL ---

INSTALL_DISK="/dev/sdX"                  # e.g. /dev/sda, /dev/nvme0n1
INSTALL_MOUNTPOINT="/mnt/debinstall"
readonly INSTALL_DISK INSTALL_MOUNTPOINT

# --- LUKS ---

LUKS_KEYFILE="$SCRIPT_DIR/secrets/example_luks-passphrase.key"
readonly LUKS_KEYFILE

# --- PROJECT ---

PROJECT_ASSETS="$SCRIPT_DIR/assets"
readonly PROJECT_ASSETS

# --- SECURE BOOT ---

MOK_KEY_DIR="/etc/secureboot/keys/private"
MOK_CERT_DIR="/etc/secureboot/keys/public"
readonly MOK_KEY_DIR MOK_CERT_DIR

# --- SYSTEM ---

SYSTEM_DOMAIN="example.local"
SYSTEM_HOSTNAME="workstation"
readonly SYSTEM_DOMAIN SYSTEM_HOSTNAME

# --- UKI ---

ENABLE_UKI=0   # 1 = enable UKI + Secure Boot flow

# --- USER ---

ADMIN_SSH_PUB="$SCRIPT_DIR/secrets/example_admin_ed25519.pub"
ADMIN_USERNAME="admin"
readonly ADMIN_SSH_PUB ADMIN_USERNAME

# --- BACKUP / RECOVERY ---

BACKUP_PASSPHRASE="change-me"
RECOVERY_OUTPUT_DIR="$SCRIPT_DIR/recovery"
