local function load_list_to_arglist(is_quickfix)
  local list = is_quickfix and vim.fn.getqflist() or vim.fn.getloclist(0)

  local function filename_from_item(item)
    if item.bufnr and item.bufnr > 0 then
      local name = vim.fn.bufname(item.bufnr)
      if name ~= '' then return name end
    end
    return item.filename or item.file or item.name or ''
  end

  local filenames = {}
  for _, item in ipairs(list) do
    local name = filename_from_item(item)
    if name and name ~= '' then table.insert(filenames, vim.fn.fnameescape(name)) end
  end

  local cmd_type = is_quickfix and 'Quickfix' or 'Location'
  if #filenames == 0 then
    vim.notify(cmd_type .. ' list is empty', vim.log.levels.WARN, { title = 'LightBoat' })
    return
  end

  vim.cmd('args ' .. table.concat(filenames, ' '))
  vim.notify('Successfully loaded ' .. cmd_type .. ' list into arglist', vim.log.levels.INFO, { title = 'LightBoat' })
end
local command = {
  Qargs = {
    callback = function() load_list_to_arglist(true) end,
    opt = { nargs = 0, bar = true },
  },
  Largs = {
    callback = function() load_list_to_arglist(false) end,
    opt = { nargs = 0, bar = true },
  },
  DetectConflictAndLoad = {
    callback = function()
      local conflicts = {}
      local function extend(bufnr, new_conflicts)
        for _, conflict in ipairs(new_conflicts) do
          conflict.bufnr = bufnr
          table.insert(conflicts, conflict)
        end
      end
      local r = require('resolve')
      vim.system(
        { 'git', 'diff', '--name-only', '--diff-filter=U' },
        { text = true, cwd = vim.fn.getcwd() },
        function(result)
          if result.code ~= 0 then
            vim.schedule_wrap(vim.notify)('Error running git command: ' .. result.stderr, vim.log.levels.ERROR, { title = 'Light Boat' })
            return
          end
          local files = vim.split(result.stdout, '\n', { trimempty = true })
          vim.schedule(function()
            for _, file in ipairs(files) do
              file = vim.fn.fnamemodify(file, ':p')
              local bufnr = vim.fn.bufadd(file)
              vim.bo[bufnr].buflisted = true
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.api.nvim_create_autocmd('BufReadPost', {
                  buffer = bufnr,
                  once = true,
                  callback = function()
                    if vim.api.nvim_buf_is_valid(bufnr) then extend(bufnr, r.detect_conflicts(bufnr, true)) end
                  end,
                })
                vim.fn.bufload(bufnr)
              else
                extend(bufnr, r.detect_conflicts(bufnr, true))
              end
            end
            local qf_list = {}
            vim.notify(
              string.format(
                'Detected %d conflict(s) in current repository, they have been added to quickfix list.',
                #conflicts
              ),
              vim.log.levels.INFO,
              { title = 'Resolve' }
            )
            for i, conflict in ipairs(conflicts) do
              table.insert(qf_list, {
                bufnr = conflict.bufnr,
                filename = vim.api.nvim_buf_get_name(conflict.bufnr),
                lnum = conflict.start,
                text = string.format('Conflict %d/%d', i, #conflicts),
              })
            end
            vim.fn.setqflist(qf_list)
          end)
        end
      )
    end,
    opt = { nargs = 0, bar = true },
  },
}
for name, c in pairs(command) do
  vim.api.nvim_create_user_command(name, c.callback, c.opt)
end
