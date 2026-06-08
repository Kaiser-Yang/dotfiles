local u = require('utils')
local M = {}

local last_count = 1
--- @type table<string, string>
local l = {
  surround_normal = '<plug>(nvim-surround-normal)',
  surround_normal_current = '<plug>(nvim-surround-normal-cur)',
  surround_normal_line = '<plug>(nvim-surround-normal-line)',
  surround_normal_current_line = '<plug>(nvim-surround-normal-cur-line)',
  surround_insert = '<plug>(nvim-surround-insert)',
  surround_insert_line = '<plug>(nvim-surround-insert-line)',
  surround_delete = '<plug>(nvim-surround-delete)',
  surround_change = '<plug>(nvim-surround-change)',
  surround_change_line = '<plug>(nvim-surround-change-line)',
}
local function hack(suffix)
  suffix = suffix or ''
  local op = vim.v.operator
  if op ~= 'g@' then last_count = vim.v.count1 end
  local res
  if op == 'y' then
    res = l['surround_normal' .. suffix]
  elseif op == 'd' then
    res = l['surround_delete' .. suffix]
  elseif op == 'c' then
    res = l['surround_change' .. suffix]
  elseif op == 'g@' and vim.o.operatorfunc:find('nvim%-surround') then
    res = l['surround_normal_current' .. suffix]
  end
  if not res then return false end
  local cnt = (op == 'g@' and last_count or vim.v.count1)
  local key = (cnt > 1 and cnt or '') .. res
  vim.schedule_wrap(u.key.feed)(key, 'n')
  return '<esc>'
end

--- @param keycode string
--- @return string|boolean
local function autopair(keycode)
  local core = require('ultimate-autopair.core')
  core.get_run(keycode)
  local res = core.run_run(keycode)
  u.key.feed(res, 'n', false)
  return res and res ~= ''
end

function M.auto_pair_wrap(key)
  return function() return autopair(vim.keycode(key)) end
end

function M.surround_visual()
  if not _G.loaded['nvim-surround'] then return false end
  return '<plug>(nvim-surround-visual)'
end

function M.surround_visual_line()
  if not _G.loaded['nvim-surround'] then return false end
  return '<plug>(nvim-surround-visual-line)'
end

function M.hack_wrap(suffix)
  return function()
    if not _G.loaded['nvim-surround'] then return false end
    return hack(suffix)
  end
end

function M.smart_tab()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.schedule(function()
    if string.sub(vim.api.nvim_get_current_line(), 1, cursor_pos[2]):match('^%s*$') then
      return
    elseif vim.deep_equal(cursor_pos, vim.api.nvim_win_get_cursor(0)) then
      if M.auto_pair_wrap('<m-tab>')() then return end
      local res = ''
      if vim.bo.expandtab then
        res = string.rep(' ', vim.bo.shiftwidth)
      else
        res = '<c-v><tab>'
      end
      u.key.feed(res, 'nt')
    end
  end)
  return '<tab>'
end

return M
