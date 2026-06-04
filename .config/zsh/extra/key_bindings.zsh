setup_bindings() {
  zvm_bindkey viins 'b' backward-word
  zvm_bindkey viins 'f' forward-word
  zvm_bindkey viins 'd' delete-word
  zvm_bindkey viins 'p' up-line-or-search
  zvm_bindkey viins 'n' down-line-or-search
  bindkey 's' sudo-command-line
}
zvm_after_init_commands+=(setup_bindings)
