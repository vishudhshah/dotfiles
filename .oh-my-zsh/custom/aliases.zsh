alias clear='clear && printf "\e[3J"'
alias code="code-insiders"
alias ls="eza --icons --tree --level=1"
alias lsa="eza --icons --tree --level=1 --all"
alias tree="eza --icons --tree"
alias vim=nvim
alias vi=nvim
alias cat=bat
alias catp='bat --paging=never'
alias cheat='~/.config/cheat/cheat.sh'
alias ff="clear;fastfetch"
alias q='exit'
alias cdh="cd ~"
alias spotify=spotify_player
alias cl='clear'

# Telegram expenses bot
alias expenses-restart='launchctl unload ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist && launchctl load ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist'
alias expenses-start='launchctl load ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist'
alias expenses-stop='launchctl unload ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist'
alias expenses-logs='tail -f ~/Library/Logs/expenses-bot.log'
