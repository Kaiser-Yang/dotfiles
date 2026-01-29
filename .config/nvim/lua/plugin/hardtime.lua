return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  dependencies = { 'MunifTanjim/nui.nvim' },
  opts = {
    disable_mouse = false,
    disabled_keys = {
      ['<Up>'] = false,
      ['<Down>'] = false,
      ['<Left>'] = false,
      ['<Right>'] = false,
    },
    hints = {
      ['dl'] = { message = function() return 'Use x instead of dl' end, length = 2 },
      ['dh'] = { message = function() return 'Use X instead of dh' end, length = 2 },
      ['cl'] = { message = function() return 'Use s instead of cl' end, length = 2 },
      ['%^C'] = { message = function() return 'Use S instead of ^C' end, length = 2 },
      ['cc'] = { message = function() return 'Use S instead of cc' end, length = 2 },
    },
  },
}
