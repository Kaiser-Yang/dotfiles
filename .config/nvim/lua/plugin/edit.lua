local u = require('utils')

local blink_cmp_unique_priority = function(ctx)
  if ctx.mode == 'cmdline' then
    return { 'cmdline', 'path', 'buffer' }
  else
    return { 'snippets', 'lsp', 'buffer', 'dictionary' }
  end
end

local function load_blink()
  local sql_sources = { inherit_defaults = false, 'snippets', 'buffer', 'dadbod' }
  require('blink.cmp').setup({
    sources = {
      default = { 'snippets', 'lsp', 'path', 'buffer', 'dictionary' },
      per_filetype = {
        sql = sql_sources,
        mysql = sql_sources,
        plsql = sql_sources,
      },
      providers = {
        lsp = { fallbacks = { 'buffer', 'dictionary' } },
        path = { opts = { show_hidden_files_by_default = true } },
        snippets = { name = 'Snip' },
        cmdline = { name = 'CMD' },
        buffer = {
          name = 'Buf',
          transform_items = function(context, items)
            -- Do not convert case when searching
            if context.mode == 'cmdline' then return items end
            local out = {}
            for _, item in ipairs(items) do
              --- @type string
              local raw = item.insertText
              table.insert(out, item)
              local item1 = vim.deepcopy(item)
              item1.insertText, item1.label = raw:lower(), raw:lower()
              table.insert(out, item1)
              local item2 = vim.deepcopy(item)
              item2.insertText, item2.label = raw:upper(), raw:upper()
              table.insert(out, item2)
              local item3 = vim.deepcopy(item)
              item3.insertText, item3.label = raw:sub(1, 1):upper() .. raw:sub(2), raw:sub(1, 1):upper() .. raw:sub(2)
              table.insert(out, item3)
              local item4 = vim.deepcopy(item)
              item4.insertText, item4.label = raw:sub(1, 1):lower() .. raw:sub(2), raw:sub(1, 1):lower() .. raw:sub(2)
              table.insert(out, item4)
            end
            return out
          end,
        },
        dictionary = {
          name = 'Dict',
          module = 'blink-cmp-dictionary',
          min_keyword_length = 3,
          opts = { dictionary_files = { vim.fn.stdpath('config') .. '/dict/en_dict.txt' } },
        },
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
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
      documentation = { auto_show = true },
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
  local lsp_path = vim.fn.stdpath('config')
  if lsp_path:sub(-1) ~= '/' then lsp_path = lsp_path .. '/' end
  lsp_path = lsp_path .. 'after/lsp'
  local servers = vim.fn.glob(lsp_path .. '/**/*.lua', true, true)
  servers = vim.tbl_map(function(path) return vim.fn.fnamemodify(path, ':t:r') end, servers)
  if #servers > 0 then vim.lsp.enable(servers) end
end

local function load_guess_indent()
  local g = require('guess-indent')
  g.setup({ on_tab_options = { expandtab = false, shiftwidth = 0, softtabstop = 0, tabstop = 8 } })
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if u.buffer.normal(buf) then g.set_from_buffer(buf, true, true) end
  end
end

local function load_surround()
  vim.g.nvim_surround_no_mappings = true
  require('nvim-surround').setup({
    surrounds = {
      [')'] = { change = { target = '^(. ?)().-( ?.)()$' } },
      ['}'] = { change = { target = '^(. ?)().-( ?.)()$' } },
      ['>'] = { change = { target = '^(. ?)().-( ?.)()$' } },
      [']'] = { change = { target = '^(. ?)().-( ?.)()$' } },
    },
    move_cursor = 'sticky',
  })
end

local function load_endwise()
  require('nvim-treesitter-endwise').init()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if u.buffer.normal(buf) then
      local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
      if require('nvim-treesitter-endwise').is_supported(lang) then require('nvim-treesitter.endwise').attach(buf) end
    end
  end
end

local function load_pair()
  require('blink.pairs').setup({
    mappings = {
      enabled = false,
      cmdline = false,
      disabled_filetypes = { 'TelescopePrompt' },
      pairs = {},
    },
    highlights = {
      enabled = true,
      cmdline = true,
      groups = {
        'BlinkPairsRed',
        'BlinkPairsOrange',
        'BlinkPairsYellow',
        'BlinkPairsGreen',
        'BlinkPairsBlue',
        'BlinkPairsCyan',
        'BlinkPairsPurple',
      },
      unmatched_group = 'BlinkPairsUnmatched',
      matchparen = {
        enabled = true,
        cmdline = true,
        include_surrounding = false,
        group = 'BlinkPairsMatchParen',
        priority = 250,
      },
    },
  })
  vim.api.nvim_set_hl(0, 'BlinkPairsRed', { default = true, fg = '#cc241d' })
  vim.api.nvim_set_hl(0, 'BlinkPairsOrange', { default = true, fg = '#d65d0e' })
  vim.api.nvim_set_hl(0, 'BlinkPairsYellow', { default = true, fg = '#d79921' })
  vim.api.nvim_set_hl(0, 'BlinkPairsGreen', { default = true, fg = '#689d6a' })
  vim.api.nvim_set_hl(0, 'BlinkPairsCyan', { default = true, fg = '#a89984' })
  vim.api.nvim_set_hl(0, 'BlinkPairsBlue', { default = true, fg = '#458588' })
  vim.api.nvim_set_hl(0, 'BlinkPairsPurple', { default = true, fg = '#b16286' })
  vim.api.nvim_set_hl(0, 'BlinkPairsUnmatched', { ctermfg = 9, fg = '#ff007c' })
  vim.api.nvim_set_hl(0, 'BlinkPairsMatchParen', { link = 'MatchParen' })
  require('ultimate-autopair.core').modes = {}
  require('ultimate-autopair').setup({
    tabout = { enable = true, hopout = true },
    fastwarp = { nocursormove = false },
    bs = { delete_from_end = false },
  })
end

load_blink()
load_pair()
load_guess_indent()
load_surround()
load_endwise()
