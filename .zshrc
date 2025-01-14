#!/usr/bin/zsh

alias ll='ls -lFh'

alias nv='nvim'

alias lzg='lazygit'

alias g='g'
alias gst='git status'
alias gps='git push'
alias gpl='git pull'
alias ga='git add'
alias gaa='git add :/'
alias gad='git add .'
alias gcm='git commit'
alias gft='git fetch'
alias gmg='git merge'
alias gl='git log'
alias gdf='git diff'
alias gswt='git switch'
alias grbs='git rebase'
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

alias tm='tmux'
alias tmls='tmux ls'
alias tmlsbf='tmux list-buffers'
alias tmlscli='tmux list-clients'
alias tmlscmd='tmux list-commands'
alias tmlsk='tmux list-keys'
alias tmlspn='tmux list-panes'
alias tmlsss='tmux list-session'
alias tmlswd='tmux list-window'
alias tmnss='tmux new-session -s'
alias tmatc='tmux attach -t'
alias tmksv='tmux kill-server'
alias tmkss='tmux kill-session -t'
alias tmswt='tmux switch -t'
alias tmrnss='tmux rename-session -t'
alias tmrnwd='tmux rename-window -t'

export EDITOR=nvim
export PATH=$PATH:~/.local/bin:~/.cargo/bin:~/.yarn/bin

# y for yazi
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# TODO: multi dots
# TODO: vi mode
# TODO: cursor shape
# TODO: mode_prompt
#
eval "$(oh-my-posh init zsh --config ~/.config/posh.omp.json)"
