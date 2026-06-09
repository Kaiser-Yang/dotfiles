local u = require('utils')
local M = {}

function M.toggle_inlay_hint()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then return false end
  for _, client in ipairs(clients) do
    if client and client:supports_method('textDocument/inlayHint', bufnr) then
      local status = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) == false
      vim.lsp.inlay_hint.enable(status)
      u.toggle_notify('Inlay Hint', status, { title = 'LSP' })
      return true
    end
  end
  return false
end

function M.toggle_codelens()
  local status = not vim.lsp.codelens.is_enabled()
  vim.lsp.codelens.enable(status)
  u.toggle_notify('Code Lens', status, { title = 'LSP' })
end

function M.references()
  if _G.loaded['telescope.nvim'] then
    require('telescope.builtin').lsp_references()
  else
    vim.lsp.buf.references()
  end
  return true
end

function M.refactor()
  if not _G.loaded['refactoring.nvim'] then return false end
  require('refactoring').select_refactor()
  return true
end

function M.implementation()
  if _G.loaded['telescope.nvim'] then
    require('telescope.builtin').lsp_implementations()
  else
    vim.lsp.buf.implementation()
  end
  return true
end

function M.incoming_calls()
  if _G.loaded['telescope.nvim'] then
    require('telescope.builtin').lsp_incoming_calls()
  else
    vim.lsp.buf.incoming_calls()
  end
  return true
end

function M.outgoing_calls()
  if _G.loaded['telescope.nvim'] then
    require('telescope.builtin').lsp_outgoing_calls()
  else
    vim.lsp.buf.outgoing_calls()
  end
  return true
end

function M.type_definition()
  if _G.loaded['telescope.nvim'] then
    require('telescope.builtin').lsp_type_definitions()
  else
    vim.lsp.buf.type_definition()
  end
  return true
end

function M.document_symbol()
  if _G.loaded['telescope.nvim'] then
    require('telescope.builtin').lsp_document_symbols()
  else
    vim.lsp.buf.document_symbol()
  end
  return true
end

function M.dynamic_workspace_symbols()
  if _G.loaded['telescope.nvim'] then
    require('telescope.builtin').lsp_dynamic_workspace_symbols()
    return true
  else
    return false
  end
end

M.hover = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then return false end
  for _, client in ipairs(clients) do
    if client and client:supports_method('textDocument/hover', bufnr) then
      vim.lsp.buf.hover()
      return true
    end
  end
  return false
end

M.rename = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method('textDocument/rename', bufnr) then
      vim.lsp.buf.rename()
      return true
    end
  end
  return false
end

M.code_action = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method('textDocument/codeAction', bufnr) then
      vim.lsp.buf.code_action()
      return true
    end
  end
  return false
end

M.declaration = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method('textDocument/declaration', bufnr) then
      vim.lsp.buf.declaration()
      return true
    end
  end
  return false
end

M.codelens_run = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client:supports_method('textDocument/codeLens', bufnr) then
      vim.lsp.codelens.run()
      return true
    end
  end
  return false
end

return M
