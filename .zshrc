#!/usr/bin/zsh
[[ -n "$NVIM" ]] && WEZTERM_SHELL_SKIP_USER_VARS=true
[[ -e "/opt/homebrew/bin/brew" ]] &&
    eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d "$HOME/.local/bin" ]] &&
    export PATH="$PATH:$HOME/.local/bin"
command -v go &>/dev/null &&
    export PATH="$PATH:$(go env GOPATH)/bin"
command -v nvim &>/dev/null &&
    export EDITOR=nvim
command -v zoxide &>/dev/null &&
    eval "$(zoxide init --cmd cd zsh)"
ZSH_CUSTOM="$HOME/.config/zsh"
ZPWR_EXPAND_BLACKLIST=(grep ls open)
sources=(
    "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    "$HOME/.p10k.zsh"
    "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme"
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
    "$ZSH_CUSTOM/plugins/zsh-completions/zsh-completions.plugin.zsh"
    "$ZSH_CUSTOM/plugins/zsh-expand/zsh-expand.plugin.zsh"
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
    "$ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
    $ZSH_CUSTOM/extra/**/*.zsh(N)
)
zvm_after_init_commands+=(setup_fzf)
for file in "${sources[@]}"; do
    [[ -f "$file" ]] && source "$file" || echo "$file not found"
done
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
autoload -Uz compinit && compinit -u -C
