local u = require('utils')
vim.pack.add({
  u.gh('saghen/blink.download'),
  u.gh('saghen/blink.pairs', vim.version.range('*')),
}, { confirm = false })

require('blink.pairs').setup({
  mappings = {
    enabled = false,
    cmdline = false,
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
