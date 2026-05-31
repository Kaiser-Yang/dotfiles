local M = {
  buffer = require('utils.buffer'),
  key = require('utils.key'),
}

function M.enabled(name) return vim.b[name] == true or vim.b[name] == nil and vim.g[name] ~= false end

--- Check if the current file is in the possible config directory.
function M.in_config_dir()
  local paths = { vim.fn.expand('%:p'), vim.fn.getcwd() }
  for _, path in ipairs(paths) do
    if path:find('dotfile') or path:sub(1, #vim.fn.stdpath('config')) == vim.fn.stdpath('config') then return true end
  end
  return false
end

function M.in_plugin_dir()
  local paths = { vim.fn.expand('%:p'), vim.fn.getcwd() }
  local plugin_dir = M.plugin_path()
  for _, path in ipairs(paths) do
    if path:sub(1, #plugin_dir) == plugin_dir or _G.loaded[vim.fn.fnamemodify(path, ':t')] then return true end
  end
  return false
end

function M.get(v, ...)
  if type(v) == 'function' then return v(...) end
  return v
end

--- @param suffix string
function M.gh(suffix, version, name)
  suffix = suffix:gsub('/+$', '')
  _G.loaded[name and name or suffix:match('([^/]+)$')] = true
  vim.pack.add({ { src = 'https://github.com/' .. suffix, version = version, name = name } }, { confirm = false })
end

--- @return function
function M.ensure_function(v)
  if type(v) == 'function' then return v end
  return function() return v end
end

--- @type table<string, function>
local repmove = {}
--- @param previous string|function
--- @param next string|function
--- @param comma? string|function
--- @param semicolon? string|function
--- @return table<function>
function M.ensure_repmove(previous, next, comma, semicolon, rp)
  rp = rp or repmove
  if not rp[previous] or not rp[next] then
    if _G.loaded['repmove.nvim'] then
      rp[previous], rp[next] = require('repmove').make(previous, next, comma, semicolon)
    else
      rp[previous], rp[next] = M.ensure_function(previous), M.ensure_function(next)
    end
  end
  return { rp[previous], rp[next] }
end

function M.treesitter_available(bufnr, name)
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if lang == nil then return false end
  if name == nil then return true end
  return vim.treesitter.query.get(lang, name) ~= nil
end

function M.toggle_notify(name, state, opts)
  if state then
    vim.notify('[' .. name .. ']: Enabled', vim.log.levels.INFO, opts)
  else
    vim.notify('[' .. name .. ']: Disabled', vim.log.levels.INFO, opts)
  end
end

--- Copied from nvim-treesitter-textobjects.select
--- @param start_row integer 0 indexed
--- @param start_col integer 0 indexed
--- @param end_row integer 0 indexed
--- @param end_col integer 0 indexed, exclusive
--- @param selection_mode string
function M.update_selection(start_row, start_col, end_row, end_col, selection_mode)
  selection_mode = selection_mode or 'v'

  -- enter visual mode if normal or operator-pending (no) mode
  -- Why? According to https://learnvimscriptthehardway.stevelosh.com/chapters/15.html
  --   If your operator-pending mapping ends with some text visually selected, Vim will operate on that text.
  --   Otherwise, Vim will operate on the text between the original cursor position and the new position.
  local mode = vim.api.nvim_get_mode()
  selection_mode = vim.keycode(selection_mode)
  if mode.mode ~= selection_mode then vim.cmd.normal({ selection_mode, bang = true }) end

  -- end positions with `col=0` mean "up to the end of the previous line, including the newline character"
  if end_col == 0 then
    end_row = end_row - 1
    -- +1 is needed because we are interpreting `end_col` to be exclusive afterwards
    end_col = #vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, true)[1] + 1
  end

  local end_col_offset = 1
  if selection_mode == 'v' and vim.o.selection == 'exclusive' then end_col_offset = 0 end
  end_col = end_col - end_col_offset

  -- Position is 1, 0 indexed.
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
  vim.cmd('normal! o')
  vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col })
end

--- @param cmd string
--- @param bufnr integer|nil
--- @param border string|nil
--- @return integer|nil bufnr, integer|nil winid
function M.terminal(cmd, bufnr, border)
  if cmd == nil or cmd == '' and bufnr == nil then
    vim.notify('No command provided', vim.log.levels.ERROR, { title = 'Light Boat' })
    return nil, nil
  end

  local term_buf = bufnr
  if term_buf == nil or not vim.api.nvim_buf_is_valid(term_buf) then term_buf = vim.api.nvim_create_buf(false, true) end

  border = border or vim.o.winborder
  border = border == '' and 'none' or border
  local term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = 'editor',
    width = vim.o.columns,
    height = vim.o.lines,
    row = 0,
    col = 0,
    zindex = 50,
    style = 'minimal',
    ---@diagnostic disable-next-line: assign-type-mismatch
    border = border,
  })
  if term_win == 0 then
    vim.notify('Failed to open terminal window', vim.log.levels.ERROR, { title = 'Light Boat' })
    return nil, nil
  end

  if vim.bo[term_buf].buftype ~= 'terminal' then
    vim.cmd('terminal ' .. cmd)
    vim.bo[term_buf].filetype = 'terminal'
    vim.bo[term_buf].buflisted = false
    vim.bo[term_buf].swapfile = false
    vim.bo[term_buf].bufhidden = 'hide'
    vim.wo[term_win].cursorcolumn = false
    vim.wo[term_win].signcolumn = 'no'
    vim.wo[term_win].winfixbuf = true
  end
  vim.cmd('startinsert')
  vim.cmd('nohlsearch')
  return term_buf, term_win
end

function M.in_macro_executing() return vim.fn.reg_executing() ~= '' end

function M.plugin_path() return vim.fn.stdpath('data') .. '/site/pack/core/opt' end

local builders = {}
local function register_build(name, fn) builders[name] = fn end
local function build_telescope_fzf_native()
  vim.system({ 'make' }, { cwd = M.plugin_path() .. '/telescope-fzf-native.nvim' })
end
local function build_nvim_treesitter() vim.cmd('TSUpdate') end
local function build_blink_cmp() require('blink.cmp').build():pwait() end
register_build('telescope-fzf-native.nvim', build_telescope_fzf_native)
register_build('nvim-treesitter', build_nvim_treesitter)
register_build('blink.cmp', build_blink_cmp)
local function build_plugin_internal(name)
  local fn = builders[name]
  if not fn then return end
  fn()
end

function M.builders()
  return vim.tbl_keys(builders  )
end

function M.build_plugin(names)
  if names == nil then
    for name in pairs(builders) do
      build_plugin_internal(name)
    end
  elseif type(names) == 'table' then
    for _, name in ipairs(names) do
      build_plugin_internal(name)
    end
  else
    build_plugin_internal(names)
  end
end

function M.get_cnt_prefix() return vim.v.count1 > 1 and vim.v.count1 or '' end

--- @param insertText string
--- @return string
function M.doc_from_snippet(insertText)
  local defaults = {}
  insertText = insertText:gsub('%$%{(%d+):([^}]+)%}', function(n, default)
    defaults[tonumber(n)] = default
    return default
  end)
  insertText = insertText:gsub('%$%{(%d+)%}', function(n) return defaults[tonumber(n)] or '' end)
  insertText = insertText:gsub('%$(%d+)', function(n) return defaults[tonumber(n)] or '' end)
  return insertText
end

--- @param label string
--- @param lines string|string[]
--- @param desc string?
function M.make_snippet_wrap(label, lines, desc)
  if type(lines) == 'string' then lines = { lines } end
  local insertText = table.concat(lines, '\n')
  return function(item)
    item = item and vim.deepcopy(item) or { source_name = 'Snip', source_id = 'snippets' }
    item.label = label
    item.filterText = label
    item.insertText = insertText
    item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet
    item.kind = require('blink.cmp.types').CompletionItemKind.Snippet
    item.detail = M.doc_from_snippet(insertText)
    item.textEdit = nil
    item.labelDetails = nil
    if item.source_id == 'snippets' then
      item.description = desc
    else
      item.documentation = {
        kind = 'markdown',
        value = desc or label,
      }
    end
    return item
  end
end

function M.grug_inst() return require('grug-far').get_instance(vim.api.nvim_get_current_buf()) end

-- disable global shada; create separate shadafile for each workspace
-- ensures project-scoped jumplist, marks, etc.
--—@return string?
function M.shadafile()
  local dir = vim.fs.root(0, { '.git' }) or vim.fn.getcwd()
  local workspace_uid = vim.fs.basename(dir) .. '_' .. vim.fn.sha256(dir)
  return vim.fn.stdpath('state') .. '/shada/' .. workspace_uid .. '.shada'
end

return M
