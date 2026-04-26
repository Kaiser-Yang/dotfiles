-- Disable entire built-in ftplugin mappings to avoid conflicts.
-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
vim.g.no_plugin_maps = true

-- We use another explorer instead of netrw, so disable it
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ' '
vim.o.numberwidth = 1
vim.o.winborder = 'rounded'
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.opt.jumpoptions:append({ 'stack', 'view' })
vim.o.termguicolors = true
vim.o.colorcolumn = '100'
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'tab:»-,trail:·,lead:·,nbsp:¤'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.foldopen:remove('hor')
vim.o.foldlevel = 99999
vim.o.foldcolumn = '1'
vim.o.fillchars = 'fold: ,foldopen:,foldclose:'
vim.o.splitright = true
vim.o.confirm = true
vim.o.cmdwinheight = 10
vim.o.showmode = false
vim.o.ttimeout = false

local function fold_clickable()
  local lnum = vim.v.lnum
  return vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) and vim.v.virtnum == 0
end
_G.get_statuscol = function() return '%s%l%=' .. (fold_clickable() and '%C' or ' ') .. ' ' end
vim.o.statuscolumn = '%!v:lua.get_statuscol()'
