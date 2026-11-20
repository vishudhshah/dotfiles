eval "$(starship init zsh)"

# Match Rainbow's Git colors and blend adjacent right-prompt segments.
_starship_rainbow_prompt() {
  local rendered git_changes git_segment rest ansi_end=''
  local git_start git_end ansi_start='' transition joined='' MATCH MBEGIN MEND
  local -a match
  rendered=$(starship prompt "$@") || return
  [[ $rendered == *'%{'$'\e'* ]] && ansi_end='%}'
  git_start=$'\e[42;34m'"${ansi_end}"
  git_end=$'\e[32m'"${ansi_end}"

  if [[ $rendered == *"$git_start"*"$git_end"* ]]; then
    git_changes=$(git --no-optional-locks status --porcelain --untracked-files=no 2>/dev/null)
    if [[ -n $git_changes ]]; then
      rest=${rendered#*"$git_start"}
      git_segment=${rest%%"$git_end"*}
      git_segment=${git_segment//$'\e[42'/$'\e[43'}
      rendered="${rendered%%"$git_start"*}${git_start/42/43}${git_segment}${git_end/32/33}${rest#*"$git_end"}"
    fi
  fi

  if [[ $1 == --right ]]; then
    [[ -n $ansi_end ]] && ansi_start='%\{'
    # Capture the preceding block's background and the next arrow's foreground.
    transition=$'(\e\\[(4[0-7])(;[0-9]+)*m[^\e]*\e\\[0m'"${ansi_end}${ansi_start}"$'\e\\[)(3[0-7])m'"${ansi_end}"
    rest=$rendered
    while [[ $rest =~ $transition ]]; do
      joined+="${rest[1,MBEGIN-1]}${match[1]}${match[2]};${match[4]}m${ansi_end}"
      rest=${rest[MEND+1,-1]}
    done
    rendered=$joined$rest
  fi
  print -r -- "$rendered"
}
PROMPT=${PROMPT/#\$\(*\ prompt\ /'$(_starship_rainbow_prompt '}
RPROMPT=${RPROMPT/#\$\(*\ prompt\ /'$(_starship_rainbow_prompt '}

# p10k transient prompt replication
_starship_transient_prompt() {
  [[ $CONTEXT == start ]] || return 0
  local character
  character=$(starship module character --status="${STARSHIP_CMD_STATUS:-0}" --keymap="${KEYMAP:-viins}") || return 0
  _starship_full_prompt=$PROMPT _starship_full_rprompt=$RPROMPT
  PROMPT=$character RPROMPT=''
  zle reset-prompt
}

_starship_restore_prompt() {
  if (( ${+_starship_full_prompt} )); then
    PROMPT=$_starship_full_prompt RPROMPT=$_starship_full_rprompt
    unset _starship_full_prompt _starship_full_rprompt
  fi
}
autoload -Uz add-zle-hook-widget add-zsh-hook
add-zle-hook-widget line-finish _starship_transient_prompt
add-zsh-hook precmd _starship_restore_prompt
