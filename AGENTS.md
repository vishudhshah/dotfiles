# AGENTS.md

Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Files live in this repo and are symlinked to `$HOME` (`stow .`), so editing a file here and editing its `~/` path are the same file. There is no build system or test suite — "verification" means stow links are healthy and shell/Lua configs load without errors.

## Layout

- `.zshrc`, `.zprofile`, `.gitconfig`, `.ssh/config` — top-level stow packages linked to `$HOME`
- `.oh-my-zsh/custom/` — only `aliases.zsh` + `functions.zsh` are ours; the OMZ framework at `~/.oh-my-zsh` is a real (unmanaged) directory, not part of the repo
- `.config/<app>/` — one directory per app: `nvim/`, `ghostty/`, `yazi/`, `lazygit/`, `tmux/`, `spotify-player/`, `btop/`, `fastfetch/`, `cheat/`, `AutoRaise/`
- `Brewfile`, `install.sh`, `README.md`, `TODO.md`, `.env.example` — repo meta, excluded from stowing via `.stow-local-ignore`
- `Library/texmf/tex/latex/local/evan.sty` — linked into the user's TeX tree

## Commands

```bash
cd ~/dotfiles && stow -n -v .                                  # dry-run: list stow conflicts (safe, run first)
cd ~/dotfiles && stow .                                        # (re)link everything after adding new paths
cd ~/dotfiles && stow -D .                                     # unlink (REQUIRED before deleting any config dir)
./install.sh                                                   # new-machine setup: brew bundle, OMZ + plugins, stow
brew bundle --file="$HOME/dotfiles/Brewfile"                   # apply Brewfile changes
ya pkg upgrade                                                 # update yazi plugins (can modify repo files — review diff)
```

Brewfile changes, plugin upgrades, and any edits that add/remove stowed paths should end with `git status` / `git diff` review before commit. Commit subjects: short one-line summary (e.g. `update nvim config`), no body.

## Neovim (`.config/nvim/`)

NvChad v2.5 base + lazy.nvim. `init.lua` is the entry point; `lua/plugins/` has one file per plugin, each returning a lazy.nvim spec table; `lua/mappings.lua` and `lua/options.lua` hold keymaps/options; `lua/configs/` holds `lspconfig.lua` and `conform.lua`. Plugin versions are pinned in `lazy-lock.json` — don't hand-edit it; use `:Lazy sync` inside Neovim after changing plugin config. Lua style: stylua with `.stylua.toml` in that dir (2-space, 120 cols, double quotes); stylua comes from Mason, not PATH.

## Pitfalls

- **Symlinks, not copies**: before troubleshooting "my edit didn't apply", confirm the target is a link (`readlink ~/.zshrc`) and identical to the repo copy. A stray real file at `~/` silently diverges from the repo.
- **Deleting configs**: always `stow -D .` BEFORE `rm -rf`-ing an app dir from the repo, otherwise the `~/` symlink is left broken and stow won't clean it up.
- **`stow --adopt` is destructive**: it pulls the live `~/` file's content over the repo copy. Confirm which side holds the wanted content first.
- **Secrets are gitignored but stowed**: `.env` → `~/.env` (sourced by `.zshrc`) and `.config/spotify-player/app.toml` (has client IDs) must never be committed. `app.toml.example` and `.env.example` are the tracked templates. Whisper models (`*.bin`) are also ignored.
- **tmux plugins** under `.config/tmux/plugins/` are vendored upstream clones tracked in the repo — never edit their internals; update the plugin, not the files.
- Machine-local files that must NOT be added to the repo: `~/.p10k.zsh`, `nvim.log`.
