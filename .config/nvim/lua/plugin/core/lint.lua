local u = require('utils')
u.gh('mfussenegger/nvim-lint')
local l = require('lint')
l.linters_by_ft = {
  c = { 'clangtidy' },
  cpp = { 'clangtidy' },
  go = { 'golangcilint' },
  lua = { 'luacheck' },
  markdown = { 'markdownlint' },
  python = { 'ruff' },
  sh = { 'shellcheck' },
  zsh = { 'shellcheck' },
}
vim.list_extend(l.linters.shellcheck.args, { '-x' })
