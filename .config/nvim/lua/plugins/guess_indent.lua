return {
  'NMAC427/guess-indent.nvim',
  opts = {
    filetype_exclude = {
      'netrw',
      'tutor',
      'neo-tree',
      'Avante',
      'AvanteInput',
    },
    buftype_exclude = {
      'help',
      'nofile',
      'terminal',
      'prompt',
    },
    on_tab_options = {
      expandtab = false,
      tabstop = 4,
      shiftwidth = 4,
    },
  },
}
