vim.g.conform_on_save = true
vim.g.treesitter_highlight_auto_start = true
vim.g.treesitter_foldexpr_auto_set = true
vim.g.big_file_limit = 3 * 1024 * 1024 -- 3 MB
vim.g.big_file_average_every_line = nil -- Unit: B, nil for no limit
vim.g.treesitter_ensure_installed = {
  'bash',
  'c',
  'cpp',
  'diff',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'git_config',
  'git_rebase',
  'go',
  'json',
  'markdown_inline',
  'python',
  'zsh',
}
--- @type table<string, boolean>
_G.loaded = {}

vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    gotmplhtml = 'gotmplhtml',
  },
})
vim.treesitter.language.register('html', 'gotmplhtml')
require('vim._core.ui2').enable({ msg = { targets = 'msg' } })
require('config')
require('plugin')
