#!/bin/sh
# Devcontainer entry point. `devcontainer up --dotfiles-repository https://github.com/zsolt-98/dotfiles`
# clones this repo to ~/dotfiles and runs this script. Applies without prompts: answers come from the
# defaults in .chezmoi.toml.tmpl, and --force overwrites the image's own ~/.zshrc and friends.
set -eu

if command -v chezmoi >/dev/null 2>&1; then
  chezmoi=chezmoi
else
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  chezmoi="$HOME/.local/bin/chezmoi"
fi

source_dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
exec "$chezmoi" init --apply --force --promptDefaults --source="$source_dir"
