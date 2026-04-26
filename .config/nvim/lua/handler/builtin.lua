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

local lazygit_win = nil
local lazygit_buf = nil
function M.toggle_lazygit()
  if vim.fn.executable('lazygit') == 0 then
    vim.notify('lazygit is not installed or not in PATH', vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
  if lazygit_win and vim.api.nvim_win_is_valid(lazygit_win) then
    vim.api.nvim_win_hide(lazygit_win)
  else
    lazygit_buf, lazygit_win = u.terminal('lazygit', lazygit_buf, 'none')
    return lazygit_buf and lazygit_win
  end
  return true
end

local function run_single_file_command(filetype, filepath)
  if filetype == 'lua' and require('util').in_config_dir() then
    vim.cmd('%lua')
    return true
  end
  local filename_escaped = vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':t'))
  local filename_noext_escaped = vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':t:r'))
  local directory = vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':h'))
  local command_map = {
    c = string.format(
      'gcc -g -Wall %s -o %s.out && echo RUNNING && time ./%s.out',
      filename_escaped,
      filename_noext_escaped,
      filename_noext_escaped
    ),
    cpp = string.format(
      'g++ -g -Wall -std=c++23 %s -o %s.out && echo RUNNING && time ./%s.out',
      filename_escaped,
      filename_noext_escaped,
      filename_noext_escaped
    ),
    java = string.format('javac %s && echo RUNNING && time java %s', filename_escaped, filename_noext_escaped),
    sh = string.format('time sh %s', filename_escaped),
    bash = string.format('time bash %s', filename_escaped),
    zsh = string.format('time zsh %s', filename_escaped),
    python = string.format('time python %s', filename_escaped),
    lua = string.format('time lua %s', filename_escaped),
    go = string.format('go run %s', filename_escaped),
  }
  local res = command_map[filetype]
  if res then res = 'cd ' .. directory .. ' && ' .. res end
  return res
end

function M.run_single_file()
  local cmd = run_single_file_command(vim.bo.filetype, vim.fn.expand('%:p'))
  if not cmd then
    vim.notify('Unsupported filetype: ' .. vim.inspect(vim.bo.filetype), vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
  local buf, win = u.terminal(cmd)
  return buf and win
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

function M.system_yank()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 2) == 'no' then
    if vim.v.operator ~= 'y' or vim.v.register ~= '+' then return false end
    return 'y'
  elseif vim.tbl_contains({ 'n', 'v', 'V', '' }, mode:sub(1, 1)) then
    return '"+y'
  else
    vim.notify('Unsupported mode for system_yank: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

function M.system_cut()
  local mode = vim.api.nvim_get_mode().mode
  if mode:sub(1, 2) == 'no' then
    if vim.v.operator ~= 'd' or vim.v.register ~= '+' then return false end
    return 'd'
  elseif vim.tbl_contains({ 'n', 'v', 'V', '' }, mode:sub(1, 1)) then
    return '"+d'
  else
    vim.notify('Unsupported mode for system_cut: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end

function M.auto_indent()
  if vim.bo.indentexpr == '' then return false end
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local cur_indent = vim.fn.indent(row)
  vim.v.lnum = row
  local ok, correct_indent = pcall(vim.fn.eval, vim.bo.indentexpr)
  if not ok or cur_indent == correct_indent then return false end
  return '<c-f>'
end

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
    return comment_line()
  elseif vim.tbl_contains({ 'v', 'V', '' }, mode:sub(1, 1)) then
    return comment_selection()
  else
    vim.notify('Unsupported mode for toggle_comment: ' .. mode, vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
end
-- stylua: ignore start
function M.select_file() u.update_selection(0, 0, vim.api.nvim_buf_line_count(0), 0, 'V') return true end
M.system_put_before = '"+P'
M.system_yank_eol = '"+y$'
M.system_cut_eol = '"+d$'
M.to_left = '<c-w><c-h>'
M.to_bottom = '<c-w><c-j>'
M.to_above = '<c-w><c-k>'
M.to_right = '<c-w><c-l>'
M.nop = ''
-- stylua: ignore end

function M.toggle_inlay_hint()
  local status = vim.lsp.inlay_hint.is_enabled() == false
  u.toggle_notify('Inlay Hint', status, { title = 'LSP' })
  vim.lsp.inlay_hint.enable(status)
  return true
end

function M.toggle_spell()
  local status = vim.wo.spell == false
  u.toggle_notify('Spell', status, { title = 'Neovim' })
  vim.wo.spell = status
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

return M
