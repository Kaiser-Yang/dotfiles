local u = require('utils')
u.gh('stevearc/conform.nvim')

require('conform').setup({
  notify_no_formatters = false,
  formatters_by_ft = {
    c = { 'clang-format' },
    cpp = { 'clang-format' },
    go = { 'goimports' },
    lua = { 'stylua' },
    python = { 'black' },
    javascript = { 'prettier' },
    sql = { 'sql-formatter' },
    typescript = { 'prettier' },
    markdown = { 'prettier', 'cbfmt' },
    sh = { 'shfmt' },
    json = { 'jq' },
  },
  default_format_opts = { lsp_format = 'fallback' },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
