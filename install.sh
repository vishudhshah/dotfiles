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
die()     { error "$1"; exit 1; }

# ── clone repo if not present ────────────────
if [ ! -d "$DOTFILES" ]; then
  echo "Cloning dotfiles..."
  git clone "$REPO" "$DOTFILES" || { error "git clone failed"; exit 1; }
  info "Cloned dotfiles to $DOTFILES"
else
  warn "~/dotfiles already exists, skipping clone"
fi

# ── install homebrew if missing ───────────────
find_brew() {
  command -v brew && return 0
  local candidate
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$candidate" ]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
  return 1
}

if ! brew_bin=$(find_brew); then
  echo "Installing Homebrew..."
  homebrew_installer=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh) || die "Homebrew installer download failed"
  /bin/bash -c "$homebrew_installer" || die "Homebrew installation failed"
  brew_bin=$(find_brew) || die "Homebrew installed but its executable could not be found"
  info "Homebrew installed"
else
  info "Homebrew already installed"
fi

# The installer runs in a child shell; initialize this shell explicitly.
homebrew_env=$("$brew_bin" shellenv bash) || die "Could not initialize Homebrew environment"
eval "$homebrew_env" || die "Could not apply Homebrew environment"

# ── install brew packages ─────────────────────
if command -v brew &>/dev/null; then
  echo "Installing Homebrew packages..."
  brew bundle --file="$DOTFILES/Brewfile" || die "Homebrew package installation failed"
  info "Packages installed"
else
  die "Homebrew not found on PATH; cannot install packages"
fi

# ── stow dotfiles ────────────────────────────
# Back up any real files/dirs that would conflict with stow-managed symlinks
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
command -v stow &>/dev/null || die "stow not found on PATH"
conflict_status=0
conflict_output=$(stow --dir="$DOTFILES" --target="$HOME" -n . 2>&1) || conflict_status=$?
conflicts=$(echo "$conflict_output" | grep "existing target is neither a link" | sed 's/.*: //')

if [ "$conflict_status" -ne 0 ] && [ -z "$conflicts" ]; then
  printf '%s\n' "$conflict_output" >&2
  die "Stow conflict check failed"
fi

if [ -n "$conflicts" ]; then
  mkdir -p "$BACKUP" || die "Could not create backup directory: $BACKUP"
  warn "Conflicting files found — backing up to $BACKUP"
  while IFS= read -r file; do
    src="$HOME/$file"
    dst="$BACKUP/$file"
    if [ -e "$src" ]; then
      mkdir -p "$(dirname "$dst")" || die "Could not create backup directory for ~/$file"
      mv "$src" "$dst" || die "Could not back up ~/$file"
      info "Backed up ~/$file"
    else
      die "Conflicting file is missing or inaccessible: ~/$file"
    fi
  done <<< "$conflicts"
fi

stow --dir="$DOTFILES" --target="$HOME" . || die "stow failed"
info "Dotfiles linked"

# ── update yazi plugins ───────────────────────
if command -v ya &>/dev/null; then
  if ya pkg upgrade; then
    info "Yazi plugins updated"
  else
    warn "Yazi plugin update failed; dotfiles installation completed"
  fi
else
  warn "ya not found, skipping yazi plugin update"
fi

echo ""
info "Done. You may need to restart your shell: exec zsh"
