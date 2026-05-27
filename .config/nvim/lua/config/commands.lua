vim.schedule(function()
  local u = require('utils')
  local command = {
    DetectConflictAndLoad = {
      callback = function(args)
        local params = vim.split(args.args or '', '%s+', { trimempty = true })
        local list_type = nil
        local should_open = nil

        for _, p in ipairs(params) do
          if p == 'loclist' or p == 'qflist' then
            if list_type ~= nil then
              vim.notify('Only one of loclist/qflist can be specified.', vim.log.levels.ERROR, { title = 'Light Boat' })
              return
            end
            list_type = p
          elseif p == 'open' or p == 'close' then
            if should_open ~= nil then
              vim.notify('Only one of open/close can be specified.', vim.log.levels.ERROR, { title = 'Light Boat' })
              return
            end
            should_open = (p == 'open')
          else
            vim.notify('Invalid argument: ' .. p, vim.log.levels.ERROR, { title = 'Light Boat' })
            return
          end
        end

        if list_type == nil then list_type = 'loclist' end
        if should_open == nil then should_open = true end

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
          vim.schedule_wrap(function(result)
            if result.code ~= 0 then
              vim.notify('Error running git command: ' .. result.stderr, vim.log.levels.ERROR, { title = 'Light Boat' })
              return
            end
            local files = vim.split(result.stdout, '\n', { trimempty = true })
            for _, file in ipairs(files) do
              file = vim.fn.fnamemodify(file, ':p')
              local bufnr = vim.fn.bufadd(file)
              if not vim.api.nvim_buf_is_loaded(bufnr) then
                vim.api.nvim_create_autocmd('BufReadPost', {
                  once = true,
                  buffer = bufnr,
                  callback = function()
                    if vim.api.nvim_buf_is_valid(bufnr) then extend(bufnr, r.detect_conflicts(bufnr, true)) end
                  end,
                })
                vim.fn.bufload(bufnr)
              else
                extend(bufnr, r.detect_conflicts(bufnr, true))
              end
            end
            if #conflicts == 0 then
              vim.notify('No conflicts detected in current repository.', vim.log.levels.INFO, { title = 'Light Boat' })
              return
            end
            local items = {}
            for i, conflict in ipairs(conflicts) do
              table.insert(items, {
                bufnr = conflict.bufnr,
                filename = vim.api.nvim_buf_get_name(conflict.bufnr),
                lnum = conflict.start,
                text = string.format('Conflict %d/%d', i, #conflicts),
              })
            end
            local open_cmd = nil
            if list_type == 'qflist' then
              vim.fn.setqflist({}, 'r', {
                title = 'Git Conflicts',
                items = items,
              })
              open_cmd = 'copen'
            else
              vim.fn.setloclist(vim.api.nvim_get_current_win(), {}, 'r', {
                title = 'Git Conflicts',
                items = items,
              })
              open_cmd = 'lopen'
            end
            if should_open then vim.cmd(open_cmd) end
            vim.notify(
              string.format(
                'Detected %d conflict(s) in current repository, they have been added to %s.',
                #conflicts,
                list_type
              ),
              vim.log.levels.INFO,
              { title = 'Light Boat' }
            )
          end)
        )
      end,
      opts = {
        nargs = '*',
        bar = true,
        complete = function(ArgLead, CmdLine, CursorPos)
          local all_items = { 'loclist', 'qflist', 'open', 'close' }
          local used = {}
          for _, token in ipairs(vim.split(CmdLine:sub(1, CursorPos), '%s+', { trimempty = true })) do
            used[token] = true
          end

          local has_list = used.loclist or used.qflist
          local has_open = used.open or used.close

          local candidates = {}
          for _, item in ipairs(all_items) do
            if item:find('^' .. vim.pesc(ArgLead)) then
              if item == 'loclist' or item == 'qflist' then
                if not has_list and not used[item] then table.insert(candidates, item) end
              elseif item == 'open' or item == 'close' then
                if not has_open and not used[item] then table.insert(candidates, item) end
              end
            end
          end

          return candidates
        end,
      },
    },
    BuildPlugin = {
      callback = function(args)
        local list = nil
        if args.args ~= '' then
          list = vim.split(args.args, '%s+', { trimempty = true })
          if #list == 0 then list = nil end
        end
        u.build_plugin(list)
      end,
      opts = {
        nargs = '?',
        bar = true,
        complete = function(_, CmdLine, CursorPos)
          local items = {
            'telescope-fzf-native.nvim',
            'nvim-treesitter',
            'blink.cmp',
          }
          local used = {}
          for _, token in ipairs(vim.split(CmdLine:sub(1, CursorPos), '%s+', { trimempty = true })) do
            used[token] = true
          end
          return vim.tbl_filter(function(item) return not used[item] end, items)
        end,
      },
    },
    PackUpdate = {
      callback = function(args)
        local plugins = {}
        if args.args and args.args ~= '' then
          plugins = vim.split(args.args, '%s+', { trimempty = true })
          for _, p in ipairs(plugins) do
            if not _G.loaded[p] then
              vim.notify('Unknown plugin: ' .. p, vim.log.levels.ERROR, { title = 'PackUpdate' })
              return
            end
          end
        else
          plugins = nil
        end
        local opts = args.bang and { force = true } or {}
        vim.pack.update(plugins, opts)
      end,
      opts = {
        nargs = '*',
        bang = true,
        bar = true,
        complete = function(_, CmdLine)
          local all_plugins = vim.tbl_keys(_G.loaded)
          local used = {}
          local after_cmd = CmdLine:gsub('^%S+%s*', '')
          for _, token in ipairs(vim.split(after_cmd, '%s+', { trimempty = true })) do
            used[token] = true
          end
          local candidates = {}
          for _, plugin in ipairs(all_plugins) do
            if not used[plugin] then table.insert(candidates, plugin) end
          end
          return candidates
        end,
      },
    },
  }
  for name, c in pairs(command) do
    vim.api.nvim_create_user_command(name, c.callback, c.opts)
  end
end)
