#!/bin/sh
set -eu

for f in "$SCRIPT_DIR/modules/core/20-install"/[0-9][0-9]-*.sh; do
  [ -f "$f" ] && . "$f"
done


stage_install() {
  assert_cmd  \
    ar        \
    mktemp    \
    tar       \
    wget

  assert_var                  \
    DEBIAN_ARCHITECTURE       \
    DEBIAN_SUITE              \
    DEBIAN_VARIANT            \
    DEBOOTSTRAP_PACKAGE_URL   \
    INSTALL_MOUNTPOINT


  step_run "Running debootstrap" debootstrap_install
}