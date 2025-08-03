local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--- @type LightBoat.Opts
vim.g.lightboat_opts = {}
require('lazy').setup({
  spec = {
    { 'Kaiser-Yang/LightBoat', import = 'lightboat.plugin' },
    { import = 'plugin' },
  },
})
