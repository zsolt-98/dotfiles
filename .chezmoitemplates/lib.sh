# Shared helpers for .chezmoiscripts. Each script inlines this file with chezmoi's template action.
set -eu

log()  { printf '\033[1;33m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;31m!!  %s\033[0m\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

SOURCE_DIR={{ .chezmoi.sourceDir | quote }}
BREW={{ printf "%s/bin/brew" .brewprefix | quote }}
export PATH="$HOME/.local/bin:$PATH"

# Put brew on PATH when it is installed.
load_brew() {
  if [ -x "$BREW" ]; then eval "$("$BREW" shellenv)"; fi
}

# Sets SUDO ("" or "sudo") and CAN_SUDO (1 or 0).
# Root needs no sudo. DOTFILES_NO_SUDO=1 skips the sudo prompt (servers without sudo rights).
detect_sudo() {
  if [ "$(id -u)" -eq 0 ]; then
    SUDO=""; CAN_SUDO=1
  elif [ "${DOTFILES_NO_SUDO:-0}" != 1 ] && have sudo && sudo -v; then
    SUDO="sudo"; CAN_SUDO=1
  else
    SUDO=""; CAN_SUDO=0
  fi
}

# Sets PM to dnf, or "" on other Linux (only Fedora is supported).
detect_pm() {
  if have dnf; then PM=dnf
  else PM=""
  fi
}

# Print package names from a packages/*.txt list.
# Drops comments and blank lines; keeps [nobrew] lines only when Homebrew is missing.
read_pkgs() {
  _file=$1 _nobrew=$2
  while IFS= read -r _line; do
    _line=${_line%%#*}
    # shellcheck disable=SC2086
    set -- $_line
    if [ $# -eq 0 ]; then continue; fi
    case ${2:-} in
      "") echo "$1" ;;
      "[nobrew]") if [ "$_nobrew" = 1 ]; then echo "$1"; fi ;;
      *) warn "unknown tag '$2' in $_file" ;;
    esac
  done < "$_file"
}

# Install packages with the system package manager. Needs detect_sudo and detect_pm first.
pm_install() {
  if [ $# -eq 0 ]; then return 0; fi
  case $PM in
    dnf) $SUDO dnf install -y "$@" ;;
  esac
}
