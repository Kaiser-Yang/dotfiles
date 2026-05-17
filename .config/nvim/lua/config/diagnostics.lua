vim.schedule(function()
  local sev = vim.diagnostic.severity
  vim.diagnostic.config({
    jump = {
      on_jump = function(diagnostic, bufnr)
        if not diagnostic then return end
        vim.diagnostic.open_float({ bufnr = bufnr, scope = 'cursor', focus = false })
      end,
    },
    virtual_lines = { severity = { min = sev.WARN }, current_line = true },
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
