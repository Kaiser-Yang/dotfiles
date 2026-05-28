local u = require('utils')
u.gh('Kaiser-Yang/resolve.nvim')

require('resolve').setup({
  default_keymaps = false,
  auto_detect_enabled = false,
  on_conflict_detected = function(args) vim.diagnostic.enable(false, { bufnr = args.bufnr }) end,
  on_conflicts_resolved = function(args) vim.diagnostic.enable(true, { bufnr = args.bufnr }) end,
})
