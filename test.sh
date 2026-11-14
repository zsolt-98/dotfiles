#!/bin/sh
# Test a headless install from this local source dir in throwaway podman containers.
# Runs as a non-root user with passwordless sudo (Homebrew refuses root), then checks the tools.
#
#   ./test.sh                    fedora and ubuntu
#   ./test.sh ubuntu             one distro
#   ./test.sh --no-brew ubuntu   dnf/apt fallback only (DOTFILES_NO_BREW=1)
#
# Images can be overridden: FEDORA_IMAGE, UBUNTU_IMAGE.
# Logs go to $TEST_LOGS (default /tmp/dotfiles-test-logs), outside the repo.
set -eu

SRC=$(cd "$(dirname "$0")" && pwd)
LOGS=${TEST_LOGS:-${TMPDIR:-/tmp}/dotfiles-test-logs}
FEDORA_IMAGE=${FEDORA_IMAGE:-registry.fedoraproject.org/fedora:44}
UBUNTU_IMAGE=${UBUNTU_IMAGE:-docker.io/library/ubuntu:26.04}

NO_BREW=0
distros=""
for arg in "$@"; do
  case $arg in
    --no-brew) NO_BREW=1 ;;
    fedora|ubuntu) distros="$distros $arg" ;;
    *) echo "unknown argument: $arg" >&2; exit 2 ;;
  esac
done
[ -n "$distros" ] || distros="fedora ubuntu"
mkdir -p "$LOGS"

# Root part: sudo, curl, a test user with passwordless sudo.
root_setup='
set -eu
if command -v dnf >/dev/null; then
  dnf install -y sudo curl git ca-certificates shadow-utils
else
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y sudo curl git ca-certificates
fi
useradd -m -s /bin/bash tester
echo "tester ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/tester
chmod 440 /etc/sudoers.d/tester
'

# User part: chezmoi from a copy of the source (no GitHub needed), answers given as flags.
user_setup='
set -eu
export PATH="$HOME/.local/bin:$PATH"
sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
cp -r /src "$HOME/.local/share/chezmoi"
chezmoi init --apply --no-tty \
  --promptChoice profile=headless \
  --promptString "name=Test User,email=test@example.com,signingkey="
'

# Checks, run in a fresh login zsh so the dotfiles are what sets PATH.
checks='
fail=0
for c in git nvim tmux fzf fd rg gh mise claude zsh; do
  if command -v "$c" >/dev/null; then echo "ok      $c"; else echo "MISSING $c"; fail=1; fi
done
if [ "${DOTFILES_NO_BREW:-0}" != 1 ]; then
  for c in lazygit herdr w3m; do
    if command -v "$c" >/dev/null; then echo "ok      $c"; else echo "MISSING $c"; fail=1; fi
  done
fi
for t in node pnpm python; do
  if mise which "$t" >/dev/null 2>&1; then echo "ok      mise $t"; else echo "MISSING mise $t"; fail=1; fi
done
[ -d "$HOME/.oh-my-zsh" ] && echo "ok      oh-my-zsh" || { echo "MISSING oh-my-zsh"; fail=1; }
[ -d "$HOME/.tmux/plugins/tpm" ] && echo "ok      tpm" || { echo "MISSING tpm"; fail=1; }
[ ! -e "$HOME/.config/alacritty" ] && echo "ok      no alacritty config (headless)" || { echo "BAD     alacritty config on headless"; fail=1; }
case $(getent passwd tester | cut -d: -f7) in */zsh) echo "ok      login shell zsh" ;; *) echo "BAD     login shell"; fail=1 ;; esac
exit $fail
'

summary=""
for d in $distros; do
  case $d in
    fedora) image=$FEDORA_IMAGE ;;
    ubuntu) image=$UBUNTU_IMAGE ;;
  esac
  name="dotfiles-test-$d"
  log="$LOGS/$d.log"
  echo "==> $d ($image), log: $log"
  podman rm -f "$name" >/dev/null 2>&1 || true
  podman run -d --name "$name" -v "$SRC:/src:ro,Z" "$image" sleep infinity >/dev/null

  result=FAIL
  if podman exec "$name" sh -c "$root_setup" >"$log" 2>&1 &&
     podman exec -u tester -e DOTFILES_NO_BREW="$NO_BREW" "$name" sh -c "$user_setup" >>"$log" 2>&1 &&
     podman exec -u tester -e DOTFILES_NO_BREW="$NO_BREW" -w /home/tester "$name" zsh -lic "$checks" >"$log.checks" 2>&1; then
    result=PASS
  fi
  # Show the check results (absent when setup failed earlier; see the log).
  if [ -f "$log.checks" ]; then cat "$log.checks"; cat "$log.checks" >>"$log"; rm -f "$log.checks"; fi
  summary="$summary
$result $d"
  podman rm -f "$name" >/dev/null
done

echo "==> Summary (logs in $LOGS)$summary"
case $summary in *FAIL*) exit 1 ;; esac
