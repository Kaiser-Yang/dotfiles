M = {}

M.coc_dap_initialised = false
M.coc_dap_timer = nil
function M.coc_dap_initialise()
  if M.coc_dap_initialised or vim.g.coc_service_initialized ~= 1 then
    return
  end

  require('coc-lsp-adapter').setup()
  local clients = vim.lsp.get_active_clients()
  if vim.tbl_count(clients) == 0 then
    return
  end

  for _, client in pairs(clients) do
    if client.name == 'java' then
      require('jdtls').setup_dap({ hotcodereplace = 'auto' })
      require('jdtls.dap').setup_dap_main_class_configs()
      vim.notify('Done setting up nvim-dap and coc-java')
    end
  end

  M.coc_dap_initialised = true
  vim.fn.timer_stop(M.coc_dap_timer)
end

M.coc_dap_timer = vim.fn.timer_start(1000, M.coc_dap_initialise, {
  ['repeat'] = -1,
})

return M
