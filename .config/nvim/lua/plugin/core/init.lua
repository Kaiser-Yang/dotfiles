-- File explorer
require('plugin.core.nvim_tree')
vim.schedule(function()
  -- Completion engine (blink)
  require('plugin.core.blink_cmp')
  -- Code formatter
  require('plugin.core.conform')
  -- Debug Adapter Protocol (DAP) integration
  require('plugin.core.dap')
  -- Git signs in the gutter + hunk actions (per buffer)
  require('plugin.core.gitsigns')
  -- Detect/guess indentation style per buffer
  require('plugin.core.guess_indent')
  -- Lint
  require('plugin.core.lint')
  -- Global keymaps manager / layer system
  require('plugin.core.maplayer')
  -- Repeat last motion with `;` and `,`
  require('plugin.core.repmove')
  -- Git conflict resolver
  require('plugin.core.resolve')
  -- Add/delete/change surrounding pairs
  require('plugin.core.surround')
  -- Fuzzy finder / pickers (Telescope)
  require('plugin.core.telescope')
  -- Auto pairs plugin
  require('plugin.core.ultimate_autopair')
end)
