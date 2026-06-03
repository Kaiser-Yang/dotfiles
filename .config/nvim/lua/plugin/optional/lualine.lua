local u = require('utils')
u.gh('nvim-tree/nvim-web-devicons')
u.gh('nvim-lualine/lualine.nvim')

local function recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then return '' end
  return 'REC @' .. reg
end

local function indent()
  local expandtab = vim.bo.expandtab
  local sw = vim.bo.shiftwidth
  if expandtab then
    return string.format('space:%d', sw)
  else
    return string.format('tab:%d', sw)
  end
end

local function search_count()
  local last_search = vim.fn.getreg('/')
  if vim.v.hlsearch == 0 then return last_search end
  local limit, timeout = 999, 50
  local ok, result = pcall(vim.fn.searchcount, { maxcount = limit + 1, timeout = timeout })
  if not ok or next(result) == nil then return '' end
  if result.current > limit then result.current = '??' end
  if result.total > limit then result.total = '>' .. limit end
  return last_search .. '[' .. result.current .. '/' .. result.total .. ']'
end

vim.o.laststatus = 2
require('lualine').setup({
  options = {
    globalstatus = true,
    always_divide_middle = true,
    refresh = {
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
        'RecordingEnter',
        'RecordingLeave',
      },
    },
  },
  sections = {
    lualine_c = { 'filename', 'filesize', indent, recording },
    lualine_x = {
      { '%-10.S', separator = { left = '', right = '' } },
      search_count,
      'selectioncount',
      'lsp_status',
      'encoding',
      'fileformat',
      'filetype',
    },
  },
})
