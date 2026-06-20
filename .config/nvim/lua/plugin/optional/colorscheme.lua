local u = require('utils')
u.gh('catppuccin/nvim', nil, 'catppuccin')
require('catppuccin').setup({
  compile_path = vim.fn.stdpath('cache') .. '/catppuccin',
  default_integrations = false,
  integrations = {
    blink_cmp = {
      enabled = true,
      style = 'boarded',
    },
    blink_indent = true,
    dadbod_ui = true,
    dap = true,
    dropbar = {
      enabled = true,
      color_mode = true,
    },
    fidget = true,
    flash = true,
    gitsigns = true,
    grug_far = true,
    lualine = { enabled = true },
    nvim_surround = false,
    nvimtree = true,
    rainbow_delimiters = true,
    telescope = { enabled = true },
    treesitter_context = true,
    render_markdown = true,
    which_key = true,
  },
  custom_highlights = function(C)
    -- DAP
    local signs = {
      DapStopped = { text = '▶', texthl = 'DapStopped', linehl = 'debugPC' },
      DapLogPoint = { text = '', texthl = 'DapLogPoint' },
      DapBreakpoint = { text = '●', texthl = 'DapBreakpoint' },
      DapBreakpointRejected = { text = 'x', texthl = 'DapBreakpointRejected' },
      DapBreakpointCondition = { text = '', texthl = 'DapBreakpointCondition' },
    }
    for name, opts in pairs(signs) do
      vim.fn.sign_define(name, opts)
    end
    return {
      TelescopeSelection = { fg = 'NONE' },
      BlinkIndentPurple = { link = 'BlinkIndentViolet' },
      BlinkIndentPurpleUnderline = { link = 'BlinkIndentVioletUnderline' },
      TabLineFill = { bg = C.mantle },
      TabLine = { fg = C.surface1, bg = C.mantle },
      TabLineSel = { fg = C.text, bg = C.base, style = { 'bold' } },
      TabLineJumpKey = { fg = C.red, style = { 'bold', 'italic' } },
      FlashPromptIcon = { fg = C.orange },
    }
  end,
})
vim.cmd('colorscheme catppuccin-nvim')
