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
  },
  default_format_opts = { lsp_format = 'fallback', stop_after_first = true },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
