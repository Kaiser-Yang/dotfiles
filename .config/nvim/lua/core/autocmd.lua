vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.bo.filetype:match('^dap%-repl') then vim.cmd('stopinsert') end
  end,
})
