local u = require('utils')
local M = {}

local live_grep_ivy
local find_word_ivy
local find_file_dropdown

local function find_closing_quote(s, q)
  q = q or '"'
  local n = #s
  local i = 2
  while i <= n do
    local c = s:sub(i, i)
    if c == '\\' then
      i = i + 2
    elseif c == q then
      return i
    else
      i = i + 1
    end
  end
  return nil
end

local function get_input(buffer)
  local line = require('telescope.actions.state').get_current_line()
  local picker = require('telescope.actions.state').get_current_picker(buffer)
  if picker.prompt_title:match('Live Grep') and #line > 0 then
    if line:sub(1, 1) == '"' then
      local idx = find_closing_quote(line)
      if idx == nil then return line end
      return line:sub(2, idx - 1)
    else
      local res = line:match('^[^-]*')
      if #res < #line and res:sub(-1) == ' ' then res = res:sub(1, -2) end
      return res
    end
  end
  return line
end

--- @param s string
--- @return string
local function escape_for_quote(s)
  local res = {}
  local i = 1
  while i <= #s do
    local c = s:sub(i, i)
    if c == '\\' then
      table.insert(res, s:sub(i, i + 1))
      i = i + 2
    elseif c == '"' or c == "'" then
      table.insert(res, '\\' .. c)
      i = i + 1
    else
      table.insert(res, c)
      i = i + 1
    end
  end
  return table.concat(res)
end
--- @param s string
--- @return string
local function unescape_quoted_inner(s)
  local res = {}
  local i = 1
  while i <= #s do
    local c = s:sub(i, i)
    if c == '\\' then
      local next = s:sub(i + 1, i + 1)
      if next ~= '"' and next ~= "'" then table.insert(res, c) end
      table.insert(res, next)
      i = i + 2
    else
      table.insert(res, c)
      i = i + 1
    end
  end
  return table.concat(res)
end
--- @param s string
--- @param q string
--- @return string? inner
--- @return string? rest
local function extract_quoted_and_rest(s, q)
  local end_idx = find_closing_quote(s, q)
  if not end_idx then return nil, nil end
  return unescape_quoted_inner(s:sub(2, end_idx - 1)), s:sub(end_idx + 1)
end
-- Main factory: returns a function suitable for which-key / telescope mappings
function M.toggle_quotation(prompt_bufnr)
  local quote_char = '"'
  local action_state = require('telescope.actions.state')
  local picker = action_state.get_current_picker(prompt_bufnr)
  if not picker then return end
  local prompt = picker:_get_prompt() or ''
  local quoted = prompt:sub(1, 1) == quote_char
  local inner, rest
  if quoted then
    inner, rest = extract_quoted_and_rest(prompt, quote_char)
    quoted = inner ~= nil and rest ~= nil
  end
  if quoted then
    _G.last_args = rest
    picker:set_prompt(inner)
  else
    local escaped = escape_for_quote(prompt)
    picker:set_prompt(quote_char .. escaped .. quote_char .. (_G.last_args or ' '))
  end
end

function M.smart_select_all(buffer)
  local picker = require('telescope.actions.state').get_current_picker(buffer)
  local all_selected = #picker:get_multi_selection() == picker.manager:num_results()
  local a = require('telescope.actions')
  if all_selected then
    a.drop_all(buffer)
  else
    a.select_all(buffer)
  end
  return true
end

function M.toggle_find_file(buffer)
  local input = get_input(buffer)
  local opts = { default_text = input }
  find_word_ivy = nil
  live_grep_ivy = nil
  require('telescope.actions').close(buffer)
  if find_file_dropdown then
    find_file_dropdown = false
    require('telescope.builtin').find_files(opts)
  else
    return M.find_file(opts)
  end
  return true
end

function M.find_file(opts)
  if not _G.loaded['telescope.nvim'] then return false end
  find_file_dropdown = true
  find_word_ivy = nil
  live_grep_ivy = nil
  opts = vim.tbl_deep_extend('force', {
    previewer = false,
    layout_config = { anchor = 'N', anchor_padding = 0 },
  }, opts or {})
  opts = require('telescope.themes').get_dropdown(opts)
  require('telescope.builtin').find_files(opts)
  return true
end

local function live_grep(opts)
  if _G.loaded['telescope-live-grep-args.nvim'] then
    require('telescope').extensions.live_grep_args.live_grep_args(opts)
  else
    require('telescope.builtin').live_grep(opts)
  end
end
function M.toggle_live_grep(buffer)
  if not _G.loaded['telescope.nvim'] then return false end
  local input = require('telescope.actions.state').get_current_line()
  local opts = { default_text = input }
  require('telescope.actions').close(buffer)
  find_file_dropdown = nil
  find_word_ivy = nil
  if live_grep_ivy then
    live_grep_ivy = false
    live_grep(opts)
  else
    M.live_grep(opts)
  end
  return true
end

function M.live_grep(opts)
  if not _G.loaded['telescope.nvim'] then return false end
  live_grep_ivy = true
  find_word_ivy = nil
  find_file_dropdown = nil
  opts = vim.tbl_deep_extend('force', {
    layout_config = { height = 0.4 },
  }, opts or {})
  opts = require('telescope.themes').get_ivy(opts)
  live_grep(opts)
  return true
end

function M.auto_commands()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').autocommands()
  return true
end

function M.find_word(opts)
  if not _G.loaded['telescope.nvim'] then return false end
  find_word_ivy = true
  live_grep_ivy = nil
  find_file_dropdown = nil
  opts = vim.tbl_deep_extend('force', {
    layout_config = { height = 0.4 },
  }, opts or {})
  opts = require('telescope.themes').get_ivy(opts)
  require('telescope.builtin').grep_string(opts)
  return true
end

function M.toggle_find_word(buffer)
  if not _G.loaded['telescope.nvim'] then return false end
  local input = get_input(buffer)
  local opts = { default_text = input }
  require('telescope.actions').close(buffer)
  find_file_dropdown = nil
  live_grep_ivy = nil
  if find_word_ivy then
    find_word_ivy = false
    require('telescope.builtin').grep_string(opts)
  else
    return M.find_word(opts)
  end
  return true
end

function M.help_tags()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').help_tags()
  return true
end

function M.registers()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').registers()
  return true
end

function M.resume()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').resume()
  return true
end

function M.buffers()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').buffers()
  return true
end

function M.diagnostics()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').diagnostics()
  return true
end

function M.qflist()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').quickfix()
  return true
end

function M.loclist()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').loclist()
  return true
end

function M.highlights()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').highlights()
  return true
end

function M.keymaps()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').keymaps()
  return true
end

function M.man_pages()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').man_pages()
  return true
end

function M.pickers()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').builtin()
  return true
end

function M.oldfiles()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').oldfiles()
  return true
end

function M.todo()
  if not _G.loaded['telescope.nvim'] or not _G.loaded['todo-comments.nvim'] then return false end
  require('telescope').extensions['todo-comments'].todo()
  return true
end

function M.current_buffer_fuzzy_find()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').current_buffer_fuzzy_find()
  return true
end

local l_dir = vim.fn.fnameescape(u.plugin_path())
local c_dir = vim.fn.fnameescape(vim.fn.stdpath('config'))
M.live_grep_config = function()
  if not _G.loaded['telescope.nvim'] then return false end
  live_grep({ cwd = c_dir })
  return true
end

M.live_grep_plugin = function()
  if not _G.loaded['telescope.nvim'] then return false end
  live_grep({ cwd = l_dir })
  return true
end

M.find_file_config = function()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').find_files({ cwd = c_dir })
  return true
end

M.find_file_plugin = function()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').find_files({ cwd = l_dir })
  return true
end

function M.live_grep_open_file()
  if not _G.loaded['telescope.nvim'] then return false end
  require('telescope.builtin').live_grep({
    grep_open_files = true,
    prompt_title = 'Live Grep (Open Files)',
  })
  return true
end

return M
