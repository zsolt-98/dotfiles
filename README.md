# dotfiles

Personal dev environment, managed with [chezmoi](https://chezmoi.io), for:

- **Fedora Sway** desktop
- **macOS** laptop

## New machine

Log in with gh first (git pushes from the source dir use its token), then let chezmoi clone and apply.

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
- macOS only: overwrite macOS keyboard defaults (key repeat, free Ctrl+arrows and Ctrl+Space)

Answers live in `~/.config/chezmoi/chezmoi.toml`. The repo holds only the prompt defaults.
To change an answer later, re-ask all prompts (current answers are the defaults):

```sh
chezmoi init --prompt && chezmoi apply
```

Keyboard defaults: answering `n` after an earlier `y` reverts them (key repeat back to the macOS setting, Ctrl+arrow and Ctrl+Space shortcuts back on). A Mac that never had `y` is left alone. Log out and in afterwards.

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
| `60-macos-defaults` | macOS, opt-in, on change | key repeat and system shortcuts; reverts them when the answer flips to `n` |

List tag in `packages/dnf.txt`: `[nobrew]` installs only when Homebrew is missing.

## Devcontainer

Any devcontainer gets this environment through [DevPod](https://devpod.sh)'s dotfiles option. One-time host setup: DevPod forwards the SSH agent, git and docker credentials and git SSH signing into every workspace by default, so turn those off, along with telemetry. On podman without the `podman-docker` shim, add the provider with `-o DOCKER_PATH=podman`.

```sh
devpod context set-options -o SSH_AGENT_FORWARDING=false -o SSH_ADD_PRIVATE_KEYS=false \
  -o SSH_INJECT_GIT_CREDENTIALS=false -o SSH_INJECT_DOCKER_CREDENTIALS=false \
  -o GIT_SSH_SIGNATURE_FORWARDING=false -o TELEMETRY=false \
  -o DOTFILES_URL=https://github.com/zsolt-98/dotfiles \
  -o SSH_CONFIG_PATH="$HOME/.devpod/ssh_config"
devpod ide use none
devpod provider add docker
```

Per project:

```sh
devpod up .
devpod ssh .
```

`SSH_CONFIG_PATH` keeps the workspace SSH entries, which always set `ForwardAgent yes`, out of `~/.ssh/config`. Do not skip the entry with `--configure-ssh=false`: DevPod reads the container user from it and falls back to root.

DevPod clones this repo to `~/dotfiles` inside the container and runs `install.sh`. That script installs chezmoi and applies without prompts: git name and email come from the defaults in `.chezmoi.toml.tmpl`, and `--force` replaces the image's own `~/.zshrc`. Rebuilds run it again from scratch, so mount volumes for anything that should survive one (the Claude config, `/home/linuxbrew`).

Inside a container (Docker's `/.dockerenv` or podman's `/run/.containerenv`):

- The image provides system packages and the toolchain. `10-toolchain` and `20-packages` skip dnf and the Nerd Font. Homebrew, mise and Claude Code install as usual.
- No sway, rofi or alacritty config.
- Claude Code starts in auto permission mode.
- zsh shows the hostname on the right of the prompt.
- nvim yanks to the host clipboard over OSC 52. Paste host text with the terminal's paste key.

## Theme

Monokai Pro Ristretto. Colors live once in `.chezmoidata/palette.toml` and feed alacritty (Linux), ghostty (macOS), tmux, herdr and the zsh vi-mode cursor.

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
