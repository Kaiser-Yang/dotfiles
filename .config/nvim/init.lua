vim.loader.enable()
vim.g.lint = true
vim.g.color = true
vim.g.flash = true
vim.g.autotag = true
vim.g.conform = true
vim.g.treesitter_highlight = true
vim.g.treesitter_foldexpr = true
vim.g.big_file_limit = 3 * 1024 * 1024 -- 3 MB
vim.g.big_file_average_every_line = nil -- Unit: B, nil for no limit
vim.g.treesitter_ensure_installed = {
  'bash',
  'cpp',
  'diff',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'git_config',
  'git_rebase',
  'go',
  'json',
  'python',
  'zsh',
}
--- @type table<string, boolean>
_G.loaded = {}
--- @type integer
_G.autocmd_group = vim.api.nvim_create_augroup('LightBoat', { clear = true })
--- @type string?
_G.last_args = nil
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
