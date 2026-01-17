--- @param context { line: string, cursor: number[] }
--- Return if rime_ls should be disabled in current context
function _G.rime_ls_disabled(context)
  if not vim.g.rime_enabled or vim.bo.buftype ~= '' then return true end
  local line = context.line
  local cursor_column = context.cursor[2]
  for _, pattern in ipairs(vim.g.disable_rime_ls_pattern) do
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

local function is_rime_item(item)
  if item == nil or item.source_name ~= 'LSP' then return false end
  local client = vim.lsp.get_client_by_id(item.client_id)
  return client ~= nil and client.name == 'rime_ls'
end

local function enable_rime_quick_select()
  if not vim.g.rime_enabled then return false end
  local content_before_cursor = string.sub(vim.api.nvim_get_current_line(), 1, vim.api.nvim_win_get_cursor(0)[2])
  if
    content_before_cursor:match('[a-z]+$') == nil
    or content_before_cursor:match('[a-y][a-y][a-y][a-y][a-y]$') ~= nil -- wubi has a maximum of 4 characters
    or content_before_cursor:match('z[a-z][a-z][a-z][a-z]$') ~= nil -- reverse query can have a leading 'z'
  then
    return false
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

local function rime_select_item_wrapper(index, key)
  return function(cmp)
    if not enable_rime_quick_select() then return false end
    local select = function()
      local rime_item_index = get_n_rime_item_index(index)
      if #rime_item_index ~= index then return false end
      return cmp.accept({ index = rime_item_index[index] })
    end
    if select() then return true end
    require('blink.cmp').show({
      providers = { 'lsp' },
      callback = function()
        local res = select()
        if not res then vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'nt', false) end
      end,
    })
    return true
  end
end

return {
  'saghen/blink.cmp',
  opts = {
    keymap = {
      ['<space>'] = { rime_select_item_wrapper(1, '<space>'), 'fallback' },
      [';'] = { rime_select_item_wrapper(2, ';'), 'fallback' },
      ['z'] = { rime_select_item_wrapper(3, 'z'), 'fallback' },
      ['4'] = { rime_select_item_wrapper(4, '4'), 'fallback' },
      ['5'] = { rime_select_item_wrapper(5, '5'), 'fallback' },
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
            local TYPE_ALIAS = require('blink.cmp.types').CompletionItemKind
            items = vim.tbl_filter(function(item)
              local c = require('lightboat.config').get().blink_cmp.ignored_keyword
              return is_rime_item(item) and not item.label:match('^%w*$')
                or item.kind ~= TYPE_ALIAS.Snippet
                  and item.kind ~= TYPE_ALIAS.Text
                  and not (item.kind == TYPE_ALIAS.Keyword and c[vim.bo.filetype] and vim.tbl_contains(
                    c[vim.bo.filetype],
                    item.label
                  ))
            end, items)
            if _G.rime_ls_disabled(context) then
              items = vim.tbl_filter(function(item) return not is_rime_item(item) end, items)
            else
              for _, item in ipairs(items) do
                if is_rime_item(item) then
                  local idx = item.label:match('^(%d+)')
                  if idx then
                    -- make sure this is not affected by frecency
                    item.score_offset = (#items - tonumber(idx)) * 9999
                  end
                end
              end
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
