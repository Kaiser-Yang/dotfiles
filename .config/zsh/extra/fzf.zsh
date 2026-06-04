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
