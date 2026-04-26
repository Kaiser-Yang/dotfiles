local u = require('utils')
local h = require('handler')

vim.api.nvim_create_autocmd({ 'BufReadPre', 'FileType', 'BufReadPost' }, {
  callback = function(ev)
    local old_status = vim.b.big_file_status or false
    vim.b.big_file_status = u.buffer.big(ev.buf, ev.event)
    local new_status = vim.b.big_file_status
    local buffer = ev.buf
    if new_status and vim.bo.filetype ~= '' and not vim.bo.filetype:find('bigfile') then
      vim.cmd('noautocmd setlocal filetype=' .. vim.bo.filetype .. 'bigfile')
    end
    if new_status == old_status then return end
    if new_status then
      vim.b.blink_pairs = false
      vim.b.conform_on_save = false
      vim.b.treesitter_foldexpr_auto_set = false
      vim.b.treesitter_highlight_auto_start = false
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buffer then
          vim.wo[win][0].foldmethod = 'manual'
          vim.wo[win][0].foldexpr = '0'
        end
      end
      for _, client in pairs(vim.lsp.get_clients({ bufnr = buffer })) do
        vim.lsp.buf_detach_client(buffer, client.id)
      end
      if vim.treesitter.highlighter.active[buffer] ~= nil then vim.treesitter.stop(buffer) end
      require('nvim-treesitter.endwise').detach(buffer)
      -- Using enable here will automatically disable context for big files
      require('treesitter-context').enable()
    else
      vim.b.blink_pairs = nil
      vim.b.conform_on_save = nil
      vim.b.treesitter_foldexpr_auto_set = nil
      vim.b.treesitter_highlight_auto_start = nil
      -- Trigger the FileType autocommand to let LSP, indentexpr, endwise and foldexpr set up
      if vim.bo.filetype ~= '' then vim.bo.filetype = vim.bo.filetype:gsub('bigfile', '') end
      require('treesitter-context').enable()
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('ModeChanged', {
  callback = function()
    if u.in_macro_executing() then return end
    if vim.tbl_contains({ 'i', 'ic', 'ix', 'R', 'Rc', 'Rx', 'Rv', 'Rvc', 'Rvx' }, vim.api.nvim_get_mode().mode) then
      -- We must schedule here
      vim.schedule(function() vim.cmd('nohlsearch') end)
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('TextYankPost', {
  callback = function()
    local limit = vim.b.highlight_on_yank_limit or vim.g.highlight_on_yank_limit
    local timeout = vim.b.highlight_on_yank_duration or vim.g.highlight_on_yank_duration
    assert(vim.v.event.regcontents)
    local size = 0
    local should_hl = nil
    ---@diagnostic disable-next-line: param-type-mismatch
    for _, line in ipairs(vim.v.event.regcontents) do
      size = size + #line
      if type(limit) ~= 'number' and size > 0 then
        should_hl = true
        break
      elseif type(limit) == 'number' and size > limit then
        should_hl = false
        break
      end
    end
    if should_hl == nil then should_hl = size > 0 end
    if should_hl then vim.hl.on_yank({ timeout = timeout }) end
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    if u.treesitter_available('highlights') and u.enabled('treesitter_highlight_auto_start') then
      vim.treesitter.start()
    end
    if u.treesitter_available('folds') and u.enabled('treesitter_foldexpr_auto_set') then
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('LspAttach', {
  callback = function(ev)
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
      { 'n', 'grx', vim.lsp.codelens.run(), { desc = 'Codelens' } },
      { 'n', 'grr', '<cmd>Telescope lsp_references<cr>', { desc = 'References' } },
      { 'n', 'grI', '<cmd>Telescope lsp_implementations<cr>', { desc = 'Go to Implementation' } },
      { 'n', 'gri', '<cmd>Telescope lsp_incoming_calls<cr>', { desc = 'Incoming Call' } },
      { 'n', 'gro', '<cmd>Telescope lsp_outgoing_calls<cr>', { desc = 'Outgoint Call' } },
      { 'n', 'grt', '<cmd>Telescope lsp_type_definitions<cr>', { desc = 'Go to Type Definition' } },
      { 'n', 'gO', '<cmd>Telescope lsp_document_symbols<cr>', { desc = 'Document Symbol' } },
    }
    for _, m in ipairs(lsp_m) do
      m[4].buffer = ev.buf
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.keymap.set(unpack(m))
    end
  end,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)({ 'FocusLost', 'BufLeave' }, {
  callback = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
      if u.buffer.normal(bufnr) and vim.bo[bufnr].modified then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd('update')
          if u.enabled('conform_on_save') then h.async_format() end
        end)
      end
    end
  end,
})

local unnamed_reg_content
local unnamed_reg_type
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    unnamed_reg_content = vim.fn.getreg('"')
    unnamed_reg_type = vim.fn.getregtype('"')
  end,
  once = true,
})

vim.schedule_wrap(vim.api.nvim_create_autocmd)('TextYankPost', {
  callback = function()
    if vim.v.event.regname ~= '' and vim.v.event.regname ~= '"' then
      vim.fn.setreg('"', unnamed_reg_content, unnamed_reg_type)
    else
      unnamed_reg_content = vim.fn.getreg('"')
      unnamed_reg_type = vim.fn.getregtype('"')
    end
  end,
})
