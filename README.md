# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
~/dotfiles/
├── .zshrc
├── .zprofile
├── .gitconfig
├── .ssh/config
├── .env.example          # template; local .env is Git-ignored
├── .gitignore
├── .stow-local-ignore
├── Brewfile
├── install.sh
├── .config/              # one subdirectory per app
└── .oh-my-zsh/
    └── custom/           # aliases.zsh, functions.zsh
```

Files live here and are symlinked to `$HOME` via `stow`.
Editing the file anywhere edits the same underlying file.

---

## New machine setup

### 1. Prerequisites

- macOS with Xcode CLI tools: `xcode-select --install`
- An SSH key added to GitHub (so git clone works over SSH)

This is a personal macOS setup. Review `.ssh/config`, `.zprofile`, and app
configs for machine-specific paths before installing on another account.
`.zprofile` currently expects Apple Silicon Homebrew at `/opt/homebrew`.

### 2. Run the install script

```bash
git clone git@github.com:vishudhshah/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

The script will:

- Find Homebrew on PATH or at either macOS prefix, install it if missing, and initialize its shell environment
- Install all packages listed in `Brewfile` via `brew bundle`
- Install missing Oh My Zsh, Powerlevel10k, and the custom plugins `you-should-use`, `fzf-tab`, `fast-syntax-highlighting`, and `zsh-sage`
- Preserve existing shell dependencies; stop with a repair message if an installation is incomplete
- Back up conflicting files and unmanaged symlinks (including broken links) to `~/.dotfiles-backup-<timestamp>`
- Symlink all configs via `stow .`
- Upgrade Yazi plugins with `ya pkg upgrade` when available (this can update files in the repo)

Required failures stop the script with a nonzero exit status. A failed optional
Yazi upgrade produces a warning. Oh My Zsh installation preserves an existing
`.zshrc` and does not change the default shell or launch a shell during setup.
The framework, plugins, and theme live in `~/.oh-my-zsh`; this repo supplies
the custom aliases and functions. Plugins/themes use `ZSH_CUSTOM` if set.

### 3. After the script

Open a new terminal or restart as a login shell to load `.zprofile` and `.zshrc`:
```bash
exec zsh -l
```

Run `p10k configure` to customize the prompt. The generated `~/.p10k.zsh`
is machine-local and is not included in this repo.

#### Neovim

Open Neovim and let Lazy install plugins, then run `:TSUpdate` for parsers.
`tree-sitter-cli` is supplied by Homebrew. Use `:Lazy sync` after changing
the plugin configuration.

Language servers and formatters are installed through [Mason](https://github.com/mason-org/mason.nvim),
not the Brewfile. On a new machine, run:

```vim
:MasonInstall clangd css-lsp html-lsp json-lsp pyrefly texlab typescript-language-server stylua prettier ruff
```

Use `:Mason` to inspect installations and `:checkhealth mason` to diagnose
missing prerequisites. VimTeX also needs a separately installed TeX distribution
providing `latexmk` and `lualatex` on PATH. Skim is installed by the Brewfile.

#### Spotify notifications

Create the local config from the template if `app.toml` does not exist:

```bash
cp -n ~/.config/spotify-player/app.toml.example ~/.config/spotify-player/app.toml
```

Set your client ID and redirect settings, then authenticate in `spotify_player`.
`app.toml` is Git-ignored. For the custom track-change banners, add this setting
at the top level, before any TOML table headers, using your actual absolute path:

```toml
player_event_hook_command = { command = "python3", args = ["/Users/YOUR_USERNAME/dotfiles/.config/spotify-player/hooks/notify.py"] }
```

The [event hook](https://github.com/aome510/spotify-player/blob/master/docs/config.md#player-event-hook-command)
uses Python 3, `spotify_player`, and `terminal-notifier` (included in the Brewfile).
Allow notifications for terminal-notifier in macOS settings if banners do not appear.

#### Environment variables

If needed, copy `.env.example` to `.env` in the repo, fill in local values,
and rerun `stow .`. `.env` is Git-ignored but Stow links it to `~/.env`,
which `.zshrc` sources. `.env.example` stays in the repo and is excluded from Stow.

---

## Keeping dotfiles up to date

Since the files in `~` are symlinks into this repo, any edits you make are
already reflected here. Just commit and push periodically.

### Everyday workflow

```bash
cd ~/dotfiles
git status
git add .
git commit -m "update nvim config"
git push
```

### Adding a new app

```bash
# 1. move the config into dotfiles
mv ~/.config/someapp ~/dotfiles/.config/someapp

# 2. re-run stow to create the symlink
cd ~/dotfiles && stow .

# 3. commit
git add . && git commit -m "add someapp config"
```

### Removing an app

```bash
# 1. unstow everything while the app dir still exists (removes its symlink)
cd ~/dotfiles && stow -D .

# 2. delete the app's config from dotfiles
rm -rf ~/dotfiles/.config/someapp

# 3. re-link everything remaining
stow .
```

> [!IMPORTANT]
> Delete from dotfiles **after** running `stow -D .`, not before.
> If you delete first, the symlink at `~/.config/someapp` becomes broken and stow won't know to clean it up — it only removes symlinks for paths it currently sees in the dotfiles directory.

### Pulling updates on an existing machine

```bash
cd ~/dotfiles && git pull
```

Edits to files already linked are live immediately. When updates add config
files or directories, rerun `stow .`; new paths under existing real directories
may need new links. Unstow before removing paths, as described above.

When `Brewfile` changes, install its packages with:

```bash
brew bundle --file="$HOME/dotfiles/Brewfile"
```

Keep taps, formulae, and casks alphabetized within their sections. Use Mason
for editor tools, `:Lazy sync` for Neovim plugins, and `ya pkg upgrade` for Yazi
plugins. Review `git diff` after plugin upgrades before committing.
