paste-from-clipboard() {
  local clip=""
  # macOS
  if command -v pbpaste &>/dev/null; then
    clip="$(pbpaste)"
  # Wayland
  elif command -v wl-paste &>/dev/null; then
    clip="$(wl-paste --no-newline 2>/dev/null)"
  # X11
  elif command -v xclip &>/dev/null; then
    clip="$(xclip -o -selection clipboard 2>/dev/null)"
  elif command -v xsel &>/dev/null; then
    clip="$(xsel --clipboard --output 2>/dev/null)"
  # WSL / Windows
  elif grep -qi microsoft /proc/version 2>/dev/null; then
    if command -v powershell.exe &>/dev/null; then
      clip="$(powershell.exe -NoProfile -Command Get-Clipboard 2>/dev/null | tr -d '\r')"
    elif command -v clip.exe &>/dev/null; then
      clip="$(clip.exe < /dev/null 2>/dev/null)"
    fi
  fi
  LBUFFER+="$clip"
}
zle -N paste-from-clipboard
zvm_after_init_commands+=(
  "zvm_bindkey vicmd 'v' paste-from-clipboard"
  "zvm_bindkey viins 'v' paste-from-clipboard"
  "zvm_bindkey viins 'b' backward-word"
  "zvm_bindkey viins 'f' forward-word"
  "zvm_bindkey viins 'd' delete-word"
  "zvm_bindkey viins 'p' up-line-or-search"
  "zvm_bindkey viins 'n' down-line-or-search"
)
