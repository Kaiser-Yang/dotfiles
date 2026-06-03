local u = require('utils')
u.gh('Kaiser-Yang/flash.nvim', 'develop')
require('flash').setup({
  search = {
    multi_window = false,
    exclude = {
      'flash_prompt',
      'blink-cmp-menu',
      function(win) return not vim.api.nvim_win_get_config(win).focusable end,
    },
  },
  label = { reuse = 'all' },
  modes = {
    search = {
      enabled = false,
      highlight = { backdrop = true },
      jump = { autojump = true },
    },
    char = {
      jump_labels = true,
      multi_line = false,
      label = { exclude = 'acdghijklrACDIJKY' },
      keys = {},
      char_actions = function() return { [';'] = 'next', [','] = 'prev' } end,
      jump = { do_first_jump = false, autojump = true },
    },
  },
})
