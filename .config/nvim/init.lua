vim.g.lightboat_opt = {
  --- @type string[]
  treesitter_ensure_installed = { 'c', 'cpp', 'diff', 'go', 'javascript', 'json', 'python', 'sql' },
  --- @type string[]
  mason_ensure_installed = {
    -- LSP
    'clangd',
    'gopls',
    'lua-language-server',
    'pyright',
    'thriftls',

    -- Formatters
    'black',
    'clang-format',
    'goimports',
    'prettier',
    'sql-formatter',
    'stylua',

    -- Debuggers
    'codelldb',
    'debugpy',
    'delve',
  },
}
vim.g.conform_on_save = true
vim.g.treesitter_highlight_auto_start = true
vim.g.treesitter_foldexpr_auto_set = true
vim.g.big_file_limit = 3 * 1024 * 1024 -- 3 MB
vim.g.big_file_average_every_line = nil -- Unit: B, nil for no limit

require('vim._core.ui2').enable()
require('config')
require('plugin')
