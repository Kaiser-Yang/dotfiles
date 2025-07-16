-- TODO:
-- completion for dap commands
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '⭕', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '🚫', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '📔', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = '', numhl = '' })
local dap_ui_visible = false
local need_restore_explorer = false
local utils = require('utils')
local function has_neo_tree() return utils.get_win_with_filetype('neo-tree') ~= nil end
local function dap_ui_toggle()
    dap_ui_visible = not dap_ui_visible
    require('dapui').toggle()
    if dap_ui_visible then
        if has_neo_tree() then
            need_restore_explorer = true
            require('neo-tree.command').execute({ action = 'close' })
        end
    elseif need_restore_explorer then
        need_restore_explorer = false
        require('neo-tree.command').execute({
            action = 'show',
            source = 'last',
        })
    end
end
local function debug_test_under_cursor()
    if vim.bo.filetype ~= 'java' then return end
    require('jdtls').test_nearest_method()
end
local function is_popup(winid)
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if not ok then return false end
    return config.relative ~= ''
end
vim.api.nvim_create_autocmd({ 'TabClosed', 'BufWinEnter' }, {
    group = 'UserDIY',
    pattern = '*',
    callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if not is_popup(win) and vim.bo[buf].filetype:match('^dap') then
                if vim.fn.winnr('$') ~= 1 then
                    vim.wo[win].statuscolumn = ' '
                else
                    vim.wo[win].statuscolumn = '%{v:lua.get_label()}'
                end
                vim.wo[win].cursorcolumn = false
                vim.wo[win].cursorline = false
            end
        end
    end,
})
local function toggle_debug_map(force)
    local keys = {
        {
            'n',
            '<c-c>',
            require('dap').terminate,
            { desc = 'Debug terminate', buffer = true },
        },
        {
            'n',
            'c',
            require('dap').continue,
            { desc = 'Debug continue', buffer = true },
        },
        {
            'n',
            'R',
            require('dap').restart,
            { desc = 'Debug restart', buffer = true },
        },
        {
            'n',
            'b',
            require('dap').step_back,
            { desc = 'Debug back', buffer = true },
        },
        {
            'n',
            'n',
            require('dap').step_over,
            { desc = 'Debug next', buffer = true },
        },
        {
            'n',
            's',
            require('dap').step_into,
            { desc = 'Debug step into', buffer = true },
        },
        {
            'n',
            'S',
            require('dap').step_out,
            { desc = 'Debug step out', buffer = true },
        },
    }
    if force then
        if vim.b.debug_map then return end
        utils.map_set_all(keys)
        vim.b.debug_map = true
        return
    end
    if vim.b.debug_map then
        for _, key in ipairs(keys) do
            vim.keymap.del(key[1], key[2], { buffer = true })
        end
        vim.b.debug_map = false
        vim.notify('Debug key mappings removed', vim.log.levels.INFO)
        return
    end
    utils.map_set_all(keys)
    vim.b.debug_map = true
    vim.notify('Debug key mappings added', vim.log.levels.INFO)
end
vim.api.nvim_create_autocmd('FileType', {
    group = 'UserDIY',
    pattern = 'dap*',
    callback = function() toggle_debug_map(true) end,
})
vim.api.nvim_create_user_command('ToggleDebugMap', function()
    if not vim.bo.filetype:match('^dap') then
        vim.notify(
            'Current filetype is '
                .. vim.bo.filetype
                .. '. '
                .. "You should run this in 'dap*' buffers",
            vim.log.levels.WARN
        )
        return
    end
    toggle_debug_map()
end, { desc = 'Toggle debug key mappings' })
local dap = {
    'mfussenegger/nvim-dap',
    config = function()
        local dap = require('dap')
        dap.listeners.before.attach.dapui_config = function()
            if not dap_ui_visible then dap_ui_toggle() end
        end
        dap.listeners.before.launch.dapui_config = function()
            if not dap_ui_visible then dap_ui_toggle() end
        end
        dap.adapters.gdb = {
            type = 'executable',
            command = 'gdb',
            args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
        }
        dap.adapters.codelldb = {
            type = 'executable',
            command = 'codelldb',
            detached = vim.fn.has('win32') == 0,
        }
        dap.configurations.c = {
            {
                name = 'Launch file',
                type = 'codelldb',
                request = 'launch',
                program = function()
                    local prompt = vim.g.path_to_executable and vim.g.path_to_executable
                        or 'not set'
                    local res = vim.fn.input(
                        'Path to executable [' .. prompt .. ']: ',
                        vim.fn.getcwd() .. '/',
                        'file'
                    )
                    if not res:match('^%s*$') then
                        local fs_stat = vim.uv.fs_stat(res)
                        if fs_stat and fs_stat.type == 'file' then
                            vim.g.path_to_executable = res
                        end
                    end
                    return vim.g.path_to_executable or ''
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
            {
                name = 'Attach to process',
                type = 'codelldb',
                request = 'attach',
                pid = function()
                    local prompt = vim.g.process_id and vim.g.process_id
                        or vim.g.process_name and vim.g.process_name
                        or 'not set'
                    local id_or_name = vim.fn.input(
                        'Process ID or Executable name (filter) [' .. prompt .. ']: ',
                        vim.fn.getcwd() .. '/',
                        'file'
                    )
                    id_or_name = id_or_name:gsub('^%s*(.-)%s*$', '%1')
                    if tonumber(id_or_name) then
                        vim.g.process_id = tonumber(id_or_name)
                        return vim.g.process_id
                    elseif not id_or_name:match('^%s*$') then
                        local fs_stat = vim.uv.fs_stat(id_or_name)
                        if fs_stat and fs_stat.type == 'file' then
                            vim.g.process_name = id_or_name
                        end
                    end
                    return dap.utils.pick_process({ filter = vim.g.process_name })
                end,
                cwd = '${workspaceFolder}',
            },
        }
        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c
        dap.configurations.objc = dap.configurations.c
        dap.configurations.objcpp = dap.configurations.c
    end,
}
return {
    'rcarriga/nvim-dap-ui',
    dependencies = {
        dap,
        'nvim-neotest/nvim-nio',
        { 'theHamsta/nvim-dap-virtual-text', config = true },
    },
    opts = {
        mappings = {
            edit = { 'e' },
            expand = { '<2-LeftMouse>', 'l', 'h' },
            open = { '<cr>', 'o' },
            remove = { 'x', 'd' },
            repl = { 'r' },
            toggle = { 't' },
        },
        layouts = {
            {
                elements = {
                    {
                        id = 'scopes',
                        size = 0.25,
                    },
                    {
                        id = 'breakpoints',
                        size = 0.25,
                    },
                    {
                        id = 'stacks',
                        size = 0.25,
                    },
                    {
                        id = 'watches',
                        size = 0.25,
                    },
                },
                position = 'left',
                size = math.max(20, math.ceil(vim.o.columns * 0.2)),
            },
            {
                elements = {
                    {
                        id = 'console',
                        size = 0.5,
                    },
                    {
                        id = 'repl',
                        size = 0.5,
                    },
                },
                position = 'bottom',
                size = math.max(8, math.ceil(vim.o.lines * 0.2)),
            },
        },
        floating = {
            mappings = {
                close = { 'q', '<esc>', '<c-c>' },
            },
        },
    },
    keys = {
        {
            '<leader>dt',
            debug_test_under_cursor,
            desc = 'Debug test under cursor',
        },
        { '<leader>D', dap_ui_toggle, { desc = 'Toggle debug ui' } },
        { '<leader>du', dap_ui_toggle, { desc = 'Toggle debug ui' } },
        {
            '<leader>b',
            function() require('dap').toggle_breakpoint() end,
            desc = 'Toggle breakpoint',
        },
        {
            '<leader>B',
            function() require('dap').set_breakpoint(vim.fn.input('Breakpoint Condition: ')) end,
            desc = 'Set condition breakpoint',
        },
        { '<leader>dr', function() require('dap').repl.open() end, desc = 'Open repl' },
        {
            '<leader>df',
            function() require('dapui').float_element() end,
            desc = 'Debug floating element',
        },
        {
            '<leader>de',
            function() require('dapui').eval(vim.fn.input('Evaluate Expression: ')) end,
            desc = 'Debug eval expression',
        },
        { '<f4>', function() require('dap').terminate() end, desc = 'Debug terminate' },
        { '<f5>', function() require('dap').continue() end, desc = 'Debug continue' },
        { '<f6>', function() require('dap').restart() end, desc = 'Debug restart' },
        { '<f9>', function() require('dap').step_back() end, desc = 'Debug back' },
        { '<f10>', function() require('dap').step_over() end, desc = 'Debug next' },
        { '<f11>', function() require('dap').step_into() end, desc = 'Debug step into' },
        { '<f12>', function() require('dap').step_out() end, desc = 'Debug step out' },
    },
}
