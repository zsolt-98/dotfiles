#!/bin/sh
# Fresh-machine bootstrap for the zsolt-98/dotfiles chezmoi repo (private).
# Published as a public gist. Run it with sh -c (not curl | sh, the prompts need the terminal):
#   sh -c "$(curl -fsSL <gist raw url>)"
#
# 1. Installs git + gh (macOS: Homebrew first; Linux: dnf/apt, or a gh release binary without sudo)
# 2. gh auth login (browser), and gh as git's credential helper so the private repo clones
# 3. Installs chezmoi to ~/.local/bin and runs chezmoi init --apply (prompts: profile, name, email)
#
# Env: DOTFILES_REPO (default zsolt-98), DOTFILES_NO_SUDO=1, DOTFILES_NO_BREW=1 (passed on to the install scripts).
set -eu

REPO=${DOTFILES_REPO:-zsolt-98}
BIN="$HOME/.local/bin"
export PATH="$BIN:$PATH"

log()  { printf '\033[1;33m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;31m!!  %s\033[0m\n' "$*" >&2; }
have() { command -v "$1" >/dev/null 2>&1; }

if [ "$(id -u)" -eq 0 ]; then
  SUDO=""; CAN_SUDO=1
elif [ "${DOTFILES_NO_SUDO:-0}" != 1 ] && have sudo && sudo -v; then
  SUDO="sudo"; CAN_SUDO=1
else
  SUDO=""; CAN_SUDO=0
fi

# gh release binary into ~/.local/bin (Linux without sudo).
install_gh_binary() {
  case $(uname -m) in
    x86_64) arch=amd64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) warn "No gh binary for $(uname -m)"; exit 1 ;;
  esac
  tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' https://github.com/cli/cli/releases/latest)
  version=${tag##*/v}
  tmp=$(mktemp -d)
  curl -fsSL "https://github.com/cli/cli/releases/download/v$version/gh_${version}_linux_$arch.tar.gz" | tar -xz -C "$tmp"
  mkdir -p "$BIN"
  mv "$tmp/gh_${version}_linux_$arch/bin/gh" "$BIN/gh"
  rm -rf "$tmp"
}

# 1. git + gh
case $(uname -s) in
  Darwin)
    if [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
      log "Installing Homebrew (also installs the Xcode Command Line Tools)"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      if [ -x "$b" ]; then eval "$("$b" shellenv)"; break; fi
    done
    have gh || brew install gh
    ;;
  Linux)
    if ! have gh || ! have git; then
      if [ "$CAN_SUDO" = 1 ] && have dnf; then
        log "Installing git and gh (dnf)"
        $SUDO dnf install -y git gh
      elif [ "$CAN_SUDO" = 1 ] && have apt-get; then
        log "Installing git and gh (apt)"
        $SUDO apt-get update
        $SUDO env DEBIAN_FRONTEND=noninteractive apt-get install -y git gh curl ca-certificates
      else
        have git || warn "git missing and no sudo: chezmoi falls back to its built-in git"
        have gh || { log "Installing gh binary to $BIN"; install_gh_binary; }
      fi
    fi
    ;;
  *)
    warn "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

# 2. GitHub auth. The token stays in ~/.config/gh/hosts.yml, which the repo never tracks.
if ! gh auth status >/dev/null 2>&1; then
  log "GitHub login"
  gh auth login --hostname github.com --git-protocol https --web
fi
gh auth setup-git

# 3. chezmoi + dotfiles
if ! have chezmoi; then
  log "Installing chezmoi to $BIN"
  sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$BIN"
fi

log "chezmoi init --apply $REPO"
chezmoi init --apply "$REPO"

log "Done. Open a new terminal (or log out and in) for zsh and the new PATH."
