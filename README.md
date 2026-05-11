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
- Install stow and symlink all configs via `stow .`
- Install all packages listed in `Brewfile` via `brew bundle`

### 3. After the script

Restart your shell:
```bash
exec zsh
```

> [!NOTE]
> `tree-sitter` (the CLI) is required by the Neovim config to compile treesitter parsers.
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

### Pulling updates on an existing machine

```bash
cd ~/dotfiles && git pull
```

No re-linking needed — symlinks are permanent, so pulled changes are live immediately.
