vim.schedule(function()
  local u = require('utils')
  local specs = {
    -- dadbod works as a database client
    'tpope/vim-dadbod',
    'kristijanhusak/vim-dadbod-completion',
    'kristijanhusak/vim-dadbod-ui',
    -- DAP for debugging
    'igorlfs/nvim-dap-view',
    'theHamsta/nvim-dap-virtual-text',
    'mfussenegger/nvim-dap',
    -- beautiful status line
    'nvim-lualine/lualine.nvim',
    -- highlight the "TODO" comments
    'folke/todo-comments.nvim',
    -- indent line
    'saghen/blink.indent',
    -- competition test tool
    'xeluxee/competitest.nvim',
    -- easy way to resize windows
    'Kaiser-Yang/win-resizer.nvim',
    -- auto insert "end" for some languages
    'RRethy/nvim-treesitter-endwise',
    -- highlight pairs
    'saghen/blink.download',
    { 'saghen/blink.pairs', vim.version.range('*') },
    -- pairs plugin
    'altermo/ultimate-autopair.nvim',
  }
  for _, spec in ipairs(specs) do
    if type(spec) == 'table' then
      ---@diagnostic disable-next-line: param-type-mismatch
      table.insert(specs, u.gh(unpack(spec)))
    else
      table.insert(specs, u.gh(spec))
    end
  end
  vim.pack.add(specs, { confirm = false })

  require('plugin.optional.blink_indent')
  require('plugin.optional.blink_pairs')
  require('plugin.optional.competitest')
  require('plugin.optional.dadbod')
  require('plugin.optional.dap')
  require('plugin.optional.endwise')
  require('plugin.optional.lualine')
  require('plugin.optional.todo_comments')
  require('plugin.optional.ultimate_autopair')
  require('plugin.optional.win_resizer')
end)
