local u = require('utils')
u.gh('saghen/blink.indent')

-- BUG: https://github.com/saghen/blink.indent/issues/47
-- BUG: https://github.com/saghen/blink.indent/issues/52
require('blink.indent').setup({
  -- BUG: The default mappings can not be disabled, this is a bug
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
    indent_at_cursor = true,
    highlights = {
      'BlinkIndentRed',
      'BlinkIndentOrange',
      'BlinkIndentYellow',
      'BlinkIndentGreen',
      'BlinkIndentBlue',
      'BlinkIndentCyan',
      'BlinkIndentPurple',
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
        'BlinkIndentPurpleUnderline',
      },
    },
  },
})
