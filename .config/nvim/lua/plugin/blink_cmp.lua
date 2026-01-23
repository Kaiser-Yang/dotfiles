-- When input method is enabled, disable the following patterns
vim.g.disable_rime_ls_pattern = {
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

--- @param types string[]
--- @return boolean|nil
--- Returns true if the cursor is inside a block of the specified types,
--- false if not, or nil if unable to determine.
local function inside_block(types)
  local node_under_cursor = vim.treesitter.get_node()
  local parser = vim.treesitter.get_parser(nil, nil, { error = false })
  if not parser or not node_under_cursor then return nil end
  local query = vim.treesitter.query.get(parser:lang(), 'highlights')
  if not query then return nil end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
    for _, t in ipairs(types) do
      if query.captures[id]:find(t) then
        local start_row, start_col, end_row, end_col = node:range()
        if start_row <= row and row <= end_row then
          if start_row == row and end_row == row then
            if start_col <= col and col <= end_col then return true end
          elseif start_row == row then
            if start_col <= col then return true end
          elseif end_row == row then
            if col <= end_col then return true end
          else
            return true
          end
        end
      end
    end
  end
  return false
end
local function is_rime_item(item)
  if item == nil or item.source_name ~= 'LSP' then return false end
  local client = vim.lsp.get_client_by_id(item.client_id)
  return client ~= nil and client.name == 'rime_ls'
end

local function should_hack_select_or_punc()
  if not vim.g.rime_enabled or vim.fn.mode('1') ~= 'i' then return false end
  local content_before_cursor = string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
  -- When the line is too long, not in comment or string, or there is a space before, we should not hack
  if
    content_before_cursor:match('[a-y][a-y][a-y][a-y][a-y]$') ~= nil -- wubi has a maximum of 4 characters
    or content_before_cursor:match('z[a-z][a-z][a-z][a-z]$') ~= nil -- reverse query can have a leading 'z'
    or vim.bo.filetype ~= 'markdown' and inside_block({ 'comment', 'string', 'text' }) == false
    or content_before_cursor:match('%s$')
  then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
  for _, pattern in ipairs(vim.g.disable_rime_ls_pattern) do
    local start_pos = 1
    while true do
      local match_start, match_end = string.find(line, pattern, start_pos)
      if not match_start then break end
      if cursor_column >= match_start and cursor_column < match_end then return false end
      start_pos = match_end + 1
    end
  end
  return true
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

local util = require('util')

--- @alias key_generator string | fun():string

--- @type key_generator|nil
local key_on_empty = nil

--- @param index number
--- @param failed_key key_generator
--- @param succeeded_key? key_generator
local function rime_select_item_wrapper(index, failed_key, succeeded_key)
  return function(cmp)
    if not should_hack_select_or_punc() then return false end
    --- @param callback? fun()
    local select = function(callback)
      local rime_item_index = get_n_rime_item_index(index)
      if #rime_item_index ~= index then return false end
      return cmp.accept({ index = rime_item_index[index], callback = callback })
    end
    local callback = function()
      if succeeded_key then util.key.feedkeys(util.get(succeeded_key), 'nt') end
    end
    if select(callback) then return true end
    key_on_empty = failed_key
    require('blink.cmp').show({
      providers = { 'lsp' },
      callback = function()
        key_on_empty = nil
        local res = select(callback)
        if not res then util.key.feedkeys(util.get(failed_key), 'nt') end
      end,
    })
    return true
  end
end

local quotation_generator_wrap = function(opening, closing)
  return function()
    local line = vim.api.nvim_get_current_line()
    local cnt = 0
    for i = 1, #line do
      if line:sub(i, i + #opening - 1) == opening then
        cnt = cnt + 1
      elseif line:sub(i, i + #closing - 1) == closing then
        cnt = cnt - 1
      end
    end
    vim.notify(tostring(cnt))
    if cnt > 0 then
      return closing
    else
      return opening
    end
  end
end

---@pram en_key key_generator
---@pram zh_key key_generator
---@return key_generator
local failed_key_generator_wrap = function(en_key, zh_key)
  return function()
    if should_hack_select_or_punc() then
      return util.get(zh_key)
    else
      return util.get(en_key)
    end
  end
end

return {
  'saghen/blink.cmp',
  opts = {
    keymap = {
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
      ['0'] = { rime_select_item_wrapper(0, '0'), 'fallback' },

      ['z'] = { rime_select_item_wrapper(3, 'z'), 'fallback' },

      [';'] = { rime_select_item_wrapper(2, failed_key_generator_wrap(';', '；')), 'fallback' },
      [','] = { rime_select_item_wrapper(1, failed_key_generator_wrap(',', '，'), '，'), 'fallback' },
      ['.'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('.', '。'), '。'), 'fallback' },
      [':'] = { rime_select_item_wrapper(1, failed_key_generator_wrap(':', '：'), '：'), 'fallback' },
      ['?'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('?', '？'), '？'), 'fallback' },
      ['\\'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('\\', '、'), '、'), 'fallback' },
      ['!'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('!', '！'), '！'), 'fallback' },
      ['('] = { rime_select_item_wrapper(1, failed_key_generator_wrap('(', '（'), '（'), 'fallback' },
      [')'] = { rime_select_item_wrapper(1, failed_key_generator_wrap(')', '）'), '）'), 'fallback' },
      ['['] = { rime_select_item_wrapper(1, failed_key_generator_wrap('[', '【'), '【'), 'fallback' },
      [']'] = { rime_select_item_wrapper(1, failed_key_generator_wrap(']', '】'), '】'), 'fallback' },
      ['<'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('<', '《'), '《'), 'fallback' },
      ['>'] = { rime_select_item_wrapper(1, failed_key_generator_wrap('>', '》'), '》'), 'fallback' },
      ["'"] = {
        rime_select_item_wrapper(
          1,
          failed_key_generator_wrap("'", quotation_generator_wrap('‘', '’')),
          quotation_generator_wrap('‘', '’')
        ),
        'fallback',
      },
      ['"'] = {
        rime_select_item_wrapper(
          1,
          failed_key_generator_wrap('"', quotation_generator_wrap('“', '”')),
          quotation_generator_wrap('“', '”')
        ),
        'fallback',
      },
    },
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
            if not should_hack_select_or_punc() then
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
              util.key.feedkeys(util.get(key_on_empty), 'nt')
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
