-- WARN:
-- With those keys below,
-- we can not use something like "grn" to enter visual replace mode and change a character to "n"
-- gr not work
local lsp_m = {
  -- By default, "tagfunc" is set whne "LspAttach",
  -- "<C-]>", "<C-W>]", and "<C-W>}" will work, you can use them to go to definition
  { 'n', 'K', vim.lsp.buf.hover, { desc = 'Hover' } },
  { 'n', 'grn', vim.lsp.buf.rename, { desc = 'Rename Symbol' } },
  { 'n', 'gra', vim.lsp.buf.code_action, { desc = 'Code Action' } },
  { 'n', 'grr', '<cmd>Telescope lsp_references<cr>', { desc = 'References' } },
  { 'n', 'gri', '<cmd>Telescope lsp_implementations<cr>', { desc = 'Go to Implementation' } },
  { 'n', 'grI', '<cmd>Telescope lsp_incoming_calls<cr>', { desc = 'Incoming Call' } },
  { 'n', 'grO', '<cmd>Telescope lsp_outgoing_calls<cr>', { desc = 'Outgoint Call' } },
  { 'n', 'grt', '<cmd>Telescope lsp_type_definitions<cr>', { desc = 'Go to Type Definition' } },
  { 'n', 'gO', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'Document Symbol' } },
}
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    for _, m in ipairs(lsp_m) do
      m[4].buffer = ev.buf
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.keymap.set(unpack(m))
    end
  end,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  callback = function() vim.wo.wrap = true end,
})
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if
        vim.api.nvim_buf_is_valid(bufnr)
        and vim.api.nvim_buf_is_loaded(bufnr)
        and vim.api.nvim_buf_get_name(bufnr) ~= ''
        and vim.bo[bufnr].modified
        and vim.bo[bufnr].buftype == ''
        and vim.bo[bufnr].modifiable
        and not vim.bo[bufnr].readonly
      then
        vim.api.nvim_buf_call(bufnr, function() vim.cmd('update') end)
      end
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufEnter', 'QuitPre' }, {
  nested = false,
  callback = function(ev)
    if not _G.plugin_loaded['nvim-tree.lua'] then return end
    local tree = require('nvim-tree.api').tree
    if not tree.is_visible() then return end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    local lastWinId
    for _, winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        local buf = vim.api.nvim_win_get_buf(winId)
        if vim.bo[buf].filetype ~= 'NvimTree' then
          lastWinId = winId
          winCount = winCount + 1
        end
      end
    end

    -- We want to quit and only one window besides tree is left
    if ev.event == 'QuitPre' and winCount == 1 and lastWinId == vim.api.nvim_get_current_win() then
      vim.api.nvim_cmd({ cmd = 'qall' }, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if ev.event == 'BufEnter' and winCount == 0 then
      vim.schedule(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle({ find_file = true, focus = true })
        -- re-open nivm-tree
        tree.toggle({ find_file = true, focus = false })
      end)
    end
  end,
})
