local u = require('utils')
vim.pack.add({
  u.gh('nvim-tree/nvim-web-devicons'),
  u.gh('nvim-lualine/lualine.nvim'),
}, { confirm = false })

local function recording()
  local reg = vim.fn.reg_recording()
  if reg == '' then return '' end
  return 'REC @' .. reg
end

require('lualine').setup({
  options = {
    globalstatus = true,
    always_divide_middle = true,
  },
  sections = {
    lualine_c = { 'filename', 'filesize', recording },
    lualine_x = { 'searchcount', 'lsp_status', 'encoding', 'fileformat', 'filetype' },
  },
})
