# dotfiles

Personal dev environment for Linux (Fedora, Debian, Mint) and macOS, managed with [chezmoi](https://chezmoi.io).

## New machine

```sh
sh -c "$(curl -fsSL <bootstrap gist raw url>)"
```

`bootstrap.sh` installs git and gh, logs in to GitHub, installs chezmoi, then runs `chezmoi init --apply zsolt-98`.
chezmoi asks once for:

- **profile**: `desktop` (alacritty, Nerd Font, sway/rofi on Linux) or `headless` (servers)
- git name, email, signing key (empty for none)
- macOS only: apply keyboard defaults (key repeat, free Ctrl+arrows and Ctrl+Space)

Answers live in `~/.config/chezmoi/chezmoi.toml`, never in the repo.

Without sudo: `DOTFILES_NO_SUDO=1`. Skip Homebrew: `DOTFILES_NO_BREW=1` (CLI tools from dnf/apt instead; no lazygit or herdr).

## Day to day

```sh
chezmoi update          # pull and apply
chezmoi edit ~/.zshrc   # edit the source, then: chezmoi apply
chezmoi add ~/.foo      # start tracking a file (auto-commits)
chezmoi diff            # what apply would change
chezmoi cd              # shell in the source dir; git push from there
```

## What installs what

Scripts in `.chezmoiscripts/` run on `chezmoi apply`:

| Script | When | Does |
|---|---|---|
| `10-toolchain` | before files, on change | Xcode CLT (macOS) or `@development-tools` / `build-essential`, then Homebrew |
| `20-packages` | before files, when a list changes | `packages/dnf.txt` or `packages/apt.txt`, `packages/Brewfile`, Nerd Font (Linux desktop), podman machine (macOS) |
| `30-mise` | after files, when the mise config changes | node lts, pnpm, python 3.13 from `~/.config/mise/config.toml` |
| `40-claude` | once | Claude Code (official installer) |
| `50-chsh` | once | zsh as login shell |
| `60-macos-defaults` | macOS, opt-in, on change | key repeat and system shortcuts |

List tags in `packages/*.txt`: `[desktop]` installs only on the desktop profile, `[nobrew]` only when Homebrew is missing.

## Theme

Monokai Pro Ristretto. Colors live once in `.chezmoidata/palette.toml` and feed alacritty, tmux, herdr and the zsh vi-mode cursor.

## Per-machine and secret values

Never commit them. Put them in untracked files, which the tracked configs source at the end:

- `~/.zshrc.local`, `~/.bashrc.local`
- `~/.gitconfig.local`

Never tracked: `~/.config/gh/hosts.yml` (gh token), `~/.kube`, Claude history/projects/memory.

## Testing

```sh
./test.sh                 # headless install in podman: fedora, debian, mint
./test.sh --no-brew mint  # dnf/apt fallback
```

macOS is tested by hand.
