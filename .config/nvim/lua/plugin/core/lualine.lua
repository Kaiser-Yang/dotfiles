local u = require('utils')
vim.pack.add({
  u.gh('nvim-tree/nvim-web-devicons'),
  u.gh('nvim-lualine/lualine.nvim'),
}, { confirm = false })

require('lualine').setup({
  options = {
    globalstatus = true,
    always_divide_middle = true,
    disabled_filetypes = {
      winbar = {
        'dapui_console',
        'dapui_stacks',
        'dapui_watches',
        'dapui_breakpoints',
        'dapui_hover',
        'dap-repl',
        'dap-view',
        'dap-view-term',
        'dap-view-help',
      },
    },
    ignore_focus = { 'CompetiTest' },
  },
  inactive_winbar = {
    lualine_a = {
      {
        '%=',
        cond = function() return vim.bo.filetype == 'CompetiTest' end,
        color = 'WinBarNC',
      },
      {
        function() return vim.b.competitest_title or 'CompetiTest' end,
        cond = function() return vim.bo.filetype == 'CompetiTest' end,
        color = 'lualine_a_normal',
      },
      {
        '%=',
        cond = function() return vim.bo.filetype == 'CompetiTest' end,
        color = 'WinBarNC',
      },
    },
  },
  sections = {
    lualine_c = { 'filename', 'filesize' },
    lualine_x = { 'searchcount', 'lsp_status', 'encoding', 'fileformat', 'filetype' },
  },
})
