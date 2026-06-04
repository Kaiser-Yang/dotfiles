unalias -a

alias ls='ls --color=auto -h'
alias lsa='ls --color=auto -ha'
alias ll='ls --color=auto -lh'
alias lla='ls --color=auto -lha'
alias ...=../..
alias ....=../../..
alias .....=../../../..
alias ......=../../../../..
alias d='dirs -v'
alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias x=extract
alias grep='grep --color=auto'
alias egrep='grep -E'
alias fgrep='grep -F'

! command -v open &>/dev/null && command -v xdg-open &>/dev/null && alias open=xdg-open

alias nv='nvim'

alias lzg='lazygit'

alias g='git'
alias gst='git status'
alias gps='git push'
alias gpl='git pull --ff-only'
alias gplr='git pull --rebase'
alias ga='git add'
alias gaa='git add :/'
alias gad='git add .'
alias gcm='git commit'
alias gco='git checkout'
alias gft='git fetch'
alias gfta='git fetch --all'
alias gftp='git fetch --prune'
alias gmg='git merge'
alias gdf='git diff'
alias gdfs='git diff --staged'
alias grbs='git rebase'
alias gl='git log'
alias gdag='git log \
    --graph \
    --abbrev-commit \
    --decorate \
    --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" \
    --all'
alias gdagol='git log --all --decorate --oneline --graph'
alias gbrc='git branch'
alias gcln='git clone'
alias grst='git reset'
alias grsr='git restore'
alias grsra='git restore :/'
alias grsrd='git restore .'

alias tm='tmux'
alias tmls='tmux ls'
alias tmatc='tmux attach -t '
alias tmksv='tmux kill-server'
alias tmkss='tmux kill-session -t '
