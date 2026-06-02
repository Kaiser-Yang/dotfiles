local M = {}
local u = require('utils')

local function previous_todo()
  if not _G.loaded['todo-comments.nvim'] then return false end
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    require('todo-comments').jump_prev()
  end
  return true
end

local function flash_wrap(key)
  return function()
    if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return u.get_cnt_prefix() .. key end
    local Repeat = require('flash.repeat')
    local Config = require('flash.config')
    local Flash = require('flash/plugins/char')
    local ignorecase = vim.o.ignorecase
    local smartcase = vim.o.smartcase
    vim.o.ignorecase = false
    vim.o.smartcase = false
    Flash.jumping = true
    local autohide = Config.get('char').autohide
    if Repeat.is_repeat then
      Flash.jump_labels = false
      Flash.state:jump({ count = vim.v.count1 })
    else
      Flash.jump(key)
    end
    vim.schedule(function()
      Flash.jumping = false
      if Flash.state and autohide then Flash.state:hide() end
      vim.o.ignorecase = ignorecase
      vim.o.smartcase = smartcase
    end)
    return true
  end
end

local nvim_terminal_prompt_ns = vim.api.nvim_create_namespace('nvim.terminal.prompt')
local function jump_to_prompt(ns, win, buf, count)
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))
  local start = -1
  local end_ ---@type 0|-1
  if count > 0 then
    start = row
    end_ = -1
  elseif count < 0 then
    -- Subtract 2 because row is 1-based, but extmarks are 0-based
    start = row - 2
    end_ = 0
  end

  if start < 0 then return end

  local extmarks = vim.api.nvim_buf_get_extmarks(buf, ns, { start, col }, end_, { limit = math.abs(count) })
  if #extmarks > 0 then
    local extmark = assert(extmarks[math.min(#extmarks, math.abs(count))])
    vim.api.nvim_win_set_cursor(win, { extmark[2] + 1, extmark[3] })
  end
end
local function next_todo()
  if not _G.loaded['todo-comments.nvim'] then return false end
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    require('todo-comments').jump_next()
  end
  return true
end

local function previous_plugin()
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    vim.fn.search('^## ', 'bsw')
  end
  return true
end
local function next_plugin()
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    vim.fn.search('^## ', 'sw')
  end
  return true
end

local function next_section_start()
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    require('vim.treesitter._headings').jump({ count = 1 })
  end
  return true
end
local function previous_section_start()
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    require('vim.treesitter._headings').jump({ count = -1 })
  end
  return true
end

local function previous_misspelled() return u.get_cnt_prefix() .. '[s' end
local function next_misspelled() return u.get_cnt_prefix() .. ']s' end

--- @param direction 'next'|'previous'
--- @param position 'start'|'end'
local function go_to(direction, position, query_string, query_group)
  if not _G.loaded['nvim-treesitter-textobjects'] then return false end
  require('nvim-treesitter-textobjects.move')['goto_' .. direction .. '_' .. position](query_string, query_group)
  return true
end

local function next_loop_start() return go_to('next', 'start', '@loop.outer') end
local function next_loop_end() return go_to('next', 'end', '@loop.outer') end
local function next_class_start() return go_to('next', 'start', '@class.outer') end
local function next_class_end() return go_to('next', 'end', '@class.outer') end
local function next_block_start() return go_to('next', 'start', '@block.outer') end
local function next_block_end() return go_to('next', 'end', '@block.outer') end
local function next_return_start() return go_to('next', 'start', '@return.outer') end
local function next_return_end() return go_to('next', 'end', '@return.outer') end
local function next_conditional_start() return go_to('next', 'start', '@conditional.outer') end
local function next_conditional_end() return go_to('next', 'end', '@conditional.outer') end
local function next_function_start() return go_to('next', 'start', '@function.outer') end
local function next_function_end() return go_to('next', 'end', '@function.outer') end
local function next_parameter_start() return go_to('next', 'start', '@parameter.outer') end
local function next_parameter_end() return go_to('next', 'end', '@parameter.outer') end
local function next_statement_start() return go_to('next', 'start', '@statement.outer') end
local function next_statement_end() return go_to('next', 'end', '@statement.outer') end
local function next_call_start() return go_to('next', 'start', '@call.outer') end
local function next_call_end() return go_to('next', 'end', '@call.outer') end
local function previous_loop_start() return go_to('previous', 'start', '@loop.outer') end
local function previous_loop_end() return go_to('previous', 'end', '@loop.outer') end
local function previous_class_start() return go_to('previous', 'start', '@class.outer') end
local function previous_class_end() return go_to('previous', 'end', '@class.outer') end
local function previous_block_start() return go_to('previous', 'start', '@block.outer') end
local function previous_block_end() return go_to('previous', 'end', '@block.outer') end
local function previous_return_start() return go_to('previous', 'start', '@return.outer') end
local function previous_return_end() return go_to('previous', 'end', '@return.outer') end
local function previous_conditional_start() return go_to('previous', 'start', '@conditional.outer') end
local function previous_conditional_end() return go_to('previous', 'end', '@conditional.outer') end
local function previous_function_start() return go_to('previous', 'start', '@function.outer') end
local function previous_function_end() return go_to('previous', 'end', '@function.outer') end
local function previous_parameter_start() return go_to('previous', 'start', '@parameter.outer') end
local function previous_parameter_end() return go_to('previous', 'end', '@parameter.outer') end
local function previous_statement_start() return go_to('previous', 'start', '@statement.outer') end
local function previous_statement_end() return go_to('previous', 'end', '@statement.outer') end
local function previous_call_start() return go_to('previous', 'start', '@call.outer') end
local function previous_call_end() return go_to('previous', 'end', '@call.outer') end

-- BUG:
-- https://github.com/saghen/blink.indent/issues/46
local function indent_goto(direction)
  if not _G.loaded['blink.indent'] then return false end
  local add_to_jumplist = vim.fn.mode('1') == 'n'
  require('blink.indent.motion').operator(direction, add_to_jumplist)()
  return true
end
local function indent_top() return indent_goto('top') end
local function indent_bottom() return indent_goto('bottom') end

local previous_conflict = function()
  if not _G.loaded['resolve.nvim'] then return false end
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    require('resolve').prev_conflict()
  end
  return true
end
local next_conflict = function()
  if not _G.loaded['resolve.nvim'] then return false end
  local cnt1 = vim.v.count1
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  for _ = 1, cnt1 do
    require('resolve').next_conflict()
  end
  return true
end

local previous_hunk = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').nav_hunk('prev')
  return true
end
local next_hunk = function()
  if not _G.loaded['gitsigns.nvim'] then return false end
  require('gitsigns').nav_hunk('next')
  return true
end

local next_diagnostic = function() return vim.diagnostic.jump({ count = vim.v.count1 }) end
local previous_diagnostic = function() return vim.diagnostic.jump({ count = -vim.v.count1 }) end
local function first_diagnostic() return vim.diagnostic.jump({ count = -9999, wrap = false }) end
local function last_diagnostic() return vim.diagnostic.jump({ count = 9999, wrap = false }) end
local cprevious = function() return '<cmd>' .. u.get_cnt_prefix() .. 'cprevious<cr>' end
local cnext = function() return '<cmd>' .. u.get_cnt_prefix() .. 'cnext<cr>' end
local crewind = '<cmd>crewind<cr>'
local clast = '<cmd>clast<cr>'
local function cpfile() return '<cmd>' .. u.get_cnt_prefix() .. 'cpfile<cr>' end
local function cnfile() return '<cmd>' .. u.get_cnt_prefix() .. 'cnfile<cr>' end
local lprevious = function() return '<cmd>' .. u.get_cnt_prefix() .. 'lprevious<cr>' end
local lnext = function() return '<cmd>' .. u.get_cnt_prefix() .. 'lnext<cr>' end
local lrewind = '<cmd>lrewind<cr>'
local llast = '<cmd>llast<cr>'
local function lpfile() return '<cmd>' .. u.get_cnt_prefix() .. 'lpfile<cr>' end
local function lnfile() return '<cmd>' .. u.get_cnt_prefix() .. 'lnfile<cr>' end
local bprevious = function() return '<cmd>' .. u.get_cnt_prefix() .. 'bprevious<cr>' end
local bnext = function() return '<cmd>' .. u.get_cnt_prefix() .. 'bnext<cr>' end
local brewind = '<cmd>brewind<cr>'
local blast = '<cmd>blast<cr>'
local previous = function() return '<cmd>' .. u.get_cnt_prefix() .. 'previous<cr>' end
local next = function() return '<cmd>' .. u.get_cnt_prefix() .. 'next<cr>' end
local rewind = '<cmd>rewind<cr>'
local last = '<cmd>last<cr>'
local previous_prompt = function()
  if vim.bo.buftype ~= 'terminal' then return false end
  jump_to_prompt(nvim_terminal_prompt_ns, 0, vim.api.nvim_get_current_buf(), -vim.v.count1)
  return true
end
local next_prompt = function()
  if vim.bo.buftype ~= 'terminal' then return false end
  jump_to_prompt(nvim_terminal_prompt_ns, 0, vim.api.nvim_get_current_buf(), -vim.v.count1)
  return true
end
local function tprevious() return '<cmd>' .. u.get_cnt_prefix() .. 'tprevious<cr>' end
local function tnext() return '<cmd>' .. u.get_cnt_prefix() .. 'tnext<cr>' end
local trewind = '<cmd>trewind<cr>'
local tlast = '<cmd>tlast<cr>'
local function ptprevious() return '<cmd>' .. u.get_cnt_prefix() .. 'ptprevious<cr>' end
local function ptnext() return '<cmd>' .. u.get_cnt_prefix() .. 'ptnext<cr>' end
local function tabprevious() return '<cmd>tabprevious' .. u.get_cnt_prefix() .. '<cr>' end
local function tabnext()
  local count = vim.v.count1
  local current = vim.api.nvim_get_current_tabpage()
  local total = #vim.api.nvim_list_tabpages()
  local target = (current + count - 1) % total + 1
  vim.api.nvim_set_current_tabpage(target)
  return true
end

local function grug_next_input()
  if not _G.loaded['grug-far.nvim'] or vim.bo.filetype ~= 'grug-far' then return false end
  u.grug_inst():goto_next_input()
  return true
end

local function grug_previous_input()
  if not _G.loaded['grug-far.nvim'] or vim.bo.filetype ~= 'grug-far' then return false end
  u.grug_inst():goto_prev_input()
  return true
end

local function grug_apply_then_next()
  if not _G.loaded['grug-far.nvim'] or vim.bo.filetype ~= 'grug-far' then return false end
  u.grug_inst():apply_next_change()
  return true
end

local function grug_apply_then_previous()
  if not _G.loaded['grug-far.nvim'] or vim.bo.filetype ~= 'grug-far' then return false end
  u.grug_inst():apply_prev_change()
  return true
end

local function grug_sync_then_next()
  if not _G.loaded['grug-far.nvim'] or vim.bo.filetype ~= 'grug-far' then return false end
  u.grug_inst():apply_next_change({ open_location = false, remove_synced = false, notify = true })
  return true
end

local function grug_sync_then_previous()
  if not _G.loaded['grug-far.nvim'] or vim.bo.filetype ~= 'grug-far' then return false end
  u.grug_inst():apply_prev_change({ open_location = false, remove_synced = false, notify = true })
  return true
end

local function grug_open_next()
  local inst = u.grug_inst()
  local location = inst:goto_next_match()
  if location then
    inst:open_location()
    return true
  end
  return false
end

local function grug_open_previous()
  local inst = u.grug_inst()
  local location = inst:goto_prev_match()
  if location then
    inst:open_location()
    return true
  end
  return false
end

function M.nvim_tree_previous_git()
  if not _G.loaded['nvim-tree.lua'] then return false end
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  return u.ensure_repmove(
    require('nvim-tree.api').node.navigate.git.prev_recursive,
    require('nvim-tree.api').node.navigate.git.next_recursive
  )[1]()
end
function M.nvim_tree_next_git()
  if not _G.loaded['nvim-tree.lua'] then return false end
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  return u.ensure_repmove(
    require('nvim-tree.api').node.navigate.git.prev_recursive,
    require('nvim-tree.api').node.navigate.git.next_recursive
  )[2]()
end
function M.nvim_tree_previous_diagnostic()
  if not _G.loaded['nvim-tree.lua'] then return false end
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  return u.ensure_repmove(
    require('nvim-tree.api').node.navigate.diagnostics.prev_recursive,
    require('nvim-tree.api').node.navigate.diagnostics.next_recursive
  )[1]()
end
function M.nvim_tree_next_diagnostic()
  if not _G.loaded['nvim-tree.lua'] then return false end
  if vim.fn.mode('1') == 'n' then vim.cmd("normal! m'") end
  return u.ensure_repmove(
    require('nvim-tree.api').node.navigate.diagnostics.prev_recursive,
    require('nvim-tree.api').node.navigate.diagnostics.next_recursive
  )[2]()
end
function M.next_diagnostic() return u.ensure_repmove(previous_diagnostic, next_diagnostic)[2]() end
function M.previous_diagnostic() return u.ensure_repmove(previous_diagnostic, next_diagnostic)[1]() end
function M.last_diagnostic() return u.ensure_repmove(first_diagnostic, last_diagnostic)[2]() end
function M.first_diagnostic() return u.ensure_repmove(first_diagnostic, last_diagnostic)[1]() end
function M.next_qflist_item() return u.ensure_repmove(cprevious, cnext)[2]() end
function M.previous_qflist_item() return u.ensure_repmove(cprevious, cnext)[1]() end
function M.last_qflist_item() return u.ensure_repmove(crewind, clast)[2]() end
function M.first_qflist_item() return u.ensure_repmove(crewind, clast)[1]() end
function M.previous_file_qflist_item() return u.ensure_repmove(cpfile, cnfile)[2]() end
function M.next_file_qflist_item() return u.ensure_repmove(cpfile, cnfile)[1]() end
function M.next_loclist_item() return u.ensure_repmove(lprevious, lnext)[2]() end
function M.previous_loclist_item() return u.ensure_repmove(lprevious, lnext)[1]() end
function M.last_loclist_item() return u.ensure_repmove(lrewind, llast)[2]() end
function M.first_loclist_item() return u.ensure_repmove(lrewind, llast)[1]() end
function M.next_file_loclist_item() return u.ensure_repmove(lpfile, lnfile)[2]() end
function M.previous_file_loclist_item() return u.ensure_repmove(lpfile, lnfile)[1]() end
function M.next_tag() return u.ensure_repmove(tprevious, tnext)[2]() end
function M.previous_tag() return u.ensure_repmove(tprevious, tnext)[1]() end
function M.last_tag() return u.ensure_repmove(trewind, tlast)[2]() end
function M.first_tag() return u.ensure_repmove(trewind, tlast)[1]() end
function M.preview_next_tag() return u.ensure_repmove(ptprevious, ptnext)[2]() end
function M.preview_previous_tag() return u.ensure_repmove(ptprevious, ptnext)[1]() end
function M.next_buffer() return u.ensure_repmove(bprevious, bnext)[2]() end
function M.previous_buffer() return u.ensure_repmove(bprevious, bnext)[1]() end
function M.last_buffer() return u.ensure_repmove(brewind, blast)[2]() end
function M.first_buffer() return u.ensure_repmove(brewind, blast)[1]() end
function M.next_file() return u.ensure_repmove(previous, next)[2]() end
function M.previous_file() return u.ensure_repmove(previous, next)[1]() end
function M.last_file() return u.ensure_repmove(rewind, last)[2]() end
function M.first_file() return u.ensure_repmove(rewind, last)[1]() end
function M.next_prompt() return u.ensure_repmove(previous_prompt, next_prompt)[2]() end
function M.previous_prompt() return u.ensure_repmove(previous_prompt, next_prompt)[1]() end
function M.next_conflict() return u.ensure_repmove(previous_conflict, next_conflict)[2]() end
function M.previous_conflict() return u.ensure_repmove(previous_conflict, next_conflict)[1]() end
function M.next_hunk() return u.ensure_repmove(previous_hunk, next_hunk)[2]() end
function M.previous_hunk() return u.ensure_repmove(previous_hunk, next_hunk)[1]() end
function M.indent_top() return u.ensure_repmove(indent_top, indent_bottom)[1]() end
function M.indent_bottom() return u.ensure_repmove(indent_top, indent_bottom)[2]() end

function M.comma()
  if not _G.loaded['repmove.nvim'] then
    return ','
  else
    return require('repmove').comma()
  end
end
function M.semicolon()
  if not _G.loaded['repmove.nvim'] then
    return ';'
  else
    return require('repmove').semicolon()
  end
end
function M.F() return u.ensure_repmove(flash_wrap('F'), flash_wrap('f'), flash_wrap(','), flash_wrap(';'))[1]() end
function M.f() return u.ensure_repmove(flash_wrap('F'), flash_wrap('f'), flash_wrap(','), flash_wrap(';'))[2]() end
function M.T() return u.ensure_repmove(flash_wrap('T'), flash_wrap('t'), flash_wrap(','), flash_wrap(';'))[1]() end
function M.t() return u.ensure_repmove(flash_wrap('T'), flash_wrap('t'), flash_wrap(','), flash_wrap(';'))[2]() end
function M.next_todo() return u.ensure_repmove(previous_todo, next_todo)[2]() end
function M.next_misspelled() return u.ensure_repmove(previous_misspelled, next_misspelled)[2]() end
function M.next_section_start() return u.ensure_repmove(previous_section_start, next_section_start)[2]() end
function M.next_function_start() return u.ensure_repmove(previous_function_start, next_function_start)[2]() end
function M.next_function_end() return u.ensure_repmove(previous_function_end, next_function_end)[2]() end
function M.next_class_start() return u.ensure_repmove(previous_class_start, next_class_start)[2]() end
function M.next_class_end() return u.ensure_repmove(previous_class_end, next_class_end)[2]() end
function M.next_block_end() return u.ensure_repmove(previous_block_end, next_block_end)[2]() end
function M.next_block_start() return u.ensure_repmove(previous_block_start, next_block_start)[2]() end
function M.next_loop_start() return u.ensure_repmove(previous_loop_start, next_loop_start)[2]() end
function M.next_loop_end() return u.ensure_repmove(previous_loop_end, next_loop_end)[2]() end
function M.next_return_start() return u.ensure_repmove(previous_return_start, next_return_start)[2]() end
function M.next_return_end() return u.ensure_repmove(previous_return_end, next_return_end)[2]() end
function M.next_parameter_start() return u.ensure_repmove(previous_parameter_start, next_parameter_start)[2]() end
function M.next_parameter_end() return u.ensure_repmove(previous_parameter_end, next_parameter_end)[2]() end
function M.next_conditional_start() return u.ensure_repmove(previous_conditional_start, next_conditional_start)[2]() end
function M.next_conditional_end() return u.ensure_repmove(previous_conditional_end, next_conditional_end)[2]() end
function M.next_statement_start() return u.ensure_repmove(previous_statement_start, next_statement_start)[2]() end
function M.next_statement_end() return u.ensure_repmove(previous_statement_end, next_statement_end)[2]() end
function M.next_call_start() return u.ensure_repmove(previous_call_start, next_call_start)[2]() end
function M.next_call_end() return u.ensure_repmove(previous_call_end, next_call_end)[2]() end
function M.next_plugin() return u.ensure_repmove(previous_plugin, next_plugin)[2]() end
function M.previous_todo() return u.ensure_repmove(previous_todo, next_todo)[1]() end
function M.previous_misspelled() return u.ensure_repmove(previous_misspelled, next_misspelled)[1]() end
function M.previous_section_start() return u.ensure_repmove(previous_section_start, next_section_start)[1]() end
function M.previous_function_start() return u.ensure_repmove(previous_function_start, next_function_start)[1]() end
function M.previous_function_end() return u.ensure_repmove(previous_function_end, next_function_end)[1]() end
function M.previous_class_start() return u.ensure_repmove(previous_class_start, next_class_start)[1]() end
function M.previous_class_end() return u.ensure_repmove(previous_class_end, next_class_end)[1]() end
function M.previous_block_start() return u.ensure_repmove(previous_block_start, next_block_start)[1]() end
function M.previous_block_end() return u.ensure_repmove(previous_block_end, next_block_end)[1]() end
function M.previous_loop_start() return u.ensure_repmove(previous_loop_start, next_loop_start)[1]() end
function M.previous_loop_end() return u.ensure_repmove(previous_loop_end, next_loop_end)[1]() end
function M.previous_return_start() return u.ensure_repmove(previous_return_start, next_return_start)[1]() end
function M.previous_return_end() return u.ensure_repmove(previous_return_end, next_return_end)[1]() end
function M.previous_parameter_start() return u.ensure_repmove(previous_parameter_start, next_parameter_start)[1]() end
function M.previous_parameter_end() return u.ensure_repmove(previous_parameter_end, next_parameter_end)[1]() end
function M.previous_conditional_start() return u.ensure_repmove(previous_conditional_start, next_conditional_start)[1]() end
function M.previous_conditional_end() return u.ensure_repmove(previous_conditional_end, next_conditional_end)[1]() end
function M.previous_statement_start() return u.ensure_repmove(previous_statement_start, next_statement_start)[1]() end
function M.previous_statement_end() return u.ensure_repmove(previous_statement_end, next_statement_end)[1]() end
function M.previous_call_start() return u.ensure_repmove(previous_call_start, next_call_start)[1]() end
function M.previous_call_end() return u.ensure_repmove(previous_call_end, next_call_end)[1]() end
function M.previous_plugin() return u.ensure_repmove(previous_plugin, next_plugin)[1]() end
function M.previous_tab() return u.ensure_repmove(tabprevious, tabnext)[1]() end
function M.next_tab() return u.ensure_repmove(tabprevious, tabnext)[2]() end
function M.grug_next_input() return u.ensure_repmove(grug_previous_input, grug_next_input)[2]() end
function M.grug_previous_input() return u.ensure_repmove(grug_previous_input, grug_next_input)[1]() end
function M.grug_apply_then_next() return u.ensure_repmove(grug_apply_then_previous, grug_apply_then_next)[2]() end
function M.grug_apply_then_previous() return u.ensure_repmove(grug_apply_then_previous, grug_apply_then_next)[1]() end
function M.grug_sync_then_next() return u.ensure_repmove(grug_sync_then_previous, grug_sync_then_next)[2]() end
function M.grug_sync_then_previous() return u.ensure_repmove(grug_sync_then_previous, grug_sync_then_next)[1]() end
function M.grug_open_next() return u.ensure_repmove(grug_open_previous, grug_open_next)[2]() end
function M.grug_open_previous() return u.ensure_repmove(grug_open_previous, grug_open_next)[1]() end
function M.select_tab()
  local ignored = vim.v.count == 0 and _G.loaded['tabby.nvim']
  if ignored then require('tabby.feature.tab_jumper').start() end
  u.ensure_repmove(tabprevious, function()
    if ignored then
      ignored = false
      return true
    end
    return tabnext()
  end)[2]()
  return true
end

return M
