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
    return string.format("space:%d", sw)
  else
    return string.format("tab:%d", sw)
  end
end

require('lualine').setup({
  options = {
    globalstatus = true,
    always_divide_middle = true,
  },
  sections = {
    lualine_c = { 'filename', 'filesize', indent, recording },
    lualine_x = { 'searchcount', 'lsp_status', 'encoding', 'fileformat', 'filetype' },
  },
})
