local M = {
  buffer = require('utils.buffer'),
  key = require('utils.key'),
}

function M.enabled(name) return vim.b[name] == true or vim.b[name] == nil and vim.g[name] == true end

--- Check if the current file is in the possible config directory.
function M.in_config_dir()
  local paths = { vim.fn.expand('%:p'), vim.fn.getcwd() }
  for _, path in ipairs(paths) do
    if path:find('dotfile') or path:sub(1, #vim.fn.stdpath('config')) == vim.fn.stdpath('config') then return true end
  end
  return false
end

function M.get(v, ...)
  if type(v) == 'function' then return v(...) end
  return v
end

function M.gh(suffix, version, name)
  return {
    src = 'https://github.com/' .. suffix,
    version = version,
    name = name,
  }
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
    rp[previous], rp[next] = require('repmove').make(previous, next, comma, semicolon)
  end
  return { rp[previous], rp[next] }
end

function M.treesitter_available(name)
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  if lang == nil then return false end
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
  selection_mode = vim.api.nvim_replace_termcodes(selection_mode, true, true, true)
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

local original_cmdheight = nil
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

  vim.wo[term_win].cursorcolumn = false
  vim.wo[term_win].signcolumn = 'no'
  vim.wo[term_win].winhl = 'NormalFloat:Normal'

  if vim.bo[term_buf].buftype ~= 'terminal' then
    vim.cmd('terminal ' .. cmd)
    vim.bo[term_buf].filetype = 'terminal'
    vim.bo[term_buf].buflisted = false
    vim.bo[term_buf].swapfile = false
    vim.bo[term_buf].bufhidden = 'hide'
  end
  original_cmdheight = vim.o.cmdheight
  vim.o.cmdheight = 0
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = term_buf,
    once = true,
    callback = function()
      if original_cmdheight ~= nil then
        vim.o.cmdheight = original_cmdheight
        original_cmdheight = nil
      end
    end,
  })
  vim.cmd('startinsert')
  vim.cmd('nohlsearch')
  return term_buf, term_win
end

function M.in_macro_executing() return vim.fn.reg_executing() ~= '' end

function M.lazy_path() return vim.fn.stdpath('data') .. '/site/pack/core/opt' end

return M
