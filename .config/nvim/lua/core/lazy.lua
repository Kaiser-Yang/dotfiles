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
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if (vim.v.event.regname == '' or vim.v.event.regname == '"') and vim.v.event.operator == 'y' then
      vim.fn.setreg('+', vim.fn.getreg('"'), vim.v.event.regtype)
    end
  end,
})
--- @type LightBoat.Opts
vim.g.lightboat_opts = {
  buffer_line = {
    keys = {
      ['H'] = false,
      ['L'] = false,
    },
  },
  mason = {
    mason_bin_first = not on_mac,
    ensure_installed = {
      ['lemminx'] = false,
      ['json-lsp'] = false,
      ['eslint-lsp'] = false,
      ['vue-language-server'] = false,
      ['yaml-language-server'] = false,
      ['typescript-language-server'] = false,
      ['tailwindcss-language-server'] = false,
    },
  },
  yanky = {
    keys = {
      ['<leader>y'] = false,
      ['<leader>Y'] = false,
    },
  },
  lsp = {
    config = {
      rime_ls = require('rime_ls'),
      lemminx = false,
      jsonls = false,
      eslint = false,
      vue_ls = false,
      yamlls = false,
      ts_ls = false,
      tailwindcss = false,
    },
  },
  snack = {
    keys = {
      ['<leader>r'] = {
        prev = {
          'big_file_check',
          function()
            if not vim.fn.expand('%:p'):match('OJProblems') or vim.bo.filetype ~= 'cpp' then return false end
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
  treesitter = {
    keys = {
      ['s'] = false,
      ['snf'] = false,
      ['snc'] = false,
      ['snl'] = false,
      ['snb'] = false,
      ['snr'] = false,
      ['snp'] = false,
      ['sni'] = false,
      ['spf'] = false,
      ['spc'] = false,
      ['spl'] = false,
      ['spb'] = false,
      ['spr'] = false,
      ['spp'] = false,
      ['spi'] = false,
    },
  },
  keymap = {
    keys = {
      ['b'] = false,
      ['w'] = false,
      ['B'] = false,
      ['W'] = false,
      ['ge'] = false,
      ['e'] = false,
      ['gE'] = false,
      ['E'] = false,
      ['N'] = false,
      ['n'] = false,
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
    { 'NeogitOrg/neogit', enabled = false },
  },
})
