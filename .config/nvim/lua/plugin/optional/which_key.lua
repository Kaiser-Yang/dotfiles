local u = require('utils')
u.gh('Kaiser-Yang/which-key.nvim')

local w = require('which-key')
-- BUG:
-- this plugin has many bugs
-- In insert mode, <C-O> with some other keys may not work as expected
-- "grn" will never be able to visual replace with "n"
w.setup({
  preset = 'helix',
  delay = 0,
  sort = { 'order', 'group', 'alphanum', 'mod' },
  keys = { scroll_down = '', scroll_up = '' },
  icons = { rules = false },
  triggers = { { '<auto>', mode = 'nxo' }, { 'b', mode = 'n' }, { 'a', mode = 'x' }, { 'i', mode = 'x' } },
  plugins = { registers = { format = function(value) return value:gsub('^%s+', ''):gsub('%s+$', ''):sub(1, 100) end } },
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
  defer = function(ctx) return ctx.mode ~= 'o' end,
})
w.add({
  { '<leader>g', icon = { icon = ' ', color = 'red' }, desc = 'Git', mode = 'nx' },
  { '<leader>x', icon = { icon = ' ', color = 'red' }, desc = 'Conflict' },
  { '<leader>xd', icon = { icon = ' ', color = 'red' }, desc = 'Diff' },
  { '<leader>d', icon = { icon = ' ', color = 'orange' }, desc = 'Dap', mode = 'n' },
  { '<leader>tg', icon = { icon = ' ', color = 'orange' }, desc = 'Git' },
  { '<leader>t', icon = { icon = ' ', color = 'orange' }, desc = 'Toggle' },
  { '<leader>r', icon = { icon = ' ', color = 'orange' } },
  { '<leader><leader>', icon = { icon = ' ', color = 'orange' }, desc = 'Flash' },
  { 'gr', desc = 'LSP', mode = 'nx', icon = { icon = ' ', color = 'orange' } },
  { '<c-w>', desc = 'Window', mode = 'n', icon = { icon = ' ', color = 'orange' } },
  { 'a', desc = 'Around', mode = 'xo', icon = { icon = ' ', color = 'orange' } },
  { 'i', desc = 'Inside', mode = 'xo', icon = { icon = '◌ ', color = 'orange' } },
  { '[', desc = 'Previous', mode = 'nxo', icon = { icon = ' ', color = 'blue' } },
  { ']', desc = 'Next', mode = 'nxo', icon = { icon = ' ', color = 'blue' } },
  { '<leader>s', icon = { icon = ' ', color = 'green' }, desc = 'Search' },
  { '<leader>f', icon = { icon = ' ', color = 'green' }, desc = 'File' },
  { '*', desc = 'Search Backward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
  { '#', desc = 'Search Forward', icon = { icon = ' ', color = 'green' }, mode = 'x' },
  { '<m-s>', desc = 'Swap', icon = { icon = '󰓡 ', color = 'green' } },
  { '<m-s>p', desc = 'Previous', icon = { icon = '󰓡 ', color = 'green' } },
  { '<m-s>n', desc = 'Next', icon = { icon = '󰓡 ', color = 'green' } },
})
