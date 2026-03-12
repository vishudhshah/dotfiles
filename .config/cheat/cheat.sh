#!/usr/bin/env zsh
# cheat.sh — fuzzy cheat sheet for neovim / nvchad / yazi
# deps: fzf (brew install fzf)
# keybindings:
#   ctrl-t  — cycle tool filter   (All → Neovim → NvChad → Yazi)
#   ctrl-g  — cycle category filter
#   ctrl-c / esc — close

# ─── color codes (Material Vibrant) ───
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

C_NVIM='\033[38;2;119;233;143m'     # custom green     #77e98f
C_NVCHAD='\033[38;2;24;255;255m'   # MD Cyan A400     #18ffff
C_YAZI='\033[38;2;255;234;0m'      # MD Yellow A400   #ffea00
C_CAT='\033[38;2;234;128;252m'     # MD Purple A200   #ea80fc
C_KEY='\033[38;2;232;234;246m'     # MD Indigo 50     #e8eaf6
C_DESC='\033[38;2;144;164;174m'    # MD Blue Grey 300 #90a4ae

# ─── data: TOOL | CATEGORY | KEYS | DESCRIPTION ───
COMMANDS=(
  # ─── Neovim › Modes ───
  "Neovim|Modes|i / a|Insert before / after cursor"
  "Neovim|Modes|I / A|Insert at line start / end"
  "Neovim|Modes|o / O|New line below / above, insert"
  "Neovim|Modes|v / V|Visual char / line mode"
  "Neovim|Modes|Ctrl+v|Visual block mode"
  "Neovim|Modes|R|Replace mode (overwrite)"
  "Neovim|Modes|Esc / Ctrl+[|Return to Normal mode"

  # ─── Neovim › Navigation ───
  "Neovim|Navigation|h j k l|Move left / down / up / right"
  "Neovim|Navigation|w / b|Next / prev word start"
  "Neovim|Navigation|e / ge|End of next / prev word"
  "Neovim|Navigation|W / B / E|Same, WORD (whitespace-delimited)"
  "Neovim|Navigation|0 / ^|Col 0 / first non-blank char"
  "Neovim|Navigation|\$|End of line"
  "Neovim|Navigation|gg / G|First / last line"
  "Neovim|Navigation|:{n} / {n}G|Go to line n"
  "Neovim|Navigation|Ctrl+d / Ctrl+u|Scroll half-page down / up"
  "Neovim|Navigation|Ctrl+f / Ctrl+b|Scroll full page down / up"
  "Neovim|Navigation|zz / zt / zb|Center / top / bottom cursor line"
  "Neovim|Navigation|{ / }|Jump prev / next paragraph"
  "Neovim|Navigation|%|Jump to matching bracket"
  "Neovim|Navigation|Ctrl+o / Ctrl+i|Jump back / forward in jumplist"
  "Neovim|Navigation|''|Jump to last cursor position"
  "Neovim|Navigation|H / M / L|Screen top / middle / bottom"

  # ─── Neovim › Motions (f/t) ───
  "Neovim|Motions|f{c} / F{c}|Jump to next / prev {c} on line"
  "Neovim|Motions|t{c} / T{c}|Jump before next / prev {c} on line"
  "Neovim|Motions|; / ,|Repeat f/t forward / backward"
  "Neovim|Motions|*|Search word under cursor (forward)"
  "Neovim|Motions|#|Search word under cursor (backward)"

  # ─── Neovim › Text Objects ───
  "Neovim|Text Objects|iw / aw|Inner word / around word (with space)"
  "Neovim|Text Objects|is / as|Inner sentence / around sentence"
  "Neovim|Text Objects|ip / ap|Inner paragraph / around paragraph"
  "Neovim|Text Objects|i( / a(|Inside / around parentheses"
  "Neovim|Text Objects|i[ / a[|Inside / around brackets"
  "Neovim|Text Objects|i{ / a{|Inside / around braces"
  "Neovim|Text Objects|i\" / a\"|Inside / around double quotes"
  "Neovim|Text Objects|i' / a'|Inside / around single quotes"
  "Neovim|Text Objects|i\` / a\`|Inside / around backticks"
  "Neovim|Text Objects|it / at|Inside / around HTML/XML tag"
  "Neovim|Text Objects|[operator]+[text obj]|e.g. ci(  di\"  ya{  vi'"

  # ─── Neovim › Editing ───
  "Neovim|Editing|dd / D|Delete line / to end of line"
  "Neovim|Editing|cc / C|Change line / to end of line"
  "Neovim|Editing|x / X|Delete char under / before cursor"
  "Neovim|Editing|r{c}|Replace single char with {c}"
  "Neovim|Editing|s / S|Substitute char / whole line"
  "Neovim|Editing|J|Join line below to current"
  "Neovim|Editing|~ / g~{motion}|Toggle case (char / motion)"
  "Neovim|Editing|gu{motion} / gU{motion}|Lowercase / uppercase motion"
  "Neovim|Editing|>> / <<|Indent / de-indent line"
  "Neovim|Editing|=G|Auto-indent to end of file"
  "Neovim|Editing|u / Ctrl+r|Undo / redo"
  "Neovim|Editing|.|Repeat last change"

  # ─── Neovim › Copy & Paste ───
  "Neovim|Copy & Paste|yy / Y|Yank current line"
  "Neovim|Copy & Paste|yw / yiw|Yank word / inner word"
  "Neovim|Copy & Paste|y\$|Yank to end of line"
  "Neovim|Copy & Paste|y{motion}|Yank with motion  (e.g. y3j)"
  "Neovim|Copy & Paste|p / P|Paste after / before cursor"
  "Neovim|Copy & Paste|\"{r}y / \"{r}p|Yank / paste to/from register {r}"
  "Neovim|Copy & Paste|\"+y / \"+p|Yank / paste system clipboard"
  "Neovim|Copy & Paste|:reg|Show all registers"

  # ─── Neovim › Search & Replace ───
  "Neovim|Search & Replace|/{pattern}|Search forward"
  "Neovim|Search & Replace|?{pattern}|Search backward"
  "Neovim|Search & Replace|n / N|Next / prev match"
  "Neovim|Search & Replace|:s/old/new/|Replace first on line"
  "Neovim|Search & Replace|:s/old/new/g|Replace all on line"
  "Neovim|Search & Replace|:%s/old/new/g|Replace all in file"
  "Neovim|Search & Replace|:%s/old/new/gc|Replace all with confirmation"
  "Neovim|Search & Replace|:noh|Clear search highlight"

  # ─── Neovim › Files & Buffers ───
  "Neovim|Files & Buffers|:w / :w {name}|Save / save as"
  "Neovim|Files & Buffers|:q / :q!|Quit / force quit"
  "Neovim|Files & Buffers|:wq / ZZ|Save and quit"
  "Neovim|Files & Buffers|:e {file}|Open file"
  "Neovim|Files & Buffers|:bn / :bp|Next / prev buffer"
  "Neovim|Files & Buffers|:bd|Close buffer"
  "Neovim|Files & Buffers|:ls|List open buffers"
  "Neovim|Files & Buffers|Ctrl+^|Switch to alternate buffer"
  "Neovim|Files & Buffers|gf|Open file under cursor"
  "Neovim|Files & Buffers|ga|Show char info (decimal, hex)"

  # ─── Neovim › Windows & Splits ───
  "Neovim|Windows & Splits|:sp / :vsp|Horizontal / vertical split"
  "Neovim|Windows & Splits|Ctrl+w h/j/k/l|Move between splits"
  "Neovim|Windows & Splits|Ctrl+w =|Equalize split sizes"
  "Neovim|Windows & Splits|Ctrl+w +/-|Increase / decrease height"
  "Neovim|Windows & Splits|Ctrl+w q|Close split"
  "Neovim|Windows & Splits|Ctrl+w o|Close all other splits"

  # ─── Neovim › Macros ───
  "Neovim|Macros|q{r}|Start recording to register {r}"
  "Neovim|Macros|q|Stop recording"
  "Neovim|Macros|@{r}|Play macro from register {r}"
  "Neovim|Macros|@@|Replay last macro"
  "Neovim|Macros|{n}@{r}|Play macro {n} times"

  # ─── Neovim › Marks ───
  "Neovim|Marks|m{a-z}|Set local mark  (A-Z = global)"
  "Neovim|Marks|\`{mark}|Jump to mark (exact position)"
  "Neovim|Marks|'{mark}|Jump to mark (line start)"
  "Neovim|Marks|:marks|List all marks"

  # ─── Neovim › Git (native) ───
  "Neovim|Git|:!git status|Run git status in shell"
  "Neovim|Git|:!git diff %|Diff current file"
  "Neovim|Git|:!git log --oneline|Short git log"

  # ─── NvChad › Commenting ───
  "NvChad|Commenting|gcc|Toggle comment on line"
  "NvChad|Commenting|gc|Toggle comment on selection"
  "NvChad|Commenting|gc{motion}|Comment with motion  (e.g. gc3j)"
  "NvChad|Commenting|gbc|Toggle block comment on line"
  "NvChad|Commenting|gb|Toggle block comment on selection"
  "NvChad|Commenting|gcO / gco|Add comment line above / below"
  "NvChad|Commenting|gcA|Add comment at end of line"

  # ─── NvChad › File & Search ───
  "NvChad|File & Search|Space+f+f|Find files (Telescope)"
  "NvChad|File & Search|Space+f+w|Live grep (find word)"
  "NvChad|File & Search|Space+f+b|Find open buffers"
  "NvChad|File & Search|Space+f+h|Find help tags"
  "NvChad|File & Search|Space+f+o|Recently opened files"
  "NvChad|File & Search|Space+f+z|Fuzzy find in current buffer"
  "NvChad|File & Search|Space+f+m|Find marks"

  # ─── NvChad › File Tree ───
  "NvChad|File Tree (NvimTree)|Ctrl+n|Toggle file tree"
  "NvChad|File Tree (NvimTree)|Space+e|Focus file tree"
  "NvChad|File Tree (NvimTree)|a|Create file  (end with / for dir)"
  "NvChad|File Tree (NvimTree)|d / r|Delete / rename file"
  "NvChad|File Tree (NvimTree)|x / c / p|Cut / copy / paste"
  "NvChad|File Tree (NvimTree)|Enter / o|Open file"
  "NvChad|File Tree (NvimTree)|v / h|Open in vertical / horizontal split"
  "NvChad|File Tree (NvimTree)|I|Toggle hidden files"
  "NvChad|File Tree (NvimTree)|R / W|Refresh tree / collapse all"

  # ─── NvChad › Buffers & Tabs ───
  "NvChad|Buffers & Tabs|Tab / Shift+Tab|Next / prev buffer"
  "NvChad|Buffers & Tabs|Space+x|Close current buffer"
  "NvChad|Buffers & Tabs|Space+b|New buffer"

  # ─── NvChad › LSP ───
  "NvChad|LSP (Code Intel)|gd / gD|Go to definition / declaration"
  "NvChad|LSP (Code Intel)|gi / gr|Go to implementation / references"
  "NvChad|LSP (Code Intel)|K|Hover documentation"
  "NvChad|LSP (Code Intel)|Space+l+a|Code action"
  "NvChad|LSP (Code Intel)|Space+l+r|Rename symbol"
  "NvChad|LSP (Code Intel)|Space+l+f|Format file"
  "NvChad|LSP (Code Intel)|[d / ]d|Prev / next diagnostic"
  "NvChad|LSP (Code Intel)|Space+l+d|Show buffer diagnostics"

  # ─── NvChad › Git (gitsigns) ───
  "NvChad|Git|]h / [h|Next / prev hunk"
  "NvChad|Git|Space+g+h+p|Preview git hunk"
  "NvChad|Git|Space+g+h+r|Reset git hunk"
  "NvChad|Git|Space+g+h+s|Stage git hunk"
  "NvChad|Git|Space+g+b|Git blame line"

  # ─── NvChad › Terminal ───
  "NvChad|Terminal|Space+h|New horizontal terminal"
  "NvChad|Terminal|Space+v|New vertical terminal"
  "NvChad|Terminal|Ctrl+x|Exit terminal insert mode"

  # ─── NvChad › Misc ───
  "NvChad|Misc|Space+c+h|NvChad cheat sheet"
  "NvChad|Misc|Space+t+h|Pick color theme"
  "NvChad|Misc|Space+n / Space+r+n|Toggle line / relative line numbers"
  "NvChad|Misc|Space+d|Open dashboard"
  "NvChad|Misc|Space+w+k/h/j/l|Focus window up/left/down/right"

  # ─── Yazi › Navigation ───
  "Yazi|Navigation|h / Backspace|Go to parent directory"
  "Yazi|Navigation|l / Enter|Open file or enter directory"
  "Yazi|Navigation|j / k|Move down / up"
  "Yazi|Navigation|J / K|Move down / up 5 items"
  "Yazi|Navigation|gg / G|Jump to first / last item"
  "Yazi|Navigation|g+h|Go to home directory"
  "Yazi|Navigation|g+c|Go to config directory"
  "Yazi|Navigation|g+d|Go to downloads directory"
  "Yazi|Navigation|-|Go to previous directory"
  "Yazi|Navigation|~|Show built-in cheat sheet"

  # ─── Yazi › Selection ───
  "Yazi|Selection|Space|Toggle selection"
  "Yazi|Selection|v|Enter visual selection mode"
  "Yazi|Selection|V|Invert all selections"
  "Yazi|Selection|Esc|Clear selection / exit mode"

  # ─── Yazi › File Operations ───
  "Yazi|File Operations|o / O|Open with default / picker app"
  "Yazi|File Operations|a|Create file  (end / for folder)"
  "Yazi|File Operations|r|Rename file"
  "Yazi|File Operations|d / D|Move to trash / permanently delete"
  "Yazi|File Operations|y / x|Copy / cut selected files"
  "Yazi|File Operations|p / P|Paste / paste overwrite"
  "Yazi|File Operations|; / :|Run shell command (non-blocking / blocking)"

  # ─── Yazi › Search & Filter ───
  "Yazi|Search & Filter|/|Filter files in current dir"
  "Yazi|Search & Filter|s|Search files (fd)"
  "Yazi|Search & Filter|S|Search file contents (ripgrep)"
  "Yazi|Search & Filter|z|Jump with zoxide"
  "Yazi|Search & Filter|Z|Jump with fzf"
  "Yazi|Search & Filter|n / N|Next / prev search match"

  # ─── Yazi › Tabs ───
  "Yazi|Tabs|t|Create new tab"
  "Yazi|Tabs|1-9|Switch to tab n"
  "Yazi|Tabs|[ / ]|Switch to prev / next tab"
  "Yazi|Tabs|{ / }|Swap with prev / next tab"

  # ─── Yazi › View ───
  "Yazi|View|.|Toggle hidden files"
  "Yazi|View|q|Quit Yazi"
  "Yazi|View|Q|Quit, cd to current dir in shell"

  # ─── Added via cheat-add function ───
  "nvim|Motion|h/j/k/l|Move cursor left/down/up/right"
  "nvim|Files|:q!|Quit without saving"
  "nvim|Files|:wq|Save and quit"
  "nvim|Editing|x|Delete character at cursor"
  "nvim|Editing|i/a|Insert before/after cursor"
  "nvim|Editing|I/A|Insert before/after line"
  "nvim|Motion|w/b|Move forward/backward one word"
  "nvim|Motion|0/$|Move to start/end of line"
  "nvim|Motion|^|Move to first non-blank character of line"
  "nvim|Motion|_|Move down to first non-blank character"
  "nvim|Motion|:[n] / [n]G|Jump to line [n]"
  "General|Navigation|<C-u>/<C-d>|Scroll half page up/down"
  "General|Navigation|<C-f>/<C-b>|Scroll one page down/up"
  "nvim|Navigation|gg/G|Move to start/end of file"
  "nvim|Operator|d|Delete operator"
  "nvim|Motion|w|Start of next word, excluding first character"
  "nvim|Motion|e|End of current word, including last character"
  "nvim|Motion|$|End of line, including last character"
  "nvim|Editing|[operator][n][motion]|Perform [operator] [n] times as per [motion]"
  "nvim|Editing|[n]dd|Delete [n] lines"
  "nvim|Editing|u|Undo last command"
  "nvim|Editing|U|Return line to original state"
  "nvim|Editing|<C-r>|Redo last undo"
  "nvim|Editing|p|Paste last deletion after cursor/line"
  "nvim|Editing|r[x]|Replace character at cursor with [x]"
  "nvim|Operator|c|Change operator"
  "nvim|Editing|/[phrase]|Forward search for [phrase]"
  "nvim|Editing|?[phrase]|Backward search for [phrase]"
  "nvim|Editing|n/N|Go to next/previous search result"
  "nvim|Editing|<C-o>/<C-i>|Go to previous/next cursor position"
  "nvim|Editing|%|Move to matching bracket"
  "nvim|Editing|:s/[old]/[new]|Replace/Substitute first occurrence of [old] with [new]"
  "nvim|Editing|:s/[old]/[new]/g|Replace/Substitute all occurrences of [old] with [new] on current line"
  "nvim|Editing|:[n1],[n2]s/[old]/[new]/g|Replace/Substitute all occurrences of [old] with [new] in lines [n1]-[n2]"
  "nvim|Editing|:%s/[old]/[new]/g|Replace/Substitute all occurrences of [old] with [new] in whole file"
  "nvim|Editing|:%s/[old]/[new]/g|Replace/Substitute all occurrences of [old] with [new] in whole file, with confirmation"
  "nvim|General|:![cmd]|Execute any external shell command [cmd]"
  "nvim|Editing|:r [filename/!cmd]|Insert contents of [filename] or output of [cmd] below cursor position"
) 

# ─── state files (only created by the parent process) ───
if [[ "$1" != "--cmd" ]]; then
  TMP_TOOL=$(mktemp)
  TMP_CAT=$(mktemp)
  TMP_PICK=$(mktemp)
  echo "All" > "$TMP_TOOL"
  echo "All" > "$TMP_CAT"
  trap 'rm -f "$TMP_TOOL" "$TMP_CAT" "$TMP_PICK"' EXIT
  export TMP_TOOL TMP_CAT TMP_PICK
fi

# ─── resolve script path (parent only; subshells inherit via export) ───
if [[ "$1" != "--cmd" ]]; then
  _raw="${0:A}"
  [[ ! -f "$_raw" ]] && _raw="$(whence -p "$0" 2>/dev/null || true)"
  [[ ! -f "$_raw" ]] && _raw="$HOME/.config/cheat/cheat.sh"
  SCRIPT="$_raw"
  export SCRIPT
fi
build_lines() {
  local filter_tool="$1"
  local filter_cat="$2"

  for entry in "${COMMANDS[@]}"; do
    IFS='|' read -r tool cat keys desc <<< "$entry"

    [[ "$filter_tool" != "All" && "$tool" != "$filter_tool" ]] && continue
    [[ "$filter_cat"  != "All" && "$cat"  != "$filter_cat"  ]] && continue

    case "$tool" in
      Neovim)  tool_color=$C_NVIM    ; tag="nvim  " ;;
      NvChad)  tool_color=$C_NVCHAD  ; tag="nvchad" ;;
      Yazi)    tool_color=$C_YAZI    ; tag="yazi  " ;;
      *)       tool_color=$C_KEY     ; tag=$(printf "%-6s" "${tool:0:6}") ;;
    esac

    padded_keys=$(printf "%-32s" "$keys")

    printf "${tool_color}${BOLD}%s${RESET}  ${C_CAT}%-26s${RESET}  ${C_KEY}%s${RESET}${C_DESC}%s${RESET}\n" \
      "$tag" "$cat" "$padded_keys" "$desc"
  done
}


export C_NVIM C_NVCHAD C_YAZI C_CAT C_KEY C_DESC RESET BOLD DIM

# ─── subcommand dispatcher ───
# usage: zsh $SCRIPT --cmd <command> [args...]
if [[ "$1" == "--cmd" ]]; then
  cmd="$2"
  case "$cmd" in
    build_lines)
      build_lines "$3" "$4"
      ;;
    list_tools)
      seen_tools=" "
      printf "All\n"
      for entry in "${COMMANDS[@]}"; do
        IFS='|' read -r t _ _ _ <<< "$entry"
        if [[ "$seen_tools" != *" $t "* ]]; then
          printf "%s\n" "$t"
          seen_tools+="$t "
        fi
      done
      ;;
    list_cats)
      # print categories for current tool to stdout
      tool=$(cat "$TMP_TOOL")
      seen_cats=" "
      printf "All\n"
      for entry in "${COMMANDS[@]}"; do
        IFS='|' read -r t cat _ _ <<< "$entry"
        [[ "$tool" != "All" && "$t" != "$tool" ]] && continue
        if [[ "$seen_cats" != *" $cat "* ]]; then
          printf "%s\n" "$cat"
          seen_cats+="$cat "
        fi
      done
      ;;
    apply_tool)
      # read selection written by the execute step, emit fzf actions
      tool=$(cat "$TMP_PICK")
      [[ -z "$tool" ]] && exit 0
      echo "$tool" > "$TMP_TOOL"
      echo "All"   > "$TMP_CAT"
      [[ "$tool" == "All" ]] && label="  󰌌  all tools  " || label="  󰌌  ${tool}  "
      # single-quote tool so spaces/special chars in the reload cmd are safe
      printf "change-border-label(%s)+reload(SCRIPT=%s TMP_TOOL=%s TMP_CAT=%s TMP_PICK=%s zsh %s --cmd build_lines '%s' 'All')" \
        "$label" "$SCRIPT" "$TMP_TOOL" "$TMP_CAT" "$TMP_PICK" "$SCRIPT" "$tool"
      ;;
    apply_cat)
      # read selection written by the execute step, emit fzf actions
      cat=$(cat "$TMP_PICK")
      [[ -z "$cat" ]] && exit 0
      tool=$(cat "$TMP_TOOL")
      echo "$cat" > "$TMP_CAT"
      [[ "$tool" == "All" ]] && t_part="all tools" || t_part="$tool"
      [[ "$cat"  == "All" ]] && c_part=""          || c_part=" › $cat"
      label="  󰌌  ${t_part}${c_part}  "
      # single-quote tool and cat so spaces/& etc. in the reload cmd are safe
      printf "change-border-label(%s)+reload(SCRIPT=%s TMP_TOOL=%s TMP_CAT=%s TMP_PICK=%s zsh %s --cmd build_lines '%s' '%s')" \
        "$label" "$SCRIPT" "$TMP_TOOL" "$TMP_CAT" "$TMP_PICK" "$SCRIPT" "$tool" "$cat"
      ;;
  esac
  exit 0
fi

# ─── run fzf ───
build_lines "All" "All" | \
  fzf \
    --ansi \
    --no-sort \
    --layout=reverse \
    --border=rounded \
    --border-label="  󰌌  all tools  " \
    --border-label-pos=3 \
    --prompt="  search: " \
    --pointer="▶" \
    --marker="✓" \
    --color="dark,\
bg:#1e2432,bg+:#2e3a4a,gutter:#1e2432,\
border:#2a3a5a,label:#ea80fc,\
prompt:#ff5252,pointer:#ff5252,marker:#a8e063,\
hl:#ff5252,hl+:#ff5252,\
fg:#90a4ae,fg+:#e8eaf6,\
info:#ea80fc,spinner:#18ffff,\
header:#1e3a5f" \
    --preview-window=hidden \
    --header=$'  \e[38;2;255;82;82m\e[1mctrl-t\e[0m\e[38;2;232;234;246m tool\e[0m   \e[38;2;255;82;82m\e[1mctrl-g\e[0m\e[38;2;232;234;246m category\e[0m   \e[38;2;144;164;174mctrl-c/esc close\e[0m\n' \
    --bind="ctrl-t:execute(SCRIPT=${SCRIPT} TMP_TOOL=${TMP_TOOL} TMP_CAT=${TMP_CAT} TMP_PICK=${TMP_PICK} \
        zsh ${SCRIPT} --cmd list_tools \
        | fzf --ansi --no-sort --layout=reverse --border=rounded --border-label-pos=3 \
              --pointer='▶' --height='~10' --prompt='  tool: ' \
              --border-label='  󰌌  select tool  ' \
              --color='dark,bg:#1e2432,bg+:#2e3a4a,gutter:#1e2432,border:#2a3a5a,label:#ea80fc,prompt:#ff5252,pointer:#ff5252,hl:#ff5252,hl+:#ff5252,fg:#90a4ae,fg+:#e8eaf6,info:#ea80fc' \
        > ${TMP_PICK})+transform(SCRIPT=${SCRIPT} TMP_TOOL=${TMP_TOOL} TMP_CAT=${TMP_CAT} TMP_PICK=${TMP_PICK} \
        zsh ${SCRIPT} --cmd apply_tool)" \
    --bind="ctrl-g:execute(SCRIPT=${SCRIPT} TMP_TOOL=${TMP_TOOL} TMP_CAT=${TMP_CAT} TMP_PICK=${TMP_PICK} \
        zsh ${SCRIPT} --cmd list_cats \
        | fzf --ansi --no-sort --layout=reverse --border=rounded --border-label-pos=3 \
              --pointer='▶' --height='~10' --prompt='  category: ' \
              --border-label='  󰌌  select category  ' \
              --color='dark,bg:#1e2432,bg+:#2e3a4a,gutter:#1e2432,border:#2a3a5a,label:#ea80fc,prompt:#ff5252,pointer:#ff5252,hl:#ff5252,hl+:#ff5252,fg:#90a4ae,fg+:#e8eaf6,info:#ea80fc' \
        > ${TMP_PICK})+transform(SCRIPT=${SCRIPT} TMP_TOOL=${TMP_TOOL} TMP_CAT=${TMP_CAT} TMP_PICK=${TMP_PICK} \
        zsh ${SCRIPT} --cmd apply_cat)" \
    --bind='esc:abort' || true
