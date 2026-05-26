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
alias history=omz_history

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
alias gft='git fetch'
alias gfta='git fetch --all'
# rarely used
alias gftp='git fetch --prune'
alias gmg='git merge'
# rarely used
alias gmga='git merge --abort'
# rarely used
alias gmgc='git merge --continue'
alias gdf='git diff'
# rarely used
alias gdfs='git diff --staged'
# rarely used
alias gswt='git switch'
# rarely used
alias grbs='git rebase'
# rarely used
alias grbsa='git rebase --abort'
# rarely used
alias grbsc='git rebase --continue'
# rarely used
alias grbsi='git rebase --interactive'
alias gl='git log'
alias gdag='git log \
    --graph \
    --abbrev-commit \
    --decorate \
    --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" \
    --all'
# rarely used
alias gdagol='git log --all --decorate --oneline --graph'
alias gbrc='git branch'
# rarely used
alias gbrca='git branch --all'
# rarely used
alias gbrcr='git branch --remote'
# rarely used
alias gbrcd='git branch -d'
# rarely used
alias gbrcD='git branch -D'
alias gcln='git clone'
alias grst='git reset'
# rarely used
alias grsth='git reset --hard'
# rarely used
alias grsr='git restore'
# rarely used
alias grsra='git restore :/'
# rarely used
alias grsrd='git restore .'
# rarely used
alias gss='git stash'
# rarely used
alias gssp='git stash pop'
# rarely used
alias gssl='git stash list'

alias tm='tmux'
alias tmls='tmux ls'
alias tmatc='tmux attach -t '
alias tmksv='tmux kill-server'
alias tmkss='tmux kill-session -t '
