local u = require('utils')
u.gh('stevearc/conform.nvim')

require('conform').setup({
  notify_no_formatters = false,
  formatters_by_ft = {
    c = { 'clang-format' },
    cpp = { 'clang-format' },
    go = { 'goimports' },
    json = { 'prettier' },
    lua = { 'stylua' },
    markdown = { 'prettier' },
    python = { 'isort', 'black' },
    sh = { 'shfmt' },
    zsh = { 'shfmt' },
  },
  default_format_opts = { lsp_format = 'fallback' },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
