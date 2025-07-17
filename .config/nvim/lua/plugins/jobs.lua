return {
    'stevearc/overseer.nvim',
    cmd = {
        'OverseerOpen',
        'OverseerClose',
        'OverseerToggle',
        'OverseerSaveBundle',
        'OverseerLoadBundle',
        'OverseerDeleteBundle',
        'OverseerRunCmd',
        'OverseerRun',
        'OverseerInfo',
        'OverseerBuild',
        'OverseerQuickAction',
        'OverseerTaskAction',
        'OverseerClearCache',
    },
    config = function(_, opts)
        local overseer = require('overseer')
        overseer.setup(opts)
        local lua_line_config = require('lualine.config').get_config()
        table.insert(lua_line_config.sections.lualine_x, 1, {
            'overseer',
            label = '', -- Prefix for task counts
            colored = true, -- Color the task icons and counts
            unique = false, -- Unique-ify non-running task count by name
            name = nil, -- List of task names to search for
            name_not = false, -- When true, invert the name search
            status = nil, -- List of task statuses to display
            status_not = false, -- When true, invert the status search
            fmt = require('utils').disable_in_ft('dap'),
            symbols = {
                [overseer.STATUS.FAILURE] = 'F:',
                [overseer.STATUS.CANCELED] = 'C:',
                [overseer.STATUS.SUCCESS] = 'S:',
                [overseer.STATUS.RUNNING] = 'R:',
            },
        })
        require('lualine').setup(lua_line_config)
        vim.api.nvim_create_user_command('OverseerRestartLast', function()
            local tasks = overseer.list_tasks({ recent_first = true })
            if vim.tbl_isempty(tasks) then
                vim.notify('No tasks found', vim.log.levels.WARN)
            else
                overseer.run_action(tasks[1], 'restart')
            end
        end, {})
    end,
}
