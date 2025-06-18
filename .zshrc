# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

ENABLE_CORRECTION=false

plugins=(
    git
    zsh-vi-mode
    zsh-expand
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# zsh-vi-mode
ZVM_INIT_MODE=sourcing
zvm_config() {
    ZVM_VI_ESCAPE_BINDKEY=^N
    ZVM_VI_INSERT_ESCAPE_BINDKEY=^N
    ZVM_VI_VISUAL_ESCAPE_BINDKEY=^N
    ZVM_VI_OPPEND_ESCAPE_BINDKEY=^N
}

# zsh-expand
ZPWR_EXPAND_BLACKLIST=(grep)
ZPWR_CORRECT=false

# zsh-completions
fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

bindkey 'f' forward-word
bindkey 'd' delete-word

alias ll='ls -lFh'

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init --cmd cd zsh)"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

export PATH=$PATH:/opt/nvim-linux64/bin

if [[ -n "$TMUX" ]] then
  export flavor='conda'
  source $HOME/.config/tmux/plugins/conda_inherit.sh
fi
