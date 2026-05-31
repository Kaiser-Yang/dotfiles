local u = require('utils')
u.gh('Kaiser-Yang/blink-cmp-dictionary')
u.gh('saghen/blink.lib')
u.gh('saghen/blink.cmp')

local function default_sources()
  local res = {}
  local sql_file = vim.tbl_contains({ 'sql', 'mysql', 'plsql' }, vim.bo.filetype)
  if sql_file then
    table.insert(res, 'dadbod')
  elseif vim.bo.filetype == 'dap-repl' then
    table.insert(res, 'dap')
  else
    table.insert(res, 'lsp')
  end
  vim.list_extend(res, { 'snippets', 'path', 'dictionary', 'buffer' })
  return res
end

local blink_cmp_unique_priority = function(ctx)
  if ctx.mode == 'cmdline' then
    return { 'cmdline', 'path', 'buffer' }
  else
    return default_sources()
  end
end

local k = require('blink.cmp.types').CompletionItemKind
local lsp_extra = {
}
local snippets_extra = {
}
local snippets_trigger_characters = {
  cpp = { '#', '/', '@' },
  lua = { '-', '@' },
  python = { '#' },
  sh = {'#'},
  zsh = {'#'},
}
require('blink.cmp').setup({
  snippets = { score_offset = 0 },
  sources = {
    default = default_sources,
    providers = {
      lsp = {
        transform_items = function(_, items)
          local res = {}
          local ft_extra = lsp_extra[vim.bo.filetype] or {}
          for _, item in ipairs(items) do
            if item.kind == k.Snippet then item.detail = u.doc_from_snippet(item.insertText) end
            for label, label_or_map in pairs(ft_extra[item.kind] or {}) do
              if item.label == label then
                if type(label_or_map) == 'function' then label_or_map = { label_or_map } end
                if type(label_or_map) == 'string' then
                  item.label = label_or_map
                elseif type(label_or_map) == 'table' then
                  item = vim.tbl_map(function(map) return map(item) end, label_or_map)
                elseif label_or_map == false then
                  item = nil
                end
                break
              end
            end
            if item then
              if not item[1] then item = { item } end
              vim.list_extend(res, item)
            end
          end
          return res
        end,
        fallbacks = {},
      },
      -- HACK:
      -- path can not work when the leading character is not "./" or "/"
      path = {
        opts = {
          show_hidden_files_by_default = true,
          get_cwd = function(ctx)
            if vim.bo[ctx.bufnr].buftype == 'nofile' then return vim.fn.getcwd() end
            return vim.fn.expand(('#%d:p:h'):format(ctx.bufnr))
          end,
        },
        fallbacks = {},
      },
      snippets = {
        name = 'Snip',
        score_offset = 0,
        transform_items = function(_, items)
          items = vim.tbl_map(function(item)
            item.detail = u.doc_from_snippet(item.insertText)
            return item
          end, items)
          local ft_extra = snippets_extra[vim.bo.filetype] or {}
          for _, snippet in ipairs(ft_extra) do
            if type(snippet) == 'function' then
              table.insert(items, snippet())
            elseif type(snippet) == 'table' then
              table.insert(items, snippet)
            end
          end
          return items
        end,
        opts = {
          extended_filetypes = {
            c = { 'cdoc' },
            cpp = { 'cppdoc' },
            lua = { 'luadoc' },
            python = { 'pydoc' },
            sh = { 'shelldoc' },
            zsh = { 'shelldoc' },
          },
        },
        override = {
          get_trigger_characters = function() return snippets_trigger_characters[vim.bo.filetype] or {} end,
        },
      },
      cmdline = { name = 'CMD' },
      buffer = {
        name = 'Buf',
        score_offset = -13,
        get_bufnrs = function()
          return vim.tbl_filter(
            function(bufnr) return vim.bo[bufnr].filetype == 'help' or vim.bo[bufnr].buftype == '' end,
            vim.api.nvim_list_bufs()
          )
        end,
        transform_items = function(ctx, items)
          -- Do not convert case when searching
          if ctx.mode == 'cmdline' then return items end
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
        score_offset = -16,
        min_keyword_length = 1,
        opts = { dictionary_files = { vim.fn.stdpath('config') .. '/dict/en_dict.txt' } },
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
        components = {
          source_name = { text = function(ctx) return '[' .. ctx.source_name .. ']' end },
          kind_icon = {
            text = function(ctx)
              local icon = ctx.kind_icon
              if ctx.item.source_name == 'LSP' and _G.loaded['nvim-highlight-colors'] then
                local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr ~= '' then icon = color_item.abbr end
              end
              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              local highlight = 'BlinkCmpKind' .. ctx.kind
              if ctx.item.source_name == 'LSP' and _G.loaded['nvim-highlight-colors'] then
                local color_item = require('nvim-highlight-colors').format(ctx.item.documentation, { kind = ctx.kind })
                if color_item and color_item.abbr_hl_group then highlight = color_item.abbr_hl_group end
              end
              return highlight
            end,
          },
        },
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
