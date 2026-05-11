#!/bin/bash

# ╔══════════════════════════════════════════╗
# ║         dotfiles install script          ║
# ╚══════════════════════════════════════════╝

DOTFILES="$HOME/dotfiles"
REPO="git@github.com:vishudhshah/dotfiles.git"

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

# ── install homebrew if missing ───────────────
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  info "Homebrew installed"
else
  info "Homebrew already installed"
fi

# ── install brew packages ─────────────────────
if command -v brew &>/dev/null; then
  echo "Installing Homebrew packages..."
  brew bundle --file="$DOTFILES/Brewfile"
  info "Packages installed"
else
  warn "Homebrew not found, skipping package install"
fi

# ── stow dotfiles ────────────────────────────
stow --dir="$DOTFILES" --target="$HOME" . && info "Dotfiles linked" || error "stow failed"

# ── update yazi plugins ───────────────────────
if command -v ya &>/dev/null; then
  ya pkg upgrade && info "Yazi plugins updated"
else
  warn "ya not found, skipping yazi plugin update"
fi

echo ""
info "Done. You may need to restart your shell: exec zsh"
