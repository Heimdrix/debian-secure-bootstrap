assert_blk() { # usage: assert_blk <DEVICE> [DEVICE...]
  if [ "$#" -le 0 ]; then
    log_status error "assert_blk: missing DEVICES"
    exit 1
  fi

  for _device; do
    if [ ! -b "$_device" ]; then
      log_status error "missing block device: ${_device}"
      exit 1
    fi
  done
}


assert_cmd() { # usage: assert_cmd <COMMAND> [COMMAND...]
  if [ "$#" -le 0 ]; then
    log_status error "assert_cmd: missing COMMANDS"
    exit 1
  fi

  for _command; do
    if ! command -v "$_command" >/dev/null 2>&1; then
      log_status error "missing command: ${_command}"
      exit 1
    fi
  done
}


assert_var() { # usage: assert_var <VARIABLE> [VARIABLE...]
  if [ "$#" -le 0 ]; then
    log_status error "assert_var: missing VARIABLES"
    exit 1
  fi

  for _variable; do
    case "$_variable" in
      ''|*[!A-Za-z0-9_]*|[0-9]*)
        printf '%s\n' "assert_var: invalid variable name: ${_variable}"
        exit 1
        ;;
    esac

    eval "_val=\${$_variable-}"
    if [ -z "${_val:-}" ]; then
      log_status error "missing variable: ${_variable}"
      exit 1
    fi
  done
}


assert_file() { # usage: assert_file <FILE> [FILE...]
  if [ "$#" -le 0 ]; then
    log_status error "assert_file: missing FILES"
    exit 1
  fi

  for _file; do
    if [ ! -f "$_file" ]; then
      log_status error "missing file: ${_file}"
      exit 1
    fi

    if [ ! -r "$_file" ]; then
      log_status error "file not readable: ${_file}"
      exit 1
    fi
  done
}
