if [[ -n "$NVIM" ]]; then
    # INFO: cause problems in nvim
    WEZTERM_SHELL_SKIP_USER_VARS=true
    WEZTERM_SHELL_SKIP_CWD=true
fi
CONDA_PATH="/opt/miniconda3/etc/profile.d/conda.sh"
ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$HOME/.config/zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:*' aliases no
plugins=(
    zsh-autosuggestions
    zsh-expand
    zsh-syntax-highlighting
    zsh-vi-mode
    extract
    sudo
)
ZPWR_EXPAND_BLACKLIST=(grep ls open)
sources=(
    "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    "$HOME/.p10k.zsh"
    $ZSH_CUSTOM/extra/**/*.zsh(N)
    "$ZSH/oh-my-zsh.sh"
)
for file in "${sources[@]}"; do
    [[ -f "$file" ]] && source "$file"
done
[[ -f "$CONDA_PATH" ]] &&
    source "$CONDA_PATH" &&
    source "$ZSH_CUSTOM/conda_inherit.zsh"
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
[[ -d "$ZSH_CUSTOM/plugins/zsh-completions/src" ]] &&
    fpath+=$ZSH_CUSTOM/plugins/zsh-completions/src &&
    autoload -U compinit && compinit
COMMAND_NOT_FOUND_HANDLER=""
[[ -e "/opt/homebrew/bin/brew" ]] &&
    eval "$(/opt/homebrew/bin/brew shellenv)" &&
    COMMAND_NOT_FOUND_HANDLER="$(brew --repository)/Library/Homebrew/command-not-found/handler.sh"
command -v pkgfile &>/dev/null &&
    COMMAND_NOT_FOUND_HANDLER="/usr/share/doc/pkgfile/command-not-found.zsh"
[[ -f "$COMMAND_NOT_FOUND_HANDLER" ]] &&
    source "$COMMAND_NOT_FOUND_HANDLER"
[[ -d "$HOME/.local/bin" ]] &&
    export PATH="$PATH:$HOME/.local/bin"
command -v go &>/dev/null &&
    GOPATH_BIN="$(go env GOPATH)/bin" &&
    [[ -d "$GOPATH_BIN" ]] &&
    export PATH="$PATH:$GOPATH_BIN"
command -v nvim &>/dev/null &&
    export EDITOR=nvim
command -v zoxide &>/dev/null &&
    eval "$(zoxide init --cmd cd zsh)"
setup_fzf() {
    if ! command -v fzf &>/dev/null; then
        return
    fi
    export FZF_CTRL_T_OPTS="
      --preview '
        if [[ -d {} ]]; then
          tree -C -L 2 {} 2> /dev/null
        else
          bat --color=always --style=numbers {} 2> /dev/null || cat {}
        fi
      '"
    export FZF_ALT_C_OPTS="
      --preview '
        tree -C -L 2 {} 2> /dev/null
      '"
    export FZF_DEFAULT_OPTS="
      --multi
      --bind 'alt-a:toggle-all'
      --bind 'ctrl-n:ignore,ctrl-p:ignore'
      --bind 'ctrl-d:preview-half-page-down,ctrl-u:preview-half-page-up'
    "
    eval "$(fzf --zsh)"
}
zvm_after_init_commands+=(setup_fzf)
