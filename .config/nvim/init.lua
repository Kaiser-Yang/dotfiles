vim.loader.enable()
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
  pattern = {
    ['.*'] = {
      function(path, buf)
        if not path or not buf or vim.bo[buf].filetype == 'bigfile' then return end
        if path ~= vim.fs.normalize(vim.api.nvim_buf_get_name(buf)) then return end
        if not require('utils').buffer.big(buf) then return end
        vim.schedule(function() vim.bo[buf].syntax = vim.filetype.match({ buf = buf }) or '' end)
        return 'bigfile'
      end,
    },
  },
})
vim.treesitter.language.register('html', 'gotmplhtml')
require('vim._core.ui2').enable({ msg = { targets = 'msg' } })
require('config')
require('plugin')
vim.cmd.packadd('nvim.undotree')
