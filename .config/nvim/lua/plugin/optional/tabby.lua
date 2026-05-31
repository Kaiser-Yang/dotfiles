local u = require('utils')
u.gh('nvim-tree/nvim-web-devicons')
u.gh('nanozuki/tabby.nvim')
local theme = {
  fill = 'TabLineFill',
  tab = 'TabLine',
  current_tab = 'TabLineSel',
  win = 'TabLine',
  current_win = 'TabLineSel',
}
local color = function(abs)
  local _, color = require'nvim-web-devicons'.get_icon_color(vim.fn.fnamemodify(abs, ':t'), vim.fn.fnamemodify(abs, ':e'))
  return color
end

local function build_file_icon(win)
  return {
    win.file_icon(),
    hl = {fg = color(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win.id)))}
  }
end

vim.o.showtabline = 2
require('tabby').setup({
  line = function(line)
    return {
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        local name = tab.name()
        local index = string.find(name, '%[%d')
        local tab_name = index and string.sub(name, 1, index - 1) or name
        return {
          line.sep(' ', hl, theme.fill),
          tab.is_current() and '' or '󰆣',
          build_file_icon(tab.current_win()),
          tab.number(),
          tab_name,
          tab.close_btn(''),
          hl = hl,
          margin = ' ',
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        local hl = win.is_current() and theme.current_win or theme.win
        return {
          line.sep(' ', hl, theme.fill),
          win.is_current() and '' or '',
          build_file_icon(win),
          win.buf_name(),
          hl = hl,
          margin = ' ',
        }
      end),
      hl = theme.fill,
    }
  end,
})
