local function load_win_resizer()
  require('win-resizer').setup({ ignore_filetypes = { 'neo-tree', 'NvimTree', 'Avante', 'AvanteInput' } })
end

local function load_which_key()
  -- BUG:
  -- this plugin has many bugs
  -- In insert mode, <C-O> with some other keys may not work as expected
  require('which-key').setup({
    preset = 'helix',
    delay = function() return vim.o.timeoutlen end,
    sort = { 'order', 'group', 'desc', 'mod' },
    keys = { scroll_down = '', scroll_up = '' },
    icons = { rules = false },
    triggers = {
      { '<auto>', mode = 'nxso' },
      { 'b', mode = 'n' },
    },
    plugins = {
      registers = {
        format = function(value) return value:gsub('^%s+', ''):gsub('%s+$', ''):sub(1, 10) end,
      },
    },
    -- BUG:
    -- See https://github.com/folke/which-key.nvim/issues/1033
    filter = function(mapping)
      if mapping.desc and mapping.desc:match('[Nn]op') then return false end
      -- stylua: ignore start
      if
        (mapping.mode == 'n' or mapping.mode == 'o' or mapping.mode == 'x' or mapping.mode == 'v' or mapping.mode == 's')
        and vim.tbl_contains(
          { 'b', 'c', 'd', 'e', 'f', 'h', 'j', 'k', 'l', 'r', 't', 'v', 'w', 'y',
            'B', 'E', 'F', 'G', 'T', 'V', 'W',
            '~', '$', '%', ',', ';', '<', '>', '/', '?', '^', '0' }, mapping.lhs)
      then
      -- stylua: ignore end
        return false
      end
      return true
    end,
    defer = function() return false end,
  })
  require('which-key').add({
    { '<leader>g', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Git', mode = 'nx' },
    { '<leader>x', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Conflict' },
    { '<leader>xd', buffer = true, icon = { icon = ' ', color = 'red' }, desc = 'Diff' },
    { '<leader>tg', buffer = true, icon = { icon = ' ', color = 'yellow' }, desc = 'Git' },
    { '<leader>t', icon = { icon = ' ', color = 'yellow' }, desc = 'Toggle' },
    { '<leader>s', icon = { icon = ' ', color = 'green' }, desc = 'Search' },
    { '<leader>sf', icon = { icon = ' ', color = 'green' }, desc = 'File' },
    { '<leader>sc', icon = { icon = ' ', color = 'green' }, desc = 'Content' },
    { 'a', desc = 'Around', mode = 'xo' },
    { 'i', desc = 'Inside', mode = 'xo' },
    { '*', desc = 'Search Backward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
    { '#', desc = 'Search Forward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
    { '@', desc = 'Execute Register', mode = 'x' },
    { 'Q', desc = 'Repeat Last Recorded Macro', mode = 'x' },
    { '<m-s>', desc = 'Swap', icon = { icon = '󰓡 ', color = 'green' } },
    { '<m-s>p', desc = 'Previous', icon = { icon = '󰓡 ', color = 'green' } },
    { '<m-s>n', desc = 'Next', icon = { icon = '󰓡 ', color = 'green' } },
    { '[', desc = 'Previous', mode = 'nxo', icon = { icon = ' ', color = 'green' } },
    { ']', desc = 'Next', mode = 'nxo', icon = { icon = ' ', color = 'green' } },
    { 'gr', desc = 'LSP', mode = 'nx', icon = { icon = ' ', color = 'orange' } },
  })
end

load_win_resizer()
load_which_key()
