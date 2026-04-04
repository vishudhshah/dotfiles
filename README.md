# dotfiles

Personal configuration files for zsh, Neovim, Ghostty, Yazi, and more.

## Structure

```
~/dotfiles/
  .zshrc
  .config/
    nvim/
    ghostty/
    yazi/
    btop/
  install.sh
  README.md
```

Files live here and are symlinked to where the system expects them. Editing
the file anywhere (e.g. `~/.zshrc` or `~/dotfiles/.zshrc`) edits the same
underlying file.

---

## New machine setup

### 1. Prerequisites

- macOS with Xcode CLI tools: `xcode-select --install`
- An SSH key added to GitHub (so git clone works over SSH)

### 2. Run the install script

```bash
git clone git@github.com:yourname/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

The script will:
- Symlink all config files to their expected locations
- Back up any existing files as `.bak` before overwriting
- Install Homebrew if not already present

### 3. After the script

Restart your shell:
```bash
exec zsh
```

Then reinstall your tools as needed via Homebrew:

```bash
brew install neovim ghostty yazi tree-sitter-cli
```

> `tree-sitter` (the CLI) is required by the Neovim config to compile treesitter parsers.

After installing Neovim, open it and run `:Lazy update` then `:TSUpdate` to install plugins and parsers.

---

## Keeping dotfiles up to date

Since the files in `~` are symlinks into this repo, any edits you make are
already reflected here. You just need to commit and push periodically.

### Everyday workflow

```bash
cd ~/dotfiles
git status              # see what changed
git add .
git commit -m "update nvim config"
git push
```

### Adding a new app

```bash
# 1. move the config into dotfiles
mv ~/.config/someapp ~/dotfiles/.config/someapp

# 2. create the symlink
ln -s ~/dotfiles/.config/someapp ~/.config/someapp

# 3. add a link line to install.sh for future machines
echo 'link "$DOTFILES/.config/someapp" "$HOME/.config/someapp"' >> ~/dotfiles/install.sh

# 4. commit
cd ~/dotfiles && git add . && git commit -m "add someapp config"
```

### Pulling updates on an existing machine

```bash
cd ~/dotfiles && git pull
```

No re-linking needed — symlinks are permanent, so pulled changes are live immediately.
