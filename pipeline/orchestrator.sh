#!/bin/sh
set -eu

: "${SCRIPT_DIR:?pipeline/orchestrator.sh: missing SCRIPT_DIR}"

for f in "$SCRIPT_DIR"/lib/*.sh; do
  [ -f "$f" ] && . "$f"
done

. "$SCRIPT_DIR/modules/core/10-preinstall/stage.sh"
. "$SCRIPT_DIR/modules/core/20-install/stage.sh"
. "$SCRIPT_DIR/modules/core/30-configure/stage.sh"
. "$SCRIPT_DIR/modules/extras/tpm/stage.sh"
. "$SCRIPT_DIR/modules/extras/uki/stage.sh"


run_pipeline() {
  step_run "Running preinstall stage" stage_preinstall
  step_run "Running install stage"    stage_install
  step_run "Running configure stage"  stage_configure

  if [ "${ENABLE_UKI:-0}" = "1" ]; then
    step_run "Running UKI stage" stage_uki
  fi

  # TPM enrollment is intentionally skipped when UKI is enabled.
  # With custom-signed UKIs, PCR 7 depends on the final Secure Boot chain,
  # including the enrolled MOK. TPM enrollment must be performed later,
  # after MokManager enrollment and a successful boot into the final system.
  
  # Note: Read ./modules/extras/tpm/20-tpm.sh
  if [ "${ENABLE_UKI:-0}" != "1" ]; then
    step_run "Running TPM stage" stage_tpm
  fi
}