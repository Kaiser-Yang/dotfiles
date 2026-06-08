local M = {
  buffer = require('utils.buffer'),
  key = require('utils.key'),
}

function M.enabled(name, buf)
  buf = buf or 0
  return vim.b[buf][name] == true or vim.b[buf][name] == nil and vim.g[name] ~= false
end

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
--- @param filetypes? string|string[]
--- @return table<function>
function M.ensure_repmove(previous, next, comma, semicolon, filetypes)
  if not repmove[previous] or not repmove[next] then
    if _G.loaded['repmove.nvim'] then
      repmove[previous], repmove[next] = require('repmove').make(previous, next, comma, semicolon, filetypes)
    else
      repmove[previous], repmove[next] = M.ensure_function(previous), M.ensure_function(next)
    end
  end
  return { repmove[previous], repmove[next] }
end

function M.treesitter_available(bufnr, name)
  local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
  if lang == nil then return false end
  local parser = vim.treesitter.get_parser(bufnr, lang)
  if not parser then return false end
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
--- @param selection_mode string?
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

--- @param cmd string?
--- @param bufnr? integer
--- @param win_opts? vim.api.keyset.win_config
--- @return integer|nil bufnr, integer|nil winid
function M.terminal(cmd, bufnr, win_opts)
  cmd = cmd or ''
  local term_buf = bufnr
  if term_buf == nil or not vim.api.nvim_buf_is_valid(term_buf) then term_buf = vim.api.nvim_create_buf(false, true) end

  local term_win = vim.api.nvim_open_win(term_buf, true, win_opts or {})
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
    vim.wo[term_win][0].cursorcolumn = false
    vim.wo[term_win][0].signcolumn = 'no'
    vim.wo[term_win][0].winfixbuf = true
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

function M.builders() return vim.tbl_keys(builders) end

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

function M.get_cnt_prefix() return vim.v.count > 0 and vim.v.count or '' end

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

local function get_visible_windows()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local visible_windows = {}
  for _, win in ipairs(windows) do
    local win_config = vim.api.nvim_win_get_config(win)
    -- ignore invisible windows and floating windows
    if not win_config.hide and win_config.relative == '' then visible_windows[#visible_windows + 1] = win end
  end
  return visible_windows
end

--- Get the nearest neighbor window of the given window,
--- win is the window id
---
--- @param win number the window id
--- @param direction 'left'|'right'|'top'|'bottom'
--- @return number|nil|number[]
function M.get_nearest_neighbor(win, direction)
  local current_pos = vim.api.nvim_win_get_position(win)
  local current_row, current_col = current_pos[1], current_pos[2]
  local curretn_height = vim.api.nvim_win_get_height(win)
  local current_width = vim.api.nvim_win_get_width(win)

  local windows = {}
  for _, win_in_tab in ipairs(get_visible_windows()) do
    if win_in_tab == win then goto continue end
    local pos = vim.api.nvim_win_get_position(win_in_tab)
    local row, col = pos[1], pos[2]
    local height = vim.api.nvim_win_get_height(win_in_tab)
    local width = vim.api.nvim_win_get_width(win_in_tab)
    if
      direction == 'left' and col + width < current_col
      or direction == 'right' and col > current_col + current_width
      or direction == 'top' and row + height < current_row
      or direction == 'bottom' and row > current_row + curretn_height
    then
      table.insert(windows, win_in_tab)
    end
    ::continue::
  end
  local neighbors = {}
  for _, win_in_direction in ipairs(windows) do
    local pos = vim.api.nvim_win_get_position(win_in_direction)
    local row, col = pos[1], pos[2]
    local height = vim.api.nvim_win_get_height(win_in_direction)
    local width = vim.api.nvim_win_get_width(win_in_direction)
    if
      direction == 'left' and (#neighbors == 0 or col + width > neighbors[1].col + neighbors[1].width)
      or direction == 'right' and (#neighbors == 0 or col < neighbors[1].col)
      or direction == 'top' and (#neighbors == 0 or row + height > neighbors[1].row + neighbors[1].height)
      or direction == 'bottom' and (#neighbors == 0 or row < neighbors[1].row)
    then
      neighbors = {
        {
          id = win_in_direction,
          row = row,
          col = col,
          width = width,
          height = height,
        },
      }
    elseif
      direction == 'left' and #neighbors > 0 and col + width == neighbors[1].col + neighbors[1].width
      or direction == 'right' and #neighbors > 0 and col == neighbors[1].col
      or direction == 'top' and #neighbors > 0 and row + height == neighbors[1].row + neighbors[1].height
      or direction == 'bottom' and #neighbors > 0 and row == neighbors[1].row
    then
      table.insert(neighbors, {
        id = win_in_direction,
        row = row,
        col = col,
      })
    end
  end
  if #neighbors == 0 then
    return nil
  elseif #neighbors == 1 then
    return neighbors[1].id
  else
    local neighbor = nil
    for _, win_in_direction in ipairs(neighbors) do
      if
        (direction == 'left' or direction == 'right') and win_in_direction.row == current_row
        or (direction == 'top' or direction == 'bottom') and win_in_direction.col == current_col
      then
        neighbor = win_in_direction
        break
      end
    end
    if not neighbor then
      local neighbor_ids = {}
      for _, win_in_direction in ipairs(neighbors) do
        table.insert(neighbor_ids, win_in_direction.id)
      end
      return neighbor_ids
    end
    return neighbor.id
  end
end

return M
