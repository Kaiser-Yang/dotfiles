return {
  'nvim-lualine/lualine.nvim',
  opts = {
    sections = {
      lualine_x = {
        { function() return vim.g.rime_enabled and 'ㄓ' or '' end },
      },
    },
  },
}
