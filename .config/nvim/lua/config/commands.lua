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
              vim.notify('Only one of loclist/qflist can be specified.', vim.log.levels.ERROR, { title = 'Resolve' })
              return
            end
            list_type = p
          elseif p == 'open' or p == 'close' then
            if should_open ~= nil then
              vim.notify('Only one of open/close can be specified.', vim.log.levels.ERROR, { title = 'Resolve' })
              return
            end
            should_open = (p == 'open')
          else
            vim.notify('Invalid argument: ' .. p, vim.log.levels.ERROR, { title = 'Resolve' })
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
          function(result)
            if result.code ~= 0 then
              vim.schedule_wrap(vim.notify)(
                'Error running git command: ' .. result.stderr,
                vim.log.levels.ERROR,
                { title = 'Light Boat' }
              )
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
              if #conflicts == 0 then
                vim.notify('No conflicts detected in current repository.', vim.log.levels.INFO, { title = 'Resolve' })
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
              if list_type == 'qflist' then
                vim.fn.setqflist({}, 'r', {
                  title = 'Resolve Conflicts',
                  items = items,
                })
                if should_open then vim.cmd('copen') end
              else
                vim.fn.setloclist(vim.api.nvim_get_current_win(), {}, 'r', {
                  title = 'Resolve Conflicts',
                  items = items,
                })
                if should_open then vim.cmd('lopen') end
              end
              vim.notify(
                string.format(
                  'Detected %d conflict(s) in current repository, they have been added to %s.',
                  #conflicts,
                  list_type
                ),
                vim.log.levels.INFO,
                { title = 'Resolve' }
              )
            end)
          end
        )
      end,
      opt = {
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
      opt = {
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
  }
  for name, c in pairs(command) do
    vim.api.nvim_create_user_command(name, c.callback, c.opt)
  end
end)
