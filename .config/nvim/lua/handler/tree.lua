local M = {}

local function do_operation(opts)
  if not _G.loaded['nvim-tree.lua'] then return false end
  local mode = vim.api.nvim_get_mode().mode
  local api = require('nvim-tree.api')
  local utils = require('nvim-tree.utils')
  local function ensure_dir(dir)
    local res = vim.fn.system({ 'mkdir', '-p', dir })
    if vim.v.shell_error ~= 0 then
      vim.notify(res, vim.log.levels.ERROR, { title = opts.title })
      return false
    end
    return true
  end
  if mode == 'n' then
    local file_src = api.tree.get_node_under_cursor().absolute_path
    local input_opts = {
      prompt = opts.prompt_single,
      default = vim.fn.expand('%:p:h'),
      completion = 'file',
    }
    vim.ui.input(input_opts, function(file_out)
      if not file_out or file_out == '' or file_out == file_src then return end
      local dir = vim.fn.fnamemodify(file_out, ':h')
      if not ensure_dir(dir) then return end
      local cmd = vim.list_extend({}, { unpack(opts.cmd), file_src, file_out })
      local output = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify(
          string.format('Failed to %s %s: %s', opts.action_verb_lower, file_src, output),
          vim.log.levels.ERROR,
          { title = opts.title }
        )
      else
        vim.notify(
          string.format('%s %s to %s', opts.action_verb_past, file_src, file_out),
          vim.log.levels.INFO,
          { title = opts.title }
        )
      end
    end)
    return true
  elseif vim.tbl_contains({ 'v', 'V', '' }, mode) then
    local nodes = utils.get_visual_nodes()
    if not nodes or #nodes == 0 then return false end
    local input_opts = {
      prompt = opts.prompt_multi,
      default = vim.fn.expand('%:p:h'),
      completion = 'dir',
    }
    vim.ui.input(input_opts, function(target_dir)
      if not target_dir or target_dir == '' then return end
      if not ensure_dir(target_dir) then return end
      local success_count = 0
      local failed_files = {}
      for _, node in ipairs(nodes) do
        local src = node.absolute_path
        local basename = vim.fn.fnamemodify(src, ':t')
        local dest = vim.fn.resolve(target_dir .. '/' .. basename)
        local cmd = vim.list_extend({}, { unpack(opts.cmd), src, dest })
        local output = vim.fn.system(cmd)
        if vim.v.shell_error ~= 0 then
          table.insert(failed_files, { src = src, error = output })
        else
          success_count = success_count + 1
        end
      end
      if success_count == #nodes then
        vim.notify(
          string.format('%s %d items to %s', opts.action_verb_past, success_count, target_dir),
          vim.log.levels.INFO,
          { title = opts.title }
        )
      else
        local fail_summary = table.concat(
          vim.tbl_map(function(f) return string.format('  %s: %s', f.src, f.error) end, failed_files),
          '\n'
        )
        vim.notify(
          string.format(
            'Completed: %d succeeded, %d failed.\nFailed details:\n%s',
            success_count,
            #failed_files,
            fail_summary
          ),
          vim.log.levels.ERROR,
          { title = opts.title }
        )
      end
    end)
    return true
  end
  return false
end

M.copy = function()
  return do_operation({
    cmd = { 'cp', '-R' },
    title = 'Light Boat',
    action_verb_past = 'Copied',
    action_verb_lower = 'copy',
    prompt_single = 'Copy to',
    prompt_multi = 'Copy to directory:',
  })
end

M.move = function()
  return do_operation({
    cmd = { 'mv' },
    title = 'NvimTree',
    action_verb_past = 'Moved',
    action_verb_lower = 'move',
    prompt_single = 'Move to',
    prompt_multi = 'Move to directory:',
  })
end

M.collapse_or_go_to_parent = function()
  if not _G.loaded['nvim-tree.lua'] then return false end
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()
  if node == nil or node.parent == nil then return false end
  if node.nodes ~= nil and node.open then
    api.node.open.edit(node)
  else
    api.node.navigate.parent()
  end
end

M.copy_node_information = function()
  if not _G.loaded['nvim-tree.lua'] then return false end
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()
  if node == nil then return false end
  local filepath = node.absolute_path
  local filename = node.name
  local modify = vim.fn.fnamemodify
  local results = {
    { key = 'PATH (CWD)', value = modify(filepath, ':.') },
    { key = 'FILENAME', value = filename },
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

M.cd_or_open = function(node)
  if not _G.loaded['nvim-tree.lua'] then return false end
  local api = require('nvim-tree.api')
  node = node or api.tree.get_node_under_cursor()
  if node == nil then return false end
  local dir = node.absolute_path
  if vim.fn.isdirectory(dir) == 1 then
    if dir == vim.fn.getcwd() then dir = dir .. '/..' end
    vim.api.nvim_set_current_dir(dir)
    api.tree.change_root(dir)
  else
    api.node.open.edit(node)
  end
end

M.cd_parent_directory = function(node)
  if not _G.loaded['nvim-tree.lua'] then return false end
  local api = require('nvim-tree.api')
  node = node or api.tree.get_node_under_cursor()
  if node == nil then return false end
  local new_cwd = vim.fn.fnamemodify(node.absolute_path, ':h') .. '/..'
  if vim.fn.isdirectory(new_cwd) == 0 then return false end
  vim.api.nvim_set_current_dir(new_cwd)
  api.tree.change_root(new_cwd)
end

M.open_focus_reveal = function()
  if not _G.loaded['nvim-tree.lua'] then return false end
  local tree = require('nvim-tree.api').tree
  if not tree.is_visible() then
    tree.open()
  elseif vim.bo.filetype ~= 'NvimTree' then
    tree.focus()
  else
    local file = _G.last_filename
    if file and file ~= '' and vim.fn.filereadable(file) == 1 then
      local dir = vim.fs.root(file, { '.git' })
      if dir then vim.cmd.cd(dir) end
      tree.find_file({ buf = file, update_root = true })
    end
  end
end

M.open_folder_or_preview = function()
  local api = require('nvim-tree.api')
  local node = api.tree.get_node_under_cursor()
  if node == nil then return false end
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

return M
