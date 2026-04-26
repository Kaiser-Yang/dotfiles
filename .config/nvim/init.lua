vim.g.lightboat_opt = {
  --- @type string[]
  treesitter_ensure_installed = { 'cpp', 'go', 'python', 'sql', 'json', 'javascript' },
  --- @type string[]
  mason_ensure_installed = {
    'lua-language-server',
    'clangd',
    'pyright',
    'gopls',
    'typescript-language-server',
    'thriftls',
    'stylua',
    'clang-format',
    'black',
    'goimports',
    'prettier',
    'sql-formatter',
    'codelldb',
    'delve',
    'debugpy',
  },
}
vim.g.highlight_on_yank_limit = 1024 * 1024 -- 1 MB
vim.g.highlight_on_yank_duration = 300 -- Unit: ms
vim.g.conform_on_save = true
vim.g.conform_on_save_reguess_indent = true
vim.g.conform_formatexpr_auto_set = true
vim.g.treesitter_highlight_auto_start = true
vim.g.treesitter_foldexpr_auto_set = true
vim.g.big_file_limit = 3 * 1024 * 1024 -- 3 MB
vim.g.big_file_average_every_line = 1000 -- Unit: B

require('plugin')
require('config')
require('vim._core.ui2').enable()
