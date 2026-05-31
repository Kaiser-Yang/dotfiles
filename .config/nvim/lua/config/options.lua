-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- We use another explorer instead of netrw, so disable it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.o.numberwidth = 3
vim.o.winborder = 'rounded'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.opt.jumpoptions:append({ 'stack', 'view' })
vim.o.termguicolors = true
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', lead = '·', nbsp = '␣' }
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.foldopen:remove('hor')
vim.o.foldlevel = 99999
vim.o.foldcolumn = '1'
vim.opt.fillchars = {
  fold = ' ',
  foldopen = '',
  foldclose = '',
  foldsep = ' ',
  foldinner = ' ',
}
vim.o.splitright = true
vim.o.autowriteall = true
vim.o.cmdwinheight = 10
vim.o.showmode = false
vim.o.cmdheight = 0
vim.o.showcmd = true
vim.o.showcmdloc = 'statusline'
vim.o.updatetime = 300
vim.o.statuscolumn = '%s%l%=%C '
vim.o.undofile = true
vim.o.scrolloff = 5
vim.o.concealcursor = 'nvic'
vim.o.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-TermCursor'
vim.o.shadafile = require('utils').shadafile()
vim.opt.sessionoptions:remove('buffers')
vim.opt.sessionoptions:remove('blank')
