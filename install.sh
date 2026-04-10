#!/bin/bash

# ╔══════════════════════════════════════════╗
# ║         dotfiles install script          ║
# ╚══════════════════════════════════════════╝

DOTFILES="$HOME/dotfiles"
REPO="git@github.com:yourname/dotfiles.git"  # <-- update this

# ── colors ───────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; }

# ── clone repo if not present ────────────────
if [ ! -d "$DOTFILES" ]; then
  echo "Cloning dotfiles..."
  git clone "$REPO" "$DOTFILES" || { error "git clone failed"; exit 1; }
  info "Cloned dotfiles to $DOTFILES"
else
  warn "~/dotfiles already exists, skipping clone"
fi

# ── helper: create symlink safely ────────────
link() {
  local src="$1"   # file in ~/dotfiles
  local dst="$2"   # where system expects it

  # skip if source doesn't exist in dotfiles
  if [ ! -e "$src" ]; then
    warn "Source not found, skipping: $src"
    return
  fi

  # backup if real file already exists (not a symlink)
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backing up existing $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi

  ln -sf "$src" "$dst" && info "Linked $dst" || error "Failed to link $dst"
}

# ── create symlinks ───────────────────────────
mkdir -p ~/.config

# add more lines as dotfiles grow
link "$DOTFILES/.zshrc"                     "$HOME/.zshrc"
link "$DOTFILES/.config/btop"               "$HOME/.config/btop"
link "$DOTFILES/.config/cheat"              "$HOME/.config/cheat"
link "$DOTFILES/.config/fastfetch"          "$HOME/.config/fastfetch"
link "$DOTFILES/.config/ghostty"            "$HOME/.config/ghostty"
link "$DOTFILES/.config/ghostty-ai-themes"  "$HOME/.config/ghostty-ai-themes"
link "$DOTFILES/.config/nvim"               "$HOME/.config/nvim"
link "$DOTFILES/.config/sketchybar"         "$HOME/.config/sketchybar"
link "$DOTFILES/.config/sketchybar_custom"  "$HOME/.config/sketchybar_custom"
link "$DOTFILES/.config/yazi"               "$HOME/.config/yazi"

# ── install homebrew if missing ───────────────
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  info "Homebrew installed"
else
  info "Homebrew already installed"
fi

echo ""
info "Done. You may need to restart your shell: exec zsh"
