local u = require('utils')
vim.pack.add({ u.gh('nvim-treesitter/nvim-treesitter', 'main') }, { confirm = false })

if vim.fn.executable('tree-sitter') == 0 then return end
if #vim.g.lightboat_opt.treesitter_ensure_installed > 0 then
  local ts = require('nvim-treesitter')
  local installed = ts.get_installed()
  local not_installed = vim.tbl_filter(
    function(lang) return not vim.tbl_contains(installed, lang) end,
    vim.g.lightboat_opt.treesitter_ensure_installed
  )
  if #not_installed > 0 then ts.install(not_installed) end
end
