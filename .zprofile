# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Python.org installer binary
export PATH="/Library/Frameworks/Python.framework/Versions/3.13/bin:$PATH"

# Custom PATH additions
export PATH="/Applications/Postgres.app/Contents/Versions/18/bin:$PATH"  # Postgres.app
export PATH="/Users/vishudh/.antigravity/antigravity/bin:$PATH"  # Added by Antigravity
export PATH="/Users/vishudh/.antigravity-ide/antigravity-ide/bin:$PATH"  # Added by Antigravity IDE
# export PATH="$HOME/Library/Python/$(python3 -V | cut -d" " -f2 | cut -d. -f1-2)/bin:$PATH"  # pip --user scripts (dynamic version)
export PATH="$HOME/Library/Python/3.13/bin:$PATH"  # pip --user scripts
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
