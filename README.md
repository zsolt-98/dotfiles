# dotfiles

Personal dev environment, managed with [chezmoi](https://chezmoi.io), for:

- **Fedora Sway** desktop
- **macOS** laptop

## New machine

The repo is private, so log in with gh first, then let chezmoi clone and apply.

1. Install gh (and git):

   ```sh
   sudo dnf install -y git gh                         # Fedora   ```

   macOS: install [Homebrew](https://brew.sh) first (it also installs the Xcode Command Line Tools), then `brew install gh`.

2. Log in to GitHub and let git use the gh token:

   ```sh
   gh auth login --web && gh auth setup-git
   ```

   No browser on the machine: open github.com/login/device on another device and enter the code shown.

3. Install chezmoi and apply the dotfiles:

   ```sh
   sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply zsolt-98
   ```

chezmoi asks once for:

- git name, email, signing key (empty for none)
- macOS only: apply keyboard defaults (key repeat, free Ctrl+arrows and Ctrl+Space)

Answers live in `~/.config/chezmoi/chezmoi.toml`, never in the repo.

Then open a new terminal (or log out and in) for zsh and the new PATH.
Without sudo: `DOTFILES_NO_SUDO=1`. Skip Homebrew: `DOTFILES_NO_BREW=1` (CLI tools from dnf instead; no lazygit or herdr).

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
| `20-packages` | before files, when a list changes | `packages/dnf.txt` (Fedora), `packages/Brewfile`, Nerd Font (Linux), podman machine (macOS) |
| `30-mise` | after files, when the mise config changes | node lts, pnpm, python 3.13 from `~/.config/mise/config.toml` |
| `40-claude` | once | Claude Code (official installer), caveman plugin |
| `45-herdr-plugins` | after files, when a manifest changes | `herdr plugin link` for `~/.config/herdr/plugins/resurrect` |
| `50-chsh` | once | zsh as login shell |
| `60-macos-defaults` | macOS, opt-in, on change | key repeat and system shortcuts |

List tag in `packages/dnf.txt`: `[nobrew]` installs only when Homebrew is missing.

## Theme

Monokai Pro Ristretto. Colors live once in `.chezmoidata/palette.toml` and feed alacritty, tmux, herdr and the zsh vi-mode cursor.

## herdr session restore

herdr restores layout and cwd on its own; Claude resumes through the herdr hook in `~/.claude/hooks`.
nvim and lazygit come back through the local `resurrect` plugin:

- zsh wrappers (only inside herdr) write `~/.local/state/herdr-resurrect/<pane>` while the command runs. A normal exit deletes it.
- On server start, the plugin relaunches each recorded command in its pane. Plain `nvim` reopens the persistence.nvim session for that directory.

Logs: `herdr plugin log`.

## Per-machine and secret values

Never commit them. Put them in untracked files, which the tracked configs source at the end:

- `~/.zshrc.local`, `~/.bashrc.local`
- `~/.gitconfig.local`

Never tracked: `~/.config/gh/hosts.yml` (gh token), `~/.kube`, Claude history/projects/memory.
