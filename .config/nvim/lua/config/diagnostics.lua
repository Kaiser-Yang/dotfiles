vim.schedule(function()
  local sev = vim.diagnostic.severity
  vim.diagnostic.config({
    virtual_lines = { current_line = true },
    severity_sort = true,
    signs = {
      text = {
        [sev.ERROR] = '',
        [sev.WARN] = '',
        [sev.INFO] = '',
        [sev.HINT] = '',
      },
    },
  })
end)
