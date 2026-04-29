step_run() { # usage: step_run <TEXT> <COMMAND> [ARGS...]
  _text=${1:?"step_run: missing TEXT"}
  shift

  if "$@"; then
    log_status done "$_text"
  else
    log_status error "$_text"
    exit 1
  fi
}