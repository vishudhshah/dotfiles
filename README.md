# dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
~/dotfiles/
├── .zshrc
├── .gitconfig
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

### 2. Run the install script

```bash
git clone git@github.com:vishudhshah/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

The script will:
- Install Homebrew if not already present
- Install all packages listed in `Brewfile` via `brew bundle`
- Back up any files that would conflict with stow to `~/.dotfiles-backup-<timestamp>`
- Symlink all configs via `stow .`

### 3. After the script

Restart your shell:
```bash
exec zsh
```

> [!NOTE]
> `tree-sitter-cli` is installed by Homebrew (it's in the Brewfile) and is required by the Neovim config to compile treesitter parsers.
>
> After installing Neovim, open it and run `:Lazy update` then `:TSUpdate` to install plugins and parsers.

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

No re-linking needed — symlinks are permanent, so pulled changes are live immediately.
