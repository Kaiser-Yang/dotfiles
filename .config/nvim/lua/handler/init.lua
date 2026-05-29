local u = require('utils')

local M = {
  builtin = require('handler.builtin'),
  completion = require('handler.completion'),
  dap = require('handler.dap'),
  git = require('handler.git'),
  indent = require('handler.indent'),
  lsp = require('handler.lsp'),
  markdown = require('handler.markdown'),
  pair = require('handler.pair'),
  repmove = require('handler.repmove'),
  telescope = require('handler.telescope'),
  tree = require('handler.tree'),
  treesitter = require('handler.treesitter'),
}

function M.format(opts)
  if not _G.loaded['conform.nvim'] then return false end
  opts = vim.tbl_deep_extend('force', { bufnr = vim.api.nvim_get_current_buf(), async = true }, opts or {})
  require('conform').format(opts, function(err)
    if err then return end
    vim.schedule_wrap(require('guess-indent').set_from_buffer)(opts.bufnr, true, true)
  end)
  return '<esc>'
end

local first_to_second = {
  top = 'bottom',
  bottom = 'top',
  left = 'right',
  right = 'left',
}
--- @param border 'top' | 'bottom' | 'left' | 'right'
--- @param reverse? boolean
--- @param abs_delta? integer
--- @param first 'top' | 'bottom' | 'left' | 'right' | nil
function M.resize_wrap(border, reverse, abs_delta, first)
  abs_delta = abs_delta or 3
  first = first or vim.tbl_contains({ 'left', 'right' }, border) and 'right' or 'top'
  local second = first_to_second[first]
  local delta = (border == first) and abs_delta or -abs_delta
  return function()
    if not _G.loaded['win-resizer.nvim'] then return false end
    local resize = require('win.resizer').resize
    local actual_delta = delta * vim.v.count1
    if reverse then
      return resize(0, second, -actual_delta, true)
        or resize(0, first, actual_delta, true)
        or resize(0, second, -actual_delta, false)
        or resize(0, first, actual_delta, false)
    else
      return resize(0, first, actual_delta, true)
        or resize(0, second, -actual_delta, true)
        or resize(0, first, actual_delta, false)
        or resize(0, second, -actual_delta, false)
    end
  end
end

function M.toggle_context()
  local c = require('treesitter-context')
  local status = not c.enabled()
  c.toggle()
  u.toggle_notify('Treesitter Context', status, { title = 'Context' })
  return true
end

function M.search_session()
  if not _G.loaded['auto-session'] then return false end
  require('auto-session').search()
  return true
end

return M
