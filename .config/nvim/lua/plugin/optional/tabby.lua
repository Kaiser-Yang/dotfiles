local u = require('utils')
u.gh('nanozuki/tabby.nvim')
local theme = {
  fill = 'TabLineFill',
  tab = 'TabLine',
  current_tab = 'TabLineSel',
  win = 'TabLine',
  current_win = 'TabLineSel',
}
vim.o.showtabline = 2
require('tabby').setup({
  line = function(line)
    return {
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep(' ', hl, theme.fill),
          tab.is_current() and '' or '󰆣',
          tab.number(),
          tab.name(),
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
          win.buf_name(),
          hl = hl,
          margin = ' ',
        }
      end),
      hl = theme.fill,
    }
  end,
})
