require('blink.pairs').setup({
  mappings = {
    enabled = false,
    cmdline = false,
    disabled_filetypes = { 'TelescopePrompt' },
    pairs = {},
  },
  highlights = {
    enabled = true,
    cmdline = true,
    groups = {
      'BlinkPairsRed',
      'BlinkPairsOrange',
      'BlinkPairsYellow',
      'BlinkPairsGreen',
      'BlinkPairsBlue',
      'BlinkPairsCyan',
      'BlinkPairsPurple',
    },
    unmatched_group = 'BlinkPairsUnmatched',
    matchparen = {
      enabled = true,
      cmdline = true,
      include_surrounding = false,
      group = 'BlinkPairsMatchParen',
      priority = 250,
    },
  },
})
vim.api.nvim_set_hl(0, 'BlinkPairsRed', { default = true, fg = '#cc241d' })
vim.api.nvim_set_hl(0, 'BlinkPairsOrange', { default = true, fg = '#d65d0e' })
vim.api.nvim_set_hl(0, 'BlinkPairsYellow', { default = true, fg = '#d79921' })
vim.api.nvim_set_hl(0, 'BlinkPairsGreen', { default = true, fg = '#689d6a' })
vim.api.nvim_set_hl(0, 'BlinkPairsCyan', { default = true, fg = '#a89984' })
vim.api.nvim_set_hl(0, 'BlinkPairsBlue', { default = true, fg = '#458588' })
vim.api.nvim_set_hl(0, 'BlinkPairsPurple', { default = true, fg = '#b16286' })
vim.api.nvim_set_hl(0, 'BlinkPairsUnmatched', { ctermfg = 9, fg = '#ff007c' })
vim.api.nvim_set_hl(0, 'BlinkPairsMatchParen', { link = 'MatchParen' })
