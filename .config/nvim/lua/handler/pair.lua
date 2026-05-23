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
  local key = (cnt ~= 1 and cnt or '') .. res
  vim.schedule_wrap(u.key.feedkeys)(key, 'n')
  return '<esc>'
end

--- @param keycode string
--- @return string|boolean
local function autopair(keycode)
  local core = require('ultimate-autopair.core')
  core.get_run(keycode)
  u.key.feedkeys(core.run_run(keycode), 'n', false)
  return true
end

local keycode_to_function
--- @param keycode string
local function blink_pairs(keycode)
  if keycode_to_function == nil then
    local ops = require('blink.pairs.mappings.ops')
    local rule_lib = require('blink.pairs.rule')
    local rules_by_key = rule_lib.parse(require('blink.pairs.config').mappings.pairs)
    local all_rules = rule_lib.get_all(rules_by_key)
    keycode_to_function = {
      ['<'] = ops.on_key('<', rules_by_key['<']),
      ['>'] = ops.on_key('>', rules_by_key['>']),
      ['('] = ops.on_key('(', rules_by_key['(']),
      [')'] = ops.on_key(')', rules_by_key[')']),
      ['['] = ops.on_key('[', rules_by_key['[']),
      [']'] = ops.on_key(']', rules_by_key[']']),
      ['{'] = ops.on_key('{', rules_by_key['{']),
      ['}'] = ops.on_key('}', rules_by_key['}']),
      ['"'] = ops.on_key('"', rules_by_key['"']),
      ["'"] = ops.on_key("'", rules_by_key["'"]),
      ['`'] = ops.on_key('`', rules_by_key['`']),
      ['!'] = ops.on_key('!', rules_by_key['!']),
      ['-'] = ops.on_key('-', rules_by_key['-']),
      ['_'] = ops.on_key('_', rules_by_key['_']),
      ['*'] = ops.on_key('*', rules_by_key['*']),
      ['$'] = ops.on_key('$', rules_by_key['$']),
      [vim.keycode('<bs>')] = ops.backspace(all_rules),
      [vim.keycode('<cr>')] = ops.enter(all_rules),
      [vim.keycode('<space>')] = ops.space(all_rules),
      [vim.keycode('<m-e>')] = "<C-g>U<Cmd>lua require('blink.pairs.mappings.wrap.treesitter').wrap('fwd')<CR>",
      [vim.keycode('<m-E>')] = "<C-g>U<Cmd>lua require('blink.pairs.mappings.wrap.treesitter').wrap('rev')<CR>",
    }
  end
  local res = keycode_to_function[keycode]
  if type(res) == 'function' then res = res() end
  return res
end
local blink_pairs_keycode = {
  '(',
  ')',
  '[',
  ']',
  '{',
  '}',
  '"',
  "'",
  '`',
  '!',
  '-',
  '_',
  '<',
  '>',
  '*',
  '$',
  vim.keycode('<bs>'),
  vim.keycode('<cr>'),
  vim.keycode('<space>'),
  vim.keycode('<m-e>'),
  vim.keycode('<m-E>'),
}
local autopair_keycode = {
  '(',
  ')',
  '{',
  '}',
  '[',
  ']',
  '"',
  "'",
  '`',
  '-',
  vim.keycode('<bs>'),
  vim.keycode('<cr>'),
  vim.keycode('<space>'),
  vim.keycode('<m-e>'),
  vim.keycode('<m-E>'),
  vim.keycode('<m-)>'),
  vim.keycode('<m-tab>'),
}
local autopair_first_keycode = {
  ')',
  '}',
  ']',
  '"',
  "'",
  '`',
  -- BUG: this can not go out for "<!-- | -->" with "-"
  '-',
  vim.keycode('<bs>'),
  vim.keycode('<space>'),
  vim.keycode('<m-)>'),
  vim.keycode('<m-tab>'),
}
function M.auto_pair_wrap(key)
  return function()
    local keycode = vim.keycode(key)
    if _G.loaded['ultimate-autopair.nvim'] and vim.tbl_contains(autopair_first_keycode, keycode) then
      return autopair(keycode)
    elseif _G.loaded['blink.pairs'] and not u.buffer.big() and vim.tbl_contains(blink_pairs_keycode, keycode) then
      return blink_pairs(keycode)
    elseif _G.loaded['ultimate-autopair.nvim'] and vim.tbl_contains(autopair_keycode, keycode) then
      return autopair(keycode)
    end
    return false
  end
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

return M
