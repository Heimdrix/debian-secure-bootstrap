# debian-secure-bootstrap (UEFI Only)

Security-focused Debian workstation provisioning with LUKS, Btrfs, Secure Boot, UKI, and TPM. Built for hardened and reproducible endpoint deployments.

---

## WARNING

This script will wipe the target disk completely.

Use only in:

* virtual machines
* test environments
* controlled deployments

---

## Features

* Full disk encryption (LUKS2)
* Btrfs with subvolume layout
* Secure Boot with custom MOK
* Unified Kernel Images (UKI)
* TPM2 integration (PCR7)
* Minimal Debian installation (debootstrap)
* Modular provisioning pipeline
* systemd-boot + shim support

---

## Design

The project follows a modular provisioning tree:

```text
preinstall
└── install
    └── configure
        ├── UKI enabled
        │   └── UKI + Secure Boot setup
        │       └── TPM enrollment skipped intentionally
        │
        └── UKI disabled
            └── Secure Boot + TPM enrollment from installer
```

### TPM behavior

TPM enrollment depends on the final boot trust chain.

When UKI is enabled:

1. MOK keys are generated
2. UKI is signed
3. MOK is enrolled (via MokManager on reboot)
4. System boots with final Secure Boot chain
5. TPM enrollment must be performed manually (or via automation)

This avoids invalid PCR7 measurements.

---

## Requirements

Recommended host environment:

* Debian-based system
* UEFI system
* Secure Boot available
* Root privileges
* Network access

Required tools (installed automatically on Debian hosts):

* dosfstools
* btrfs-progs
* cryptsetup
* wget
* systemd-timesyncd

---

## Non-Debian host environments

By default, the installer prepares the host automatically:

```sh
. "$SCRIPT_DIR/scripts/host_prerequisites_install.sh"
```

If you are using a non-Debian-based system:

1. Comment that line in `install.sh`
2. Install required tools manually
3. Ensure system time is correctly synchronized

Example:

```sh
# . "$SCRIPT_DIR/scripts/host_prerequisites_install.sh"
```

Minimum requirements:

* correct system time
* dosfstools
* btrfs-progs
* cryptsetup
* wget
* working time synchronization service

---

## Usage

Clone the repository:

```bash
git clone https://github.com/your-user/debian-secure-bootstrap
cd debian-secure-bootstrap
```

### 1. Create local configuration

```bash
cp .env.example .env
cp config/default.example.sh config/default.sh
```

### 2. Edit configuration

```bash
nano .env
nano config/default.sh
```

At minimum, configure:

* target disk (INSTALL_DISK)
* hostname and domain
* admin username
* SSH public key
* LUKS keyfile path
* password hash
* recovery backup passphrase
* UKI mode (ENABLE_UKI)

---

### 3. Run installer

```bash
sh install.sh
```

---

## Post-install (UKI enabled)

If ENABLE_UKI=1, TPM must be enrolled after the first successful boot:

```bash
systemd-cryptenroll \
  --tpm2-device=auto \
  --tpm2-pcrs=7 \
  /dev/<luks-partition>
```

---

## Project structure

```text
assets/     # static configs
config/     # configuration files
lib/        # shared functions
modules/    # provisioning stages
pipeline/   # orchestrator
scripts/    # helper scripts
```

---

## Security notes

* Do not commit real secrets
* Use `.env` for sensitive values
* Store recovery keys securely
* Test in virtual machines before real deployment
* TPM PCR7 depends on the Secure Boot trust chain

---

## License

MIT License

---
