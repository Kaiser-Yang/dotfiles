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

local on_mac = vim.fn.has('mac') == 1
--- @type LightBoat.Opts
vim.g.lightboat_opts = {
  mason = { mason_bin_first = not on_mac },
  lsp = { config = { rime_ls = require('rime_ls') } },
  snack = {
    keys = {
      ['<leader>r'] = {
        prev = {
          'big_file_check',
          function()
            if not vim.fn.expand('%:p') or not vim.bo.filetype == 'cpp' then return false end
            local file_dir = vim.fn.expand('%:p:h')
            local file_name = vim.fn.expand('%:t:r')
            if vim.fn.filereadable(file_dir .. '/' .. file_name .. '_0.in') == 0 then
              vim.cmd('CompetiTest receive testcases')
              return true
            end
            vim.cmd('CompetiTest run')
            return true
          end,
        },
      },
    },
  },
}
require('lazy').setup({
  spec = {
    { 'Kaiser-Yang/LightBoat', import = 'lightboat.plugin' },
    { import = 'plugin' },
    {
      'zbirenbaum/copilot.lua',
      enabled = not on_mac and vim.fn.executable('node') == 1 and vim.fn.executable('curl') == 1,
    },
    { 'yetone/avante.nvim', enabled = not on_mac },
    {
      'AndreM222/copilot-lualine',
      enabled = not on_mac and vim.fn.executable('node') == 1 and vim.fn.executable('curl') == 1,
    },
  },
})
