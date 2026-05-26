CONDA_PATH="/opt/miniconda3/etc/profile.d/conda.sh"
export \
    ZSH="$HOME/.oh-my-zsh" \
    ZSH_CUSTOM="$HOME/.config/zsh" \
    ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:*' aliases no
plugins=(
    zsh-autosuggestions
    zsh-expand
    zsh-syntax-highlighting
    zsh-vi-mode
    extract
)
ZPWR_EXPAND_BLACKLIST=(grep ls)
sources=(
    "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    "$HOME/.p10k.zsh"
    $ZSH_CUSTOM/extra/**/*.zsh(N)
    "$ZSH/oh-my-zsh.sh"
)
for file in "${sources[@]}"; do
    [[ -f "$file" ]] && source "$file"
done
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
[[ -d "$ZSH_CUSTOM/plugins/zsh-completions/src" ]] && \
    fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src && \
    autoload -U compinit && compinit
[[ -e "/opt/homebrew/bin/brew" ]] && \
    eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d "/usr/local/bin" ]] && \
    export PATH="/usr/local/bin:$PATH"
command -v go &>/dev/null && \
    GOPATH_BIN="$(go env GOPATH)/bin" && \
    [[ -d "$GOPATH_BIN" ]] && \
    export PATH="$PATH:$GOPATH_BIN"
command -v nvim &>/dev/null && \
    export EDITOR=nvim
command -v zoxide &>/dev/null && \
    eval "$(zoxide init --cmd cd zsh)"
zvm_after_init_commands+=('command -v fzf &>/dev/null && eval "$(fzf --zsh)"')
[[ -f "$CONDA_PATH" ]] && \
    source "$CONDA_PATH" && \
    source "$ZSH_CUSTOM/conda_inherit.zsh"
