
### start_symbol_kaiserqzyue
# we add a empty line above to make sure the script append it correctly.

# set vim mode for bash
set -o vi

# set aliases for some frequently used git commands
alias g='git'
alias gst='git status'
alias gps='git push'
alias gpl='git pull'
alias ga='git add'
# git add all
alias gaa='git add :/'
# git add dot
alias gad='git add .'
alias gcm='git commit'
alias gft='git fetch'
alias gmg='git merge'
alias gl='git log'
alias gdf='git diff'

# set aliases for some frequently used jupyter commands
alias jpt='jupyter'
alias jptnb='jupyter notebook'
alias jptnbcv='jupyter nbconvert'
# set aliases for some frequently used bash commands
# we use -h always to make the size of files more humane
alias ll='ls -lFh'
# goes to up directory
alias up='cd ..'
# Those two lines are for WSL to use windows clipboard
alias wcp='clip.exe'
alias wpst='powershell.exe Get-Clipboard'
# Let ^L clear the screen
bind "\C-l":clear-screen
# we add a empty line below to make sure the script append it coreectly.
### end_symbol_kaiserqzyue
