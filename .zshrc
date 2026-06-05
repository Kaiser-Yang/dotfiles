#!/usr/bin/zsh
[[ -n "$ZSH_PROFILE" ]] && zmodload zsh/zprof
[[ -e "/opt/homebrew/bin/brew" ]] &&
    eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -d "$HOME/.local/bin" ]] &&
    export PATH="$PATH:$HOME/.local/bin"
command -v go &>/dev/null &&
    export PATH="$PATH:$(go env GOPATH)/bin"
if [[ -n "$PATH_ONLY" ]]; then
    [[ -n "$ZSH_PROFILE" ]] && zprof
    return 0
fi
WEZTERM_SHELL_SKIP_USER_VARS=true
command -v nvim &>/dev/null &&
    export EDITOR=nvim
command -v zoxide &>/dev/null &&
    eval "$(zoxide init --cmd cd zsh)"
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data
ZSH_CUSTOM="$HOME/.config/zsh"
ZPWR_EXPAND_BLACKLIST=(grep ls open)
sources=(
    "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    "$HOME/.p10k.zsh"
    "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme"
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
    "$ZSH_CUSTOM/plugins/zsh-completions/zsh-completions.plugin.zsh"
    "$ZSH_CUSTOM/plugins/zsh-expand/zsh-expand.plugin.zsh"
    "$ZSH_CUSTOM/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
    $ZSH_CUSTOM/extra/**/*.zsh(N)
)
for file in "${sources[@]}"; do
    [[ -f "$file" ]] && source "$file" || echo "$file not found"
done
autoload -Uz compinit
compinit -u -C
# INFO:
# must be the last one to be sourced
source "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
[[ -n "$ZSH_PROFILE" ]] && zprof
true # make sure the return code is always zero
