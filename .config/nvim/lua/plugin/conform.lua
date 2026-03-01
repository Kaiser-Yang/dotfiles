return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      go = { 'goimports' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      python = { 'black' },
      sql = { 'sql-formatter' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
    },
  },
}
