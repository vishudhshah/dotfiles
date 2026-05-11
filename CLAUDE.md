# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles managed as symlinks. All files live here and are symlinked to their expected system locations via `install.sh`. Editing a file anywhere (in `~/dotfiles` or the symlinked path) edits the same underlying file.

## Setup

```bash
cd ~/dotfiles && ./install.sh
```

The script symlinks configs, installs Homebrew if missing, and runs `brew bundle`. After running, restart the shell with `exec zsh`.

To add a new app's config:
1. `mv ~/.config/someapp ~/dotfiles/.config/someapp`
2. `ln -s ~/dotfiles/.config/someapp ~/.config/someapp`
3. Add a `link` line to `install.sh`

## Structure

- `.zshrc` — shell config; Oh My Zsh with powerlevel10k theme
- `.gitconfig` — git identity and settings
- `oh-my-zsh/custom/aliases.zsh` — shell aliases (symlinked to `~/.oh-my-zsh/custom/`)
- `oh-my-zsh/custom/functions.zsh` — shell functions (symlinked to `~/.oh-my-zsh/custom/`)
- `Brewfile` — all Homebrew packages and casks
- `.config/nvim/` — Neovim config (NvChad v2.5 base, lazy.nvim plugin manager)
- `.config/ghostty/` — Ghostty terminal config
- `.config/sketchybar/` — macOS menu bar replacement
- `.config/lazygit/` — lazygit TUI config
- `.config/yazi/` — yazi file manager config

## Neovim architecture

Built on [NvChad v2.5](https://github.com/NvChad/NvChad) with lazy.nvim. Entry point is `init.lua`.

- `lua/configs/` — configuration for LSP (`lspconfig.lua`) and formatting (`conform.lua`)
- `lua/plugins/` — one file per plugin override/addition; each file returns a lazy.nvim spec table
- `lua/mappings.lua` — custom keymaps on top of NvChad defaults
- `lua/options.lua` — vim options
- `lua/autocmds.lua` — autocommands
- `lua/chadrc.lua` — NvChad theme/UI settings
- `snippets/` — LuaSnip snippets per filetype

LSP servers: `html`, `cssls`, `ts_ls`, `clangd`, `texlab`, `jsonls`, `basedpyright` (type checking disabled).

After cloning to a new machine, open Neovim and run `:Lazy update` then `:TSUpdate`.

## Key aliases and functions

| Alias/Function | Expands to |
|---|---|
| `ls` / `lsa` | `eza --icons --tree --level=1` |
| `cat` / `catp` | `bat` (with/without paging) |
| `vim` / `vi` | `nvim` |
| `cd` | `zoxide` |
| `y` | yazi with cwd-change on exit |
| `gacp <msg>` | `git add . && git commit -m <msg> && git push` |
| `whisper <file>` | transcribe video to SRT via whisper.cpp |
| `cheat-add` | add entry to F1 cheat sheet |

## Commit style

Short imperative messages, e.g. `ghostty splits + mini.anim speed`. No Co-Authored-By lines.
