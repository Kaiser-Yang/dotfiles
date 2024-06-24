
-- This must be the first thing to do, otherwise when opeing directory with nvim, nvim will quit
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.mapleader = ' '

AutoCloseFileType = {
    NvimTree = true,
    help = true,
    aerial = true,
}
-- first time installation may fail, so we use pcall
-- we first load all the plugins
pcall(require, 'lazy_nvim')
pcall(require, 'key_mapping')
-- place this at the last so that the autocmd can be effective
pcall(require, 'core')
