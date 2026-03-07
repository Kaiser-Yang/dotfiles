return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = { ignore_focus = { 'CompetiTest' } },
    inactive_winbar = {
      lualine_a = {
        {
          '%=',
          cond = function() return vim.bo.filetype == 'CompetiTest' end,
          color = { bg = 'gray' },
        },
        {
          function() return vim.b.competitest_title or 'CompetiTest' end,
          cond = function() return vim.bo.filetype == 'CompetiTest' end,
          color = 'lualine_a_normal',
        },
        {
          '%=',
          cond = function() return vim.bo.filetype == 'CompetiTest' end,
          color = { bg = 'gray' },
        },
      },
    },
  },
}
