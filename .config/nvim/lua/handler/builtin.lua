local M = {}
local u = require('utils')

local function delete_to_eow_insert()
  local orig_row, orig_col = unpack(vim.api.nvim_win_get_cursor(0))
  local bufnr = 0
  local line = vim.api.nvim_get_current_line()
  local line_count = vim.api.nvim_buf_line_count(bufnr)

  if orig_row == line_count and orig_col == #line then return false end

  vim.cmd('normal! wge')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_win_set_cursor(0, { orig_row, orig_col })
  if row == orig_row and col == orig_col then
    return '<del>'
  else
    vim.cmd('normal! de')
  end
  vim.api.nvim_win_set_cursor(0, { orig_row, orig_col })
  return true
end

local function delete_to_eow_command()
  local line = vim.fn.getcmdline()
  local col0 = vim.fn.getcmdpos() - 1 -- 0-based
  if col0 == #line then return false end

  local word_pattern = '\\k\\+' -- Vim regex: keyword sequence
  local after = line:sub(col0 + 1)
  local m = vim.fn.matchstrpos(after, word_pattern)
  local start_idx = m[2]
  local end_idx = m[3]

  local new_after
  if start_idx == -1 then
    new_after = ''
  else
    new_after = after:sub(end_idx + 1) or ''
  end
  local new_line = (line:sub(1, col0) or '') .. new_after
  return vim.fn.setcmdline(new_line, col0 + 1) == 0
end

local function cursor_to_bol_insert()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == 0 then return false end
  local first_non_blank = #(line:match('^%s*') or '')
  if col <= first_non_blank then first_non_blank = 0 end
  vim.bo.undolevels = vim.bo.undolevels
  vim.api.nvim_win_set_cursor(0, { row, first_non_blank })
  return true
end

local format = { '^:', '^/', '^%?', '^:%s*!', '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*', '^:%s*he?l?p?%s+', '^=' }
local function cursor_to_bol_command()
  local line = vim.fn.getcmdtype() .. vim.fn.getcmdline()
  local matched = nil
  for _, p in pairs(format) do
    local cur_matched = line:match(p)
    if not matched or cur_matched and #cur_matched > #matched then matched = cur_matched end
  end
  local col = vim.fn.getcmdpos()
  if col <= 1 then
    return false
  else
    if not matched or col <= #matched then
      vim.fn.setcmdline(line:sub(2), 1)
    else
      vim.fn.setcmdline(line:sub(2), #matched)
    end
  end
  return true
end

local function toggle_comment_insert_mode()
  local commentstring = vim.bo.commentstring
  if not commentstring or commentstring:match('^%s*$') or commentstring:find('%%s') == nil then return false end

  local indent, line = vim.api.nvim_get_current_line():match('^(%s*)(.*)$')
  -- split commentstring into left and right around "%s"
  local left, right = commentstring:match('^(.-)%%s(.-)$')
  left = left or ''
  right = right or ''

  -- cursor col BEFORE change (0-indexed)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local col = cursor[2]

  -- detect if the line (after indent) is already wrapped by left and right
  local has_left = (#left == 0) or (line:sub(1, #left) == left)
  local has_right = (#right == 0) or (line:sub(-#right) == right)

  local new_line
  local shift = 0 -- desired change in column relative to original col

  if has_left and has_right then
    -- remove the surrounding left/right (toggle off)
    local content_start = #left + 1
    local content_end = #line - #right
    if content_end < content_start then
      new_line = indent
    else
      new_line = indent .. line:sub(content_start, content_end)
    end
    shift = -#left
  else
    -- add left and right around the existing content (toggle on)
    new_line = indent .. left .. line .. right
    shift = #left
  end

  -- apply the new line (this may move the cursor automatically)
  vim.api.nvim_set_current_line(new_line)

  -- compute desired column after the change, clamped to the new line length and not before indent
  local new_content_len = #new_line - #indent
  if new_content_len < 0 then new_content_len = 0 end
  local min_col = #indent
  local max_col = #indent + math.max(0, new_content_len)
  local desired_col = col
  if col >= #indent then
    desired_col = col + shift
    if desired_col < min_col then desired_col = min_col end
    if desired_col > max_col then desired_col = max_col end
  end

  -- read actual column after set_current_line
  local actual_col = vim.api.nvim_win_get_cursor(0)[2]

  local delta = desired_col - actual_col
  return string.rep(delta > 0 and '<right>' or '<left>', math.abs(delta))
end

local function cursor_to_eol_insert()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  if col == #line then return false end
  local last_non_blank = #(line:match('^(.-)%s*$') or '')
  if col >= last_non_blank then last_non_blank = #line end
  vim.bo.undolevels = vim.bo.undolevels
  vim.api.nvim_win_set_cursor(0, { row, last_non_blank })
  return true
end

local function cursor_to_eol_command()
  local line = vim.fn.getcmdline()
  local col0 = vim.fn.getcmdpos() - 1 -- 0-based
  if col0 == #line then return false end
  local last_non_blank = #(line:match('^(.-)%s*$') or '')
  if col0 >= last_non_blank then last_non_blank = #line end
  return vim.fn.setcmdline(line, last_non_blank + 1) == 0
end

local function delete_to_eol_command()
  local line = vim.fn.getcmdline()
  local col0 = vim.fn.getcmdpos() - 1 -- 0-based
  if col0 == #line then return false end
  local last_non_blank = #(line:match('^(.-)%s*$') or '')
  if col0 >= last_non_blank then last_non_blank = #line end
  local new_line = line:sub(1, col0) .. line:sub(last_non_blank + 1)
  return vim.fn.setcmdline(new_line, col0 + 1) == 0
end

local function delete_to_eol_insert()
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  if col == #line then return false end
  local last_non_blank = #(line:match('^(.-)%s*$') or '')
  if col >= last_non_blank then last_non_blank = #line end
  vim.bo.undolevels = vim.bo.undolevels
  if last_non_blank == #line then
    vim.cmd('normal! d$')
  else
    vim.cmd('normal! dg_')
  end
  vim.api.nvim_win_set_cursor(0, { row, col })
  return true
end

function M.delete_to_eol()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 1) == 'i' then
    return delete_to_eol_insert()
  elseif mode:sub(1, 1) == 'c' then
    return delete_to_eol_command()
  else
    vim.notify('Unsupported mode for delete_to_eol: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

local command_templates = {
  c = function(filename_escaped)
    return string.format('gcc -g -Wall %s -o a.out && echo RUNNING && time ./a.out', filename_escaped)
  end,
  cpp = function(filename_escaped)
    return string.format('g++ -g -Wall -std=c++23 %s -o a.out && echo RUNNING && time ./a.out', filename_escaped)
  end,
  java = function(filename_escaped, filename_noext_escaped)
    return string.format('javac %s && echo RUNNING && time java %s', filename_escaped, filename_noext_escaped)
  end,
  sh = function(filename_escaped) return string.format('time sh %s', filename_escaped) end,
  bash = function(filename_escaped) return string.format('time bash %s', filename_escaped) end,
  zsh = function(filename_escaped) return string.format('time zsh %s', filename_escaped) end,
  python = function(filename_escaped) return string.format('time python %s', filename_escaped) end,
  lua = function(filename_escaped) return string.format('time lua %s', filename_escaped) end,
  go = function(filename_escaped) return string.format('time go run %s', filename_escaped) end,
}
local function run_single_file_command(filetype, filepath)
  local filename_escaped = vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':t'))
  local filename_noext_escaped = vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':t:r'))
  local directory_escaped = vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':h'))
  local template_fn = command_templates[filetype]
  if not template_fn then return nil end
  return 'cd ' .. directory_escaped .. ' && ' .. template_fn(filename_escaped, filename_noext_escaped)
end

local function make_system_op(name, op, normal_cmd)
  return function()
    local mode = vim.api.nvim_get_mode().mode
    if mode:sub(1, 2) == 'no' then
      if vim.v.operator ~= op or vim.v.register ~= '+' then return false end
      return op
    elseif vim.tbl_contains({ 'n', 'v', 'V', '' }, mode:sub(1, 1)) then
      return normal_cmd
    else
      vim.notify('Unsupported mode for ' .. name .. ': ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
      return false
    end
  end
end

function M.cursor_to_eol()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 1) == 'i' then
    return cursor_to_eol_insert()
  elseif mode:sub(1, 1) == 'c' then
    return cursor_to_eol_command()
  else
    vim.notify('Unsupported mode for cursor_to_eol: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

function M.delete_to_eow()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 1) == 'i' then
    return delete_to_eow_insert()
  elseif mode:sub(1, 1) == 'c' then
    return delete_to_eow_command()
  else
    vim.notify('Unsupported mode for delete_to_eow: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

function M.cursor_to_bol()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 1) == 'i' then
    return cursor_to_bol_insert()
  elseif mode:sub(1, 1) == 'c' then
    return cursor_to_bol_command()
  else
    vim.notify('Unsupported mode for cursor_to_bol: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

local function competi_test()
  if not vim.fn.expand('%:p'):match('OJProblems') or not _G.loaded['competitest.nvim'] then return false end
  if vim.api.nvim_buf_get_name(0) == '' then
    vim.cmd('CompetiTest receive problem')
    return true
  end
  local file_dir = vim.fn.expand('%:p:h')
  local file_name = vim.fn.expand('%:t:r')
  if vim.fn.filereadable(file_dir .. '/' .. file_name .. '_0.in') == 0 then
    vim.cmd('CompetiTest receive testcases')
  else
    vim.cmd('CompetiTest run')
  end
  return true
end

local floating_win_opts = {
  relative = 'editor',
  width = vim.o.columns,
  height = vim.o.lines,
  row = 0,
  col = 0,
  border = 'none',
}
function M.run_single_file()
  if competi_test() then return true end
  local filetype = vim.bo.filetype
  if filetype == 'lua' and u.in_config_dir() then
    vim.cmd('%lua')
    return true
  elseif filetype == 'markdown' and _G.loaded['markdown-preview.nvim'] then
    vim.cmd('MarkdownPreview')
    return true
  end
  local cmd = run_single_file_command(vim.bo.filetype, vim.fn.expand('%:p'))
  if not cmd or type(cmd) ~= 'string' then
    vim.notify('Unsupported filetype: ' .. vim.inspect(vim.bo.filetype), vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
  local buf, win = u.terminal(cmd, nil, floating_win_opts)
  return buf and win
end

local lazygit_win = nil
local lazygit_buf = nil
function M.toggle_lazygit()
  if vim.fn.executable('lazygit') == 0 then
    vim.notify('"lazygit" is not installed or not in PATH', vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
  if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
    vim.api.nvim_win_hide(lazygit_win)
  else
    lazygit_buf, lazygit_win = u.terminal('lazygit', lazygit_buf, floating_win_opts)
    return lazygit_buf ~= nil and lazygit_win ~= nil
  end
  return true
end

local function get_left_nvimtree_width()
  local left_win = nil
  local min_col = math.huge
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == '' then
      local pos = vim.api.nvim_win_get_position(win)
      if pos[2] < min_col then
        min_col = pos[2]
        left_win = win
      end
    end
  end
  if left_win then
    local buf = vim.api.nvim_win_get_buf(left_win)
    if vim.bo[buf].filetype == 'NvimTree' then return vim.api.nvim_win_get_width(left_win) end
  end
  return 0
end
local terminal_win = nil
local terminal_buf = nil
function M.toggle_terminal()
  if
    terminal_win
    and vim.api.nvim_win_is_valid(terminal_win)
    and vim.tbl_contains(vim.api.nvim_tabpage_list_wins(0), terminal_win)
  then
    vim.api.nvim_win_hide(terminal_win)
  else
    local left_offset = get_left_nvimtree_width()
    local total_width = vim.o.columns
    local total_height = vim.o.lines
    local height = math.floor(math.max(12, total_height / 4))
    --- @type vim.api.keyset.win_config
    local config = {
      relative = 'editor',
      row = total_height - height,
      col = left_offset,
      width = total_width - left_offset,
      height = height,
      border = { '', '─', '', '', '', '', '', '' },
    }
    terminal_buf, terminal_win = u.terminal(nil, terminal_buf, config)
    return terminal_buf ~= nil and terminal_win ~= nil
  end
  return true
end

M.system_yank = make_system_op('system_yank', 'y', '"+y')
M.system_cut = make_system_op('system_cut', 'd', '"+d')

local system_put_command = '<c-r><c-r>+'
local system_put_insert = '<cmd>set paste<cr><c-g>u<c-r><c-r>+<cmd>set nopaste<cr>'
local system_put = '"+p'
function M.system_put()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 1) == 'c' then
    return system_put_command
  elseif mode:sub(1, 1) == 'i' then
    return system_put_insert
  elseif vim.tbl_contains({ 'n', 'v', 'V', '' }, mode:sub(1, 1)) then
    return system_put
  else
    vim.notify('Unsupported mode for system_put: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

local function comment() return require('vim._comment').operator() end
local function comment_line() return require('vim._comment').operator() .. '_' end
local function comment_line_insert() return toggle_comment_insert_mode() end
local function comment_selection() return comment() end
function M.toggle_comment()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 1) == 'i' then
    return comment_line_insert()
  elseif mode:sub(1, 1) == 'n' then
    return u.get_cnt_prefix() .. comment_line()
  elseif vim.tbl_contains({ 'v', 'V', '' }, mode:sub(1, 1)) then
    return comment_selection()
  else
    vim.notify('Unsupported mode for toggle_comment: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

function M.select_file()
  u.update_selection(0, 0, vim.api.nvim_buf_line_count(0), 0, 'V')
  return true
end
M.system_put_before = '"+P'
M.system_yank_eol = '"+y$'
M.system_cut_eol = '"+d$'
M.nop = ''

local window_extra = {
  h = '<cmd>TmuxNavigateLeft<cr>',
  j = '<cmd>TmuxNavigateDown<cr>',
  k = '<cmd>TmuxNavigateUp<cr>',
  l = '<cmd>TmuxNavigateRight<cr>',
}
function M.window(key)
  if window_extra[key] then
    return function()
      if _G.loaded['vim-tmux-navigator'] then return window_extra[key] end
      return '<c-w>' .. key
    end
  end
  return '<c-w>' .. key
end

function M.toggle_spell()
  local status = vim.wo.spell == false
  vim.wo.spell = status
  u.toggle_notify('Spell', status, { title = 'Neovim' })
  return true
end

function M.toggle_treesitter()
  local buf = vim.api.nvim_get_current_buf()
  local status = vim.treesitter.highlighter.active[buf] == nil
  if status then
    local ok, error = pcall(vim.treesitter.start, buf)
    if not ok then
      vim.notify(error or 'Unknown Error', vim.log.levels.ERROR, { title = 'Treesitter' })
      return false
    end
  else
    vim.treesitter.stop(buf)
  end
  u.toggle_notify('Treesitter Highlight', status, { title = 'Treesitter' })
  return true
end

local function diagnostic_cnt()
  local cnt = 0
  for _, c in ipairs(vim.diagnostic.count()) do
    cnt = cnt + c
  end
  return cnt
end

M.up = '<up>'
M.down = '<down>'
M.left = '<left>'
M.right = '<right>'
M.word_backward = '<s-left>'
M.word_forward = '<s-right>'
M.last_s_cmd = '<cmd>&&<cr>'
M.no_hl_search = '<cmd>nohlsearch<cr>'
M.tab_split = '<cmd>tab split<cr>'
M.around_angle_bracket = 'a<'
M.inside_angle_bracket = 'i<'
M.around_square_bracket = 'a['
M.inside_square_bracket = 'i['
M.around_tilde_bracket = 'a`'
M.inside_tilde_bracket = 'i`'
M.inspect = '<cmd>Inspect<cr>'
M.back_to_normal = '<c-\\><c-n>'

M.diagnostic_qflist = function()
  vim.diagnostic.setqflist()
  return diagnostic_cnt() > 0
end

M.diagnostic_loclist = function()
  vim.diagnostic.setloclist()
  return diagnostic_cnt() > 0
end

function M.insert_undo_point()
  u.key.feed('<c-g>u', 'n')
  return false
end

function M.toggle_diagnostic()
  local bufnr = vim.api.nvim_get_current_buf()
  local status = not vim.diagnostic.is_enabled({ bufnr = bufnr })
  vim.diagnostic.enable(status, { bufnr = bufnr })
  u.toggle_notify('Diagnostic', status, { title = 'Diagnostic' })
end

function M.jump_list_wrap(key, cnt)
  cnt = cnt or 5
  return function()
    local res = u.get_cnt_prefix() .. key
    if vim.v.count1 > cnt then vim.cmd("normal! m'") end
    return res
  end
end

function M.select_tab(target) return '<cmd>' .. (target or u.get_cnt_prefix()) .. 'tabnext<cr>' end

--- @param direction 'left'|'right'|'top'|'bottom'
function M.swap_wrap(direction)
  return function()
    local cur_win = vim.api.nvim_get_current_win()
    local nei_win = u.get_nearest_neighbor(cur_win, direction)
    if nei_win == nil then return false end
    if type(nei_win) == 'table' then nei_win = nei_win[1] end
    local cur_buf = vim.api.nvim_win_get_buf(cur_win)
    local nei_buf = vim.api.nvim_win_get_buf(nei_win)
    if vim.wo[cur_win].winfixbuf or vim.wo[nei_win].winfixbuf then return false end
    local cur_pos = vim.api.nvim_win_get_cursor(cur_win)
    local nei_pos = vim.api.nvim_win_get_cursor(nei_win)
    vim.api.nvim_win_set_buf(cur_win, nei_buf)
    vim.api.nvim_win_set_buf(nei_win, cur_buf)
    vim.api.nvim_set_current_win(nei_win)
    vim.api.nvim_win_set_cursor(nei_win, cur_pos)
    vim.api.nvim_win_set_cursor(cur_win, nei_pos)
    return true
  end
end

--- @param line string
--- @param escapes? string|string[]
--- @return table<number, boolean> 1-indexed
local function compute_escaped(line, escapes)
  escapes = escapes or {}
  if type(escapes) == 'string' then escapes = { escapes } end
  local len = #line
  local escaped = {}
  for i = 1, len do
    escaped[i] = false
  end
  local i = 1
  while i <= len do
    for _, e in ipairs(escapes) do
      if i + #e <= len and line:sub(i, i + #e - 1) == e then
        escaped[i + #e] = true
        i = i + #e + 1
        goto continue
      end
    end
    i = i + 1
    ::continue::
  end
  return escaped
end

--- @param line string
--- @param start number 1-indexed
--- @param direction number
--- @param char string
--- @param escaped table
--- @return number? 1-indexed
local function find_next_char(line, start, direction, char, escaped)
  local len = #line
  local pos = start + direction
  while direction == 1 and pos + #char - 1 <= len or direction == -1 and pos >= 1 do
    if line:sub(pos, pos + #char - 1) == char and not escaped[pos] then return pos end
    pos = pos + direction
  end
end

--- @param line string
--- @param pos number 1-indexed
--- @param char string
--- @param escaped table
--- @return number? 1-indexed
--- @return number? 1-indexed
local function find_pair_for_char(line, pos, char, escaped)
  local positions = {}
  local i = 1
  local len = #line
  while i <= len - #char + 1 do
    if line:sub(i, i + #char - 1) == char and not escaped[i] then
      table.insert(positions, i)
      i = i + #char
    else
      i = i + 1
    end
  end
  local idx = nil
  ---@diagnostic disable-next-line: redefined-local
  for i, p in ipairs(positions) do
    if p == pos then
      idx = i
      break
    end
  end
  if not idx then return nil, nil end
  if idx % 2 == 1 then
    if idx + 1 <= #positions then return pos, positions[idx + 1] end
  else
    if idx - 1 >= 1 then return positions[idx - 1], pos end
  end
  return nil, nil
end

--- @param line string
--- @param cursor number 1-indexed
--- @param char string
--- @param escaped table
--- @return number? 1-indexed
--- @return number? 1-indexed
local function find_pair_around_cursor(line, cursor, char, escaped)
  local left = find_next_char(line, cursor, -1, char, escaped)
  local right = find_next_char(line, cursor, 1, char, escaped)
  if left and right and left < right then return left, right end
  local first = right
  if not first then return end
  local second = find_next_char(line, first + #char, 1, char, escaped)
  if not second then return end
  return first, second
end

--- @param left number 1-indexed
--- @param right number 1-indexed
--- @param line string
--- @param action 'i'|'a'
--- @param char_len number
--- @return number 0-indexed inclusive
--- @return number 0-indexed exclusive
local function apply_action(left, right, line, action, char_len)
  if action == 'i' then
    -- minus 1 here to convert to 0-indexed
    return left - 1 + char_len, right - 1
  elseif action == 'a' then
    local l = left - 1 -- 0-indexed
    local r = right - 1 + char_len -- 0-indexed exclusive
    local len = #line
    if r < len and line:sub(r + 1, r + 1) == ' ' then
      r = r + 1
    elseif l > 0 and line:sub(l, l) == ' ' then
      l = l - 1
    end
    return l, r
  end
  error('impossible')
end

--- @param action 'i'|'a'
--- @param char string
--- @param escapes? string|string[]
--- @return number? start_col 0-indexed inclusive
--- @return number? end_col 0-indexed exclusive
local function get_range(action, char, escapes)
  local mode = vim.fn.mode()
  local is_visual = mode:match('[vV\22]') ~= nil
  local line = vim.fn.getline('.')
  if line == '' then return end
  local escaped = compute_escaped(line, escapes)
  local char_len = #char
  if char_len == 0 then return end

  local function find_pair_at(pos)
    local cur_sub = line:sub(pos, pos + char_len - 1)
    if cur_sub == char and not escaped[pos] then
      return find_pair_for_char(line, pos, char, escaped)
    else
      return find_pair_around_cursor(line, pos, char, escaped)
    end
  end

  local cursor
  if not is_visual then
    cursor = vim.fn.getcurpos()[3] -- 1-indexed
  else
    local start_pos = vim.fn.getpos('.')
    local end_pos = vim.fn.getpos('v')
    if start_pos[2] ~= end_pos[2] then return end
    local start_col = start_pos[3] -- 1-indexed
    local end_col = end_pos[3] -- 1-indexed
    cursor = math.min(start_col, end_col)
  end
  local left, right = find_pair_at(cursor)
  if not left or not right then return end
  return apply_action(left, right, line, action, char_len)
end

---@class selection
---@field left integer
---@field right integer

--- @param selections selection[]
--- @param col integer
--- @return selection?
local function choose_best_selection(selections, col)
  local best_inside = nil
  local best_inside_len = math.huge
  local best_right = nil
  local best_right_dist = math.huge
  local best_left = nil
  local best_left_dist = math.huge

  for _, sel in ipairs(selections) do
    local inside = (col >= sel.left and col < sel.right)
    if inside then
      local len = sel.right - sel.left
      if len < best_inside_len then
        best_inside = sel
        best_inside_len = len
      end
    elseif col <= sel.left then
      local dist = sel.left - col
      if dist < best_right_dist then
        best_right = sel
        best_right_dist = dist
      end
    elseif col >= sel.right then
      local dist = col - sel.right
      if dist < best_left_dist then
        best_left = sel
        best_left_dist = dist
      end
    end
  end
  return best_inside or best_right or best_left or nil
end

--- @param action 'a'|'i'
--- @param chars string|string[]
--- @param escapes? string[]|table<string, string[]>
function M.action_wrap(action, chars, escapes)
  if type(chars) == 'string' then
    if escapes and not escapes[chars] then escapes[chars] = escapes end
    chars = { chars }
  end
  escapes = escapes or {}
  return function()
    ---@type selection[]
    local selections = {}
    for _, char in ipairs(chars) do
      local left, right = get_range(action, char, escapes[char])
      if left and right then table.insert(selections, { left = left, right = right }) end
    end
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local col = cursor_pos[2] -- 0-indexed
    local best = choose_best_selection(selections, col)
    if best then
      local row = cursor_pos[1] - 1 -- 0-indexed
      u.update_selection(row, best.left, row, best.right)
    end
    return best ~= nil
  end
end

return M
