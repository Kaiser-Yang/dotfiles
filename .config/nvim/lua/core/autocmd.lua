if vim.g.vscode then return end

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    local file_path = vim.fn.expand('%:p')
    local ext = vim.fn.expand('%:e')
    if (ext == 'yaml' or ext == 'yml') and file_path:match('rime') then vim.bo.expandtab = false end
  end,
})
