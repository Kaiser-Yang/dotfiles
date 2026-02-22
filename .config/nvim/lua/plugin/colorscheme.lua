-- INFO:
-- See https://github.com/topics/neovim-colorscheme to find one you like and set it here
return {
  'ellisonleao/gruvbox.nvim',
  priority = 1000,
  cond = not vim.g.vscode,
  opts = {
    overrides = {
      SignColumn = { bg = 'NONE' },
      Folded = { bg = 'NONE' },
      FoldColumn = { bg = 'NONE' },
      GruvboxRedSign = { bg = 'NONE' },
      GruvboxGreenSign = { bg = 'NONE' },
      GruvboxYellowSign = { bg = 'NONE' },
      GruvboxBlueSign = { bg = 'NONE' },
      GruvboxPurpleSign = { bg = 'NONE' },
      GruvboxAquaSign = { bg = 'NONE' },
      GruvboxOrangeSign = { bg = 'NONE' },
    },
  },
  lazy = false,
  config = function(_, opts)
    require('gruvbox').setup(opts)
    vim.o.background = 'dark'
    vim.cmd.colorscheme('gruvbox')
    vim.api.nvim_set_hl(0, 'CursorLineFold', { fg = '#928374', bg = '#3c3836', force = true })
    vim.api.nvim_set_hl(0, 'NvimTreeWindowPicker', { link = 'IncSearch', force = true })
  end,
}
