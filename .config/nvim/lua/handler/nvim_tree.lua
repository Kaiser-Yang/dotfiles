local u = require('utils')
local M = {}
local get_visual_nodes = function()
  local explorer = require('nvim-tree.core').get_explorer()
  if not explorer then return nil end
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local nodes = explorer:get_nodes_in_range(start_line, end_line)
  nodes = explorer.marks:filter_descendant_nodes(nodes)
  u.key.feedkeys('<esc>', 'n')
  return nodes
end
M.copy_to = function()
  local mode = vim.api.nvim_get_mode().mode
  local api = require('nvim-tree.api')
  if mode == 'n' then
    local file_src = api.tree.get_node_under_cursor().absolute_path
    local input_opts = { prompt = 'Copy to', default = file_src, completion = 'file' }

    vim.ui.input(input_opts, function(file_out)
      if not file_out or file_out == '' or file_out == file_src then return end
      local dir = vim.fn.fnamemodify(file_out, ':h')

      local res = vim.fn.system({ 'mkdir', '-p', dir })
      if vim.v.shell_error ~= 0 then
        vim.notify(res, vim.log.levels.ERROR, { title = 'Light Boat' })
        return
      end

      vim.fn.system({ 'cp', '-R', file_src, file_out })
    end)
  end
  if not vim.tbl_contains({ 'v', 'V', '' }, mode) then return false end
end
M.rename_full = function()
  local mode = vim.api.nvim_get_mode().mode
  local api = require('nvim-tree.api')
  if mode == 'n' then
    local file_src = api.tree.get_node_under_cursor()['absolute_path']
    local input_opts = { prompt = 'Rename', default = file_src, completion = 'file' }

    vim.ui.input(input_opts, function(file_out)
      if not file_out or file_out == '' or file_out == file_src then return end
      local dir = vim.fn.fnamemodify(file_out, ':h')

      local res = vim.fn.system({ 'mkdir', '-p', dir })
      if vim.v.shell_error ~= 0 then
        vim.notify(res, vim.log.levels.ERROR, { title = 'NvimTree' })
        return
      end

      vim.fn.system({ 'mv', file_src, file_out })
    end)
  end
  if not vim.tbl_contains({ 'v', 'V', '' }, mode) then return false end
end
M.collapse_or_go_to_parent = function()
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()
  if node == nil or node.parent == nil then return false end
  if node.nodes ~= nil and node.open then
    api.node.open.edit(node)
  else
    api.node.navigate.parent()
  end
end

M.open_folder_or_preview = function()
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()
  if node == nil or node.parent == nil then return false end
  if node.nodes ~= nil then
    if node.open then
      return false
    else
      api.node.open.edit()
    end
  else
    api.node.open.preview()
  end
end

M.copy_node_information = function()
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()
  if node == nil then return false end
  local filepath = node.absolute_path
  local filename = node.name
  local modify = vim.fn.fnamemodify
  local results = {
    { key = 'FILENAME', value = filename },
    { key = 'PATH (CWD)', value = modify(filepath, ':.') },
    { key = 'PATH', value = filepath },
    { key = 'URI', value = vim.uri_from_fname(filepath) },
    { key = 'BASENAME', value = modify(filename, ':r') },
    { key = 'EXTENSION', value = modify(filename, ':e') },
    { key = 'PATH (HOME)', value = modify(filepath, ':~') },
  }
  local vals = {}
  local options = {}
  for i, item in ipairs(results) do
    options[i] = item.key
    vals[item.key] = item.value
  end
  vim.ui.select(options, {
    prompt = 'Copy node information',
    format_item = function(item) return ('%s: %s'):format(item, vals[item]) end,
  }, function(choice)
    if not choice or not vals[choice] then return end
    vim.fn.setreg('"', vals[choice])
    vim.fn.setreg('+', vals[choice])
    vim.notify(string.format('Copied "%s" to clipboard', vals[choice]), vim.log.levels.INFO, { title = 'Light Boat' })
  end)
end

M.change_root_to_node = function(node)
  local api = require('nvim-tree.api')
  node = node or api.tree.get_node_under_cursor()
  if node == nil or node.absolute_path == nil or vim.fn.isdirectory(node.absolute_path) == 0 then return false end
  vim.api.nvim_set_current_dir(node.absolute_path)
  api.tree.change_root(node.absolute_path)
end

M.change_root_to_parent = function(node)
  local api = require('nvim-tree.api')
  node = node or api.tree.get_node_under_cursor()
  if node == nil then return false end
  local new_cwd = vim.fn.fnamemodify(node.absolute_path, ':h') .. '/..'
  vim.notify(new_cwd, vim.log.levels.INFO, { title = 'Light Boat' })
  if vim.fn.isdirectory(new_cwd) == 0 then return false end
  vim.api.nvim_set_current_dir(new_cwd)
  api.tree.change_root(new_cwd)
end

local file
M.open_focus_reveal = function()
  local tree = require('nvim-tree.api').tree
  if not tree.is_visible() then
    if vim.bo.filetype ~= 'NvimTree' then file = vim.api.nvim_buf_get_name(0) end
    tree.open()
  elseif vim.bo.filetype ~= 'NvimTree' then
    if vim.bo.filetype ~= 'NvimTree' then file = vim.api.nvim_buf_get_name(0) end
    tree.focus()
  else
    if file and file ~= '' and vim.fn.filereadable(file) == 1 then
      local new_cwd = vim.fs.root(file, { '.git', '.nvim' })
      if new_cwd then vim.api.nvim_set_current_dir(new_cwd) end
      tree.find_file({ buf = file, update_root = true })
    end
  end
end

return M
