local on_mac = vim.fn.has('mac') == 1
--- @type LightBoat.Opts
vim.g.lightboat_opts = {
  lsp = { config = { rime_ls = require('rime_ls') } },
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

return {
  {
    'zbirenbaum/copilot.lua',
    enabled = not on_mac and vim.fn.executable('node') == 1 and vim.fn.executable('curl') == 1,
  },
  { 'yetone/avante.nvim', enabled = not on_mac },
  {
    'AndreM222/copilot-lualine',
    enabled = not on_mac and vim.fn.executable('node') == 1 and vim.fn.executable('curl') == 1,
  },
}
