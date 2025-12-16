# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -e "$HOME/.zprofile" ]]; then
    source "$HOME/.zprofile"
fi

if [[ -d "/opt/homebrew/lib" && "$(uname)" == "Darwin" ]]; then
    export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/opt/homebrew/lib"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-vi-mode
    zsh-expand
    zsh-autosuggestions
    zsh-syntax-highlighting
    extract
)

# zsh-vi-mode
ZVM_INIT_MODE=sourcing

# zsh-expand
ZPWR_EXPAND_BLACKLIST=(grep ls)
ZPWR_CORRECT=false

# zsh-completions
fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# Make Alt+f move the cursor forward by a word
bindkey 'f' forward-word
# Make Alt+d delete the word after the cursor
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
alias gfta='git fetch --all'
alias gftp='git fetch --prune'
alias gmg='git merge'
alias gmga='git merge --abort'
alias gmgc='git merge --continue'
alias gdf='git diff'
alias gdfs='git diff --staged'
alias gswt='git switch'
alias grbs='git rebase'
alias grbsa='git rebase --abort'
alias grbsc='git rebase --continue'
alias grbsi='git rebase --interactive'
alias gl='git log'
alias gdag='git log \
    --graph \
    --abbrev-commit \
    --decorate \
    --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)" \
    --all'
alias gdagol='git log --all --decorate --oneline --graph'
alias gbrc='git branch'
alias gbrca='git branch --all'
alias gbrcr='git branch --remote'
alias gbrcd='git branch -d'
alias gbrcD='git branch -D'
alias gcln='git clone'
alias grst='git reset'
alias grsth='git reset --hard'
alias grsr='git restore'
alias grsra='git restore :/'
alias grsrd='git restore .'
alias gss='git stash'
alias gssp='git stash pop'
alias gssl='git stash list'

alias tm='tmux'
alias tmls='tmux ls'
alias tmatc='tmux attach -t'
alias tmksv='tmux kill-server'
alias tmkss='tmux kill-session -t'
# alias tmlsbf='tmux list-buffers'
# alias tmlscli='tmux list-clients'
# alias tmlscmd='tmux list-commands'
# alias tmlsk='tmux list-keys'
# alias tmlspn='tmux list-panes'
# alias tmlsss='tmux list-session'
# alias tmlswd='tmux list-window'
# alias tmnss='tmux new-session -s'
# alias tmswt='tmux switch -t'
# alias tmrnss='tmux rename-session -t'
# alias tmrnwd='tmux rename-window -t'

export EDITOR=nvim
export PATH=$PATH:~/.local/bin:~/.cargo/bin:~/.yarn/bin

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Configure cd to use zoxide if available
! command -v zoxide &>/dev/null || eval "$(zoxide init --cmd cd zsh)"

if [ -d "$HOME/opt/miniconda3" ]; then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$("$HOME/opt/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/opt/miniconda3/etc/profile.d/conda.sh" ]; then
            . "$HOME/opt/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/opt/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
    if [[ -n "$TMUX" ]] then
      export flavor='conda'
      source $HOME/.config/tmux/plugins/conda_inherit.sh
    fi
fi

# Check if /opt/nvim-linux64/bin/nvim exists and add to PATH
if [[ -d "/opt/nvim-linux-x86_64/bin" ]] then
    export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
fi

# y for yazi
# function y() {
#     local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
#     yazi "$@" --cwd-file="$tmp"
#     if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
#         builtin cd -- "$cwd"
#     fi
#     rm -f -- "$tmp"
# }
#
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
# --color=selected-bg:#45475a \
# --multi"
