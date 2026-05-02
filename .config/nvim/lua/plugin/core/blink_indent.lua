local u = require('utils')
vim.pack.add({ u.gh('saghen/blink.indent') }, { confirm = false })

-- BUG: https://github.com/saghen/blink.indent/issues/47
require('blink.indent').setup({
  mappings = {
    object_scope = '',
    object_scope_with_border = '',
    goto_top = '',
    goto_bottom = '',
  },
  static = {
    whitespace_char = '·',
    char = '│',
  },
  scope = {
    enabled = true,
    char = '│',
    priority = 1000,
    highlights = {
      'BlinkIndentRed',
      'BlinkIndentOrange',
      'BlinkIndentYellow',
      'BlinkIndentGreen',
      'BlinkIndentBlue',
      'BlinkIndentCyan',
      'BlinkIndentViolet',
    },
    underline = {
      enabled = true,
      highlights = {
        'BlinkIndentRedUnderline',
        'BlinkIndentOrangeUnderline',
        'BlinkIndentYellowUnderline',
        'BlinkIndentGreenUnderline',
        'BlinkIndentBlueUnderline',
        'BlinkIndentCyanUnderline',
        'BlinkIndentVioletUnderline',
      },
    },
  },
})
