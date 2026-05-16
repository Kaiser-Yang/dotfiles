local u = require('utils')
vim.pack.add(
  { u.gh('nvim-tree/nvim-web-devicons'), u.gh('MeanderingProgrammer/render-markdown.nvim') },
  { confirm = false }
)

local function ts_context_wrap(status)
  return function()
    local cur_win = vim.api.nvim_get_current_win()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative == 'win' and cfg.row == 0 and cfg.win == cur_win and vim.w[win].treesitter_context then
        local buf = vim.api.nvim_win_get_buf(win)
        local new_ft = status and 'markdown' or ''
        if new_ft ~= vim.bo[buf].filetype then vim.bo[buf].filetype = new_ft end
        require('render-markdown.core.manager').set_buf(buf, status)
      end
    end
  end
end

require('render-markdown').setup({
  win_options = { concealcursor = { rendered = 'nvic' } },
  on = {
    render = ts_context_wrap(true),
    clear = ts_context_wrap(false),
  },
})
