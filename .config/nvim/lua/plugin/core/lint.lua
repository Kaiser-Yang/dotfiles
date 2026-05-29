local u = require('utils')
u.gh('mfussenegger/nvim-lint')
require('lint').linters_by_ft = {
  c = { 'clangtidy' },
  cpp = { 'clangtidy' },
  go = { 'golangcilint' },
  lua = { 'luacheck' },
  markdown = { 'markdownlint' },
  python = { 'ruff' },
  sh = { 'shellcheck' },
  zsh = { 'zsh' },
}
