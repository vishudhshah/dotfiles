alias cat=bat
alias catp='bat --paging=never'
alias cheat='~/.config/cheat/cheat.sh'
alias cl=clear
alias clear='clear && printf "\e[3J"'
alias code=code-insiders
alias ff='clear && fastfetch'
alias lg=lazygit
alias ls='eza --icons --tree --level=1'
alias lsa='eza --icons --tree --level=1 --all'
alias q='exit'
alias spotify=spotify_player
alias tree='eza --icons --tree'
alias vi=nvim
alias vim=nvim

# Telegram expenses bot
alias expenses-logs='tail -f ~/Library/Logs/expenses-bot.log'
alias expenses-restart='launchctl unload ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist && launchctl load ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist'
alias expenses-start='launchctl load ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist'
alias expenses-stop='launchctl unload ~/Library/LaunchAgents/com.vishudh.expenses-bot.plist'
