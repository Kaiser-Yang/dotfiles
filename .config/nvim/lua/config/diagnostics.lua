local sev = vim.diagnostic.severity
vim.diagnostic.config({
  virtual_lines = { current_line = true },
  severity_sort = true,
  signs = {
    text = {
      [sev.ERROR] = 'E',
      [sev.WARN] = 'W',
      [sev.INFO] = 'I',
      [sev.HINT] = 'H',
    },
  },
})
