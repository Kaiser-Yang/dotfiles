-- When input method is enabled, disable the following patterns
local util = require('util')

local function is_rime_item(item)
  if item == nil or item.source_name ~= 'LSP' then return false end
  local client = vim.lsp.get_client_by_id(item.client_id)
  return client ~= nil and client.name == 'rime_ls'
end

local function match_any_of_patterns(word, patterns)
  for _, pattern in ipairs(patterns) do
    if word:match(pattern) then return true end
  end
  return false
end

--- @return string
local function get_WORD()
  local content_before_cursor = string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
  return content_before_cursor:match('(%S+)$') or ''
end

--- @return boolean
local function at_least_one_space_before_cursor()
  local content_before_cursor = string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
  return content_before_cursor:match('%s$') ~= nil
end

--- @return boolean
local function non_markdown_and_non_comment()
  return not vim.tbl_contains(vim.g.lightboat_opts.extra.markdown_fts, vim.bo.filetype)
    and util.inside_block({ 'comment' }) == false
end

--- @return boolean
local function word_contains_non_alpha_ascii()
  local word = get_WORD()
  return word:match('[\1-\96\123-\127]') ~= nil
end

--- @param allowed_before_patterns? string[]
--- @return boolean
local function valid_word_for_rime_ls(allowed_before_patterns)
  allowed_before_patterns = allowed_before_patterns or {}
  allowed_before_patterns[#allowed_before_patterns + 1] = '^'
  allowed_before_patterns[#allowed_before_patterns + 1] = ''
  local word = get_WORD()
  local base_patterns = {
    '[a-y]$',
    '[a-y][a-y]$',
    '[a-y][a-y][a-y]$',
    '[a-y][a-y][a-y][a-y]$',
    '[a-y][a-y][a-y][a-y][bln]$',
    'z[a-z]*$',
    'datef?$',
    'timef?$',
    'datif?$',
  }
  local patterns = {}
  for _, p in pairs(allowed_before_patterns) do
    for _, base_pattern in ipairs(base_patterns) do
      patterns[#patterns + 1] = p .. base_pattern
    end
  end
  return match_any_of_patterns(word, patterns)
end

--- @return boolean
local function in_special_context()
  local line = vim.api.nvim_get_current_line()
  local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
  local disable_rime_ls_pattern = {
    -- disable in ``
    '`([%w%s%p]-)`',
    -- disable in ''
    "'([%w%s%p]-)'",
    -- disable in ""
    '"([%w%s%p]-)"',
    -- disable after ```
    '```[%w%s%p]-',
    -- disable in $$
    '%$+[%w%s%p]-%$+',
  }
  for _, pattern in ipairs(disable_rime_ls_pattern) do
    local start_pos = 1
    while true do
      local match_start, match_end = string.find(line, pattern, start_pos)
      if not match_start then break end
      if cursor_column >= match_start and cursor_column < match_end then return true end
      start_pos = match_end + 1
    end
  end
  return false
end

local function non_insert_mode() return vim.fn.mode('1') ~= 'i' end

--- @param patterns string[]
local function end_with(patterns)
  local word = get_WORD()
  for _, p in ipairs(patterns) do
    if word:match(p .. '$') then return true end
  end
  return false
end

local function zh_punc_disabled()
  if vim.g.rime_enabled ~= true or in_special_context() then return true end
  if end_with({ '&emsp;', '`', '[^\1-\127]' }) then return false end
  return non_insert_mode()
    or at_least_one_space_before_cursor()
    or non_markdown_and_non_comment()
    or word_contains_non_alpha_ascii()
    or end_with({ '[\1-\127]' })
end

local function zh_character_disabled()
  if vim.g.rime_enabled ~= true or in_special_context() then return true end
  if valid_word_for_rime_ls({ '&emsp', '[^\1-\127]' }) then return false end
  return non_insert_mode() or non_markdown_and_non_comment() or word_contains_non_alpha_ascii()
end

--- @param n number
function _G.get_n_rime_item_index(n)
  local items = require('blink.cmp.completion.list').items
  local result = {}
  if items == nil or #items == 0 then return result end
  for i, item in ipairs(items) do
    if is_rime_item(item) then
      result[#result + 1] = i
      if #result == n then break end
    end
  end
  return result
end

--- @alias key_generator string | fun():string

--- @type key_generator|nil
local key_on_empty = nil
local trigger_by_empty = false
local rime_ls_keymap = {}
local last_selected_rime_text = nil
local ignore_autocmd = false

--- @param index number
--- @param failed_key key_generator
--- @param succeeded_key? key_generator
local function rime_select_item_wrapper(index, failed_key, succeeded_key)
  return function(cmp)
    local word = get_WORD()
    local z = not zh_character_disabled()
      and util.get(failed_key) == 'z'
      and match_any_of_patterns(word, { '[^\1-\127]$', '[^\1-\127]z[a-z]*$', '^z[a-z]*$' })
    local semi_colon = not zh_character_disabled()
      and util.get(failed_key) == ';'
      and match_any_of_patterns(word, { '[^\1-\127]z[a-z]*$', '^z[a-z]*$' })
    local z_space = not zh_character_disabled()
      and last_selected_rime_text
      and util.get(failed_key) == '<space>'
      and match_any_of_patterns(word, { '^z$', '[^\1-\127]z$' })
    if zh_character_disabled() or z or semi_colon or z_space or trigger_by_empty or z_space then
      key_on_empty = nil
      trigger_by_empty = false
      ignore_autocmd = true
      local key = nil
      if zh_character_disabled() then
        key = util.get(failed_key)
        if #key <= 1 then key = nil end
      end
      if z_space then key = '<bs>' .. last_selected_rime_text end
      if key then
        util.key.feedkeys(key, 'nt')
        return true
      end
      return false
    end
    local tmp = nil
    --- @param callback? fun()
    local select = function(callback)
      local rime_item_index = get_n_rime_item_index(index)
      if #rime_item_index ~= index then return false end
      tmp = require('blink.cmp.completion.list').items[rime_item_index[index]].textEdit.newText
      return cmp.accept({ index = rime_item_index[index], callback = callback })
    end
    local callback = function()
      if succeeded_key then util.key.feedkeys(util.get(succeeded_key), 'nt') end
    end
    if select(callback) then
      last_selected_rime_text = tmp
      return true
    elseif require('blink.cmp').is_visible() then
      return false
    end
    key_on_empty = failed_key
    require('blink.cmp').show({
      providers = { 'lsp' },
      callback = function()
        key_on_empty = nil
        if ignore_autocmd then
          ignore_autocmd = false
          return
        end
        local res = select(callback)
        if not res then
          local key = util.get(failed_key)
          util.key.feedkeys(key, 'mt')
          if vim.tbl_contains(vim.tbl_keys(rime_ls_keymap), key) then trigger_by_empty = true end
        else
          last_selected_rime_text = tmp
        end
      end,
    })
    return true
  end
end

local pair_generator_wrap = function(opening, closing, char_on_illegal)
  return function()
    local illegal = false
    local line = vim.api.nvim_get_current_line()
    local cnt = 0
    for i = 1, #line do
      if line:sub(i, i + #opening - 1) == opening then
        cnt = cnt + 1
      elseif line:sub(i, i + #closing - 1) == closing then
        cnt = cnt - 1
      end
      if cnt < 0 then
        illegal = true
        break
      end
    end
    local function is_closing(char) return char == ')' or char == ']' or char == '>' end
    if illegal or (is_closing(char_on_illegal) and cnt == 0) then return char_on_illegal end
    if cnt > 0 then
      return closing
    else
      return opening
    end
  end
end

local zh_punc = {
  '，',
  '。',
  '！',
  '？',
  '；',
  '：',
  '、',
  '——',
  '……',
  '（',
  '）',
  '【',
  '】',
  '《',
  '》',
  '‘',
  '’',
  '“',
  '”',
}

---@pram en_key key_generator
---@pram zh_key key_generator
---@return key_generator
local failed_key_generator_wrap = function(en_key, zh_key)
  return function()
    local en_res = util.get(en_key)
    if zh_punc_disabled() or en_res == ',' and end_with(zh_punc) then
      return en_res
    else
      return util.get(zh_key)
    end
  end
end

rime_ls_keymap = {
  ['<space>'] = { rime_select_item_wrapper(1, '<space>'), 'fallback' },
  ['1'] = { rime_select_item_wrapper(1, '1'), 'fallback' },
  ['2'] = { rime_select_item_wrapper(2, '2'), 'fallback' },
  ['3'] = { rime_select_item_wrapper(3, '3'), 'fallback' },
  ['4'] = { rime_select_item_wrapper(4, '4'), 'fallback' },
  ['5'] = { rime_select_item_wrapper(5, '5'), 'fallback' },
  ['6'] = { rime_select_item_wrapper(6, '6'), 'fallback' },
  ['7'] = { rime_select_item_wrapper(7, '7'), 'fallback' },
  ['8'] = { rime_select_item_wrapper(8, '8'), 'fallback' },
  ['9'] = { rime_select_item_wrapper(9, '9'), 'fallback' },
  ['0'] = { rime_select_item_wrapper(10, '0'), 'fallback' },

  ['z'] = { rime_select_item_wrapper(3, 'z'), 'fallback' },

  [';'] = { rime_select_item_wrapper(2, failed_key_generator_wrap(';', '；')), 'fallback' },
  [','] = { rime_select_item_wrapper(1, failed_key_generator_wrap(',', '，'), '，'), 'fallback' },
  ['_'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('_', '——'), '——'), 'fallback' },
  ['^'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('^', '……'), '……'), 'fallback' },
  ['.'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('.', '。'), '。'), 'fallback' },
  [':'] = { rime_select_item_wrapper(1, failed_key_generator_wrap(':', '：'), '：'), 'fallback' },
  ['?'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('?', '？'), '？'), 'fallback' },
  ['\\'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('\\', '、'), '、'), 'fallback' },
  ['!'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('!', '！'), '！'), 'fallback' },
  ['('] = {
    rime_select_item_wrapper(1, failed_key_generator_wrap('(', pair_generator_wrap('（', '）', '(')), '（'),
    'fallback',
  },
  [')'] = {
    rime_select_item_wrapper(1, failed_key_generator_wrap(')', pair_generator_wrap('（', '）', ')')), '）'),
    'fallback',
  },
  ['['] = {
    rime_select_item_wrapper(1, failed_key_generator_wrap('[', pair_generator_wrap('【', '】', '[')), '【'),
    'fallback',
  },
  [']'] = {
    rime_select_item_wrapper(1, failed_key_generator_wrap(']', pair_generator_wrap('【', '】', ']')), '】'),
    'fallback',
  },
  ['<'] = {
    rime_select_item_wrapper(1, failed_key_generator_wrap('<', pair_generator_wrap('《', '》', '<')), '《'),
    'fallback',
  },
  ['>'] = {
    rime_select_item_wrapper(1, failed_key_generator_wrap('>', pair_generator_wrap('《', '》', '>')), '》'),
    'fallback',
  },
  ["'"] = {
    rime_select_item_wrapper(
      1,
      failed_key_generator_wrap("'", pair_generator_wrap('‘', '’', "'")),
      pair_generator_wrap('‘', '’', "'")
    ),
    'fallback',
  },
  ['"'] = {
    rime_select_item_wrapper(
      1,
      failed_key_generator_wrap('"', pair_generator_wrap('“', '”', '"')),
      pair_generator_wrap('“', '”', '"')
    ),
    'fallback',
  },
}

return {
  'saghen/blink.cmp',
  opts = {
    keymap = rime_ls_keymap,
    completion = {
      menu = {
        draw = {
          components = {
            label = {
              text = function(ctx)
                local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                if not vim.g.rime_enabled or not client or client.name ~= 'rime_ls' then
                  return ctx.label .. ctx.label_detail
                end
                local code_start = #ctx.label_detail + 1
                for i = 1, #ctx.label_detail do
                  local ch = string.sub(ctx.label_detail, i, i)
                  if ch >= 'a' and ch <= 'z' then
                    code_start = i
                    break
                  end
                end
                local code_end = #ctx.label_detail - 4
                local code = ctx.label_detail:sub(code_start, code_end)
                code = string.gsub(code, '  ·  ', ' ')
                code = string.gsub(code, ' .*$', '')
                if code ~= '' then code = ' <' .. code .. '>' end
                return ctx.label .. code
              end,
            },
          },
        },
      },
    },
    sources = {
      providers = {
        lsp = {
          transform_items = function(context, items)
            if zh_character_disabled() then
              items = vim.tbl_filter(function(item) return not is_rime_item(item) end, items)
            else
              for _, item in ipairs(items) do
                if is_rime_item(item) then
                  local idx = item.label:match('^(%d+)')
                  if idx then
                    -- make sure this is not affected by frecency
                    item.score_offset = (#items - tonumber(idx) + 1) * 9999
                    item.kind = require('blink.cmp.types').CompletionItemKind.Value
                  end
                end
              end
            end
            local origin =
              require('lightboat.plugin.code.blink_cmp').spec()[5].opts.sources.providers.lsp.transform_items
            items = origin(context, items)
            if #items == 0 and key_on_empty then
              local key = util.get(key_on_empty)
              util.key.feedkeys(key, 'mt')
              if vim.tbl_contains(vim.tbl_keys(rime_ls_keymap), key) then trigger_by_empty = true end
              key_on_empty = nil
            end
            return items
          end,
        },
        ripgrep = {
          transform_items = function(_, items)
            items = vim.tbl_filter(function(item)
              -- Remove items that consist of only numbers
              return not (item.label:match('^%d+$') or item.label:match('^%d+%.%d+$'))
            end, items)
            if #items > 100 then
              -- Limit the number of items to 100
              items = vim.list_slice(items, 1, 100)
            end
            return items
          end,
        },
      },
    },
  },
}
