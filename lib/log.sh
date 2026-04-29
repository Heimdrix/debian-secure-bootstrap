log_status() { # usage: log_status <error|warning|done> <TEXT>
  : "${1:?log_status: missing enum error|warning|done}"
  : "${2:?log_status: missing TEXT}"

  case "$1" in
    error)
      printf '\033[0;31m[x]\t%s\033[0m\n' "$2" >&4
      printf "[x]\t%s\n" "$2"
      ;;
    warning)
      printf '\033[0;33m[!]\t%s\033[0m\n' "$2" >&3
      printf "[!]\t%s\n" "$2"
      ;;
    done)
      printf '\033[0;32m[/]\t%s\033[0m\n' "$2" >&3
      printf "[/]\t%s\n" "$2"
      ;;
    *)
      printf 'log_status: unknown value "%s"\n' "$1" >&4
      printf "error\t%s\n" "$2" >&2
      return 1
      ;;
  esac
}