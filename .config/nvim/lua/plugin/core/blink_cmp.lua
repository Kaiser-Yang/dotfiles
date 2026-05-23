local u = require('utils')
u.gh('Kaiser-Yang/blink-cmp-dictionary')
u.gh('saghen/blink.lib')
u.gh('saghen/blink.cmp')

local function default_sources()
  local res = { 'snippets', 'path', 'buffer', 'dictionary' }
  local sql_file = vim.tbl_contains({ 'sql', 'mysql', 'plsql' }, vim.bo.filetype)
  if sql_file then table.insert(res, 'dadbod') end
  if not sql_file then table.insert(res, 'lsp') end
  if vim.bo.filetype == 'dap-repl' then table.insert(res, 'dap') end
  return res
end

local blink_cmp_unique_priority = function(ctx)
  if ctx.mode == 'cmdline' then
    return { 'cmdline', 'path', 'buffer' }
  else
    return default_sources()
  end
end

require('blink.cmp').setup({
  sources = {
    default = default_sources,
    providers = {
      lsp = {
        transform_items = function(_, items)
          -- Remove keywords
          return vim.tbl_filter(
            function(item) return item.kind ~= require('blink.cmp.types').CompletionItemKind.Keyword end,
            items
          )
        end,
        fallbacks = {},
      },
      path = { opts = { show_hidden_files_by_default = true } },
      snippets = { name = 'Snip' },
      cmdline = { name = 'CMD' },
      buffer = {
        name = 'Buf',
        score_offset = -10,
        get_bufnrs = function()
          return vim.tbl_filter(
            function(bufnr) return vim.bo[bufnr].filetype == 'help' or vim.bo[bufnr].buftype == '' end,
            vim.api.nvim_list_bufs()
          )
        end,
        transform_items = function(context, items)
          -- Do not convert case when searching
          if context.mode == 'cmdline' then return items end
          local out = {}
          for _, item in ipairs(items) do
            table.insert(out, vim.deepcopy(item))
            --- @type string
            local raw = item.insertText
            if raw:match('^[%a%d]+$') then
              local text = string.upper(raw:sub(1, 1)) .. raw:sub(2)
              item.insertText = text
              item.label = text
              table.insert(out, item)
            end
          end
          return out
        end,
      },
      dictionary = {
        name = 'Dict',
        module = 'blink-cmp-dictionary',
        min_keyword_length = 3,
        opts = { dictionary_files = { vim.fn.stdpath('config') .. '/dict/en_dict.txt' } },
        score_offset = -13,
      },
      dadbod = {
        name = 'Dadbod',
        enabled = function() return _G.loaded['vim-dadbod-completion'] end,
        module = 'vim_dadbod_completion.blink',
      },
      dap = {
        name = 'DAP',
        module = 'blink-cmp-dap',
        enabled = function() return _G.loaded['blink-cmp-dap'] and _G.loaded['nvim-dap'] and require('dap').session() end,
      },
    },
  },
  keymap = { preset = 'none' },
  completion = {
    menu = {
      scrolloff = 0,
      max_height = 15,
      draw = {
        padding = 0,
        align_to = 'cursor',
        columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'source_name' } },
        components = { source_name = { text = function(ctx) return '[' .. ctx.source_name .. ']' end } },
      },
    },
    documentation = { auto_show = true, auto_show_delay_ms = vim.o.updatetime },
  },
  cmdline = {
    keymap = { preset = 'none' },
    completion = { menu = { auto_show = true }, ghost_text = { enabled = false } },
  },
  signature = { enabled = true },
})
local original = require('blink.cmp.completion.list').show
-- HACK:
-- This is a hack, see https://github.com/saghen/blink.cmp/issues/1222#issuecomment-2891921393
require('blink.cmp.completion.list').show = function(ctx, items_by_source)
  local seen = {}
  local function filter(item)
    if seen[item.label] then return false end
    seen[item.label] = true
    return true
  end
  for id in vim.iter(u.get(blink_cmp_unique_priority, ctx)) do
    items_by_source[id] = items_by_source[id] and vim.iter(items_by_source[id]):filter(filter):totable()
  end
  return original(ctx, items_by_source)
end
-- After "blink.cmp" loads, we can enable LSP servers
local lsp_path = vim.fn.stdpath('config')
if lsp_path:sub(-1) ~= '/' then lsp_path = lsp_path .. '/' end
lsp_path = lsp_path .. 'after/lsp'
local servers = vim.fn.glob(lsp_path .. '/**/*.lua', true, true)
servers = vim.tbl_map(function(path) return vim.fn.fnamemodify(path, ':t:r') end, servers)
if #servers > 0 then vim.lsp.enable(servers) end
