#!/bin/sh
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
export SCRIPT_DIR

. "$SCRIPT_DIR/scripts/host_prerequisites_install.sh"

# --- Logging ---
LOG_DIR="$SCRIPT_DIR/.log"
mkdir -p "$LOG_DIR"

LOG_FILE_PATH="$LOG_DIR/$(date +%Y%m%d_%H%M%S).log"

exec 3>&1
exec 4>&2

exec 1>>"$LOG_FILE_PATH"
exec 2>&1

# --- Load config + pipeline ---
set -a
. "$SCRIPT_DIR/.env"
. "$SCRIPT_DIR/config/default.sh"
. "$SCRIPT_DIR/config/derived.sh"
set +a

. "$SCRIPT_DIR/pipeline/orchestrator.sh"
run_pipeline