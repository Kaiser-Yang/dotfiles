return {
    'rcarriga/nvim-dap-ui',
    dependencies = {
        'mfussenegger/nvim-dap',
        'nvim-neotest/nvim-nio',
        { 'theHamsta/nvim-dap-virtual-text', config = true },
    },
    config = function()
        require('nvim-dap-virtual-text').setup({})
        local dap, dap_ui = require('dap'), require('dapui')
        dap_ui.setup({
            mappings = {
                edit = { 'e' },
                expand = { '<2-LeftMouse>', 'l', 'h' },
                open = { '<cr>' },
                remove = { 'x' },
                repl = { 'r' },
                toggle = { 't' },
            },
            floating = {
                mappings = {
                    close = { 'q', '<esc>', '<c-c>', '<c-n>' },
                },
            },
        })
        -- NOTE: require gdb 14 and built with `--with-python`
        dap.adapters.gdb = {
            type = 'executable',
            command = 'gdb',
            args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
        }
        dap.configurations.c = {
            {
                name = 'Launch',
                type = 'gdb',
                request = 'launch',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopAtBeginningOfMainSubprogram = false,
            },
            {
                name = 'Select and attach to process',
                type = 'gdb',
                request = 'attach',
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                pid = function()
                    local name = vim.fn.input('Executable name (filter): ')
                    return require('dap.utils').pick_process({ filter = name })
                end,
                cwd = '${workspaceFolder}',
            },
        }
        dap.configurations.cpp = dap.configurations.c
        dap.configurations.rust = dap.configurations.c

        vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define(
            'DapBreakpointCondition',
            { text = '⭕', texthl = '', linehl = '', numhl = '' }
        )
        vim.fn.sign_define(
            'DapBreakpointRejected',
            { text = '🚫', texthl = '', linehl = '', numhl = '' }
        )
        vim.fn.sign_define('DapLogPoint', { text = '📔', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = '', numhl = '' })
        local dap_ui_visible = false
        local need_restore_explorer = false
        local function dap_ui_toggle()
            dap_ui_visible = not dap_ui_visible
            dap_ui.toggle()
            if dap_ui_visible then
                if vim.g.explorer_visible then
                    need_restore_explorer = true
                    require('neo-tree.command').execute({
                        action = 'close',
                    })
                    vim.cmd('wincmd =')
                end
            elseif need_restore_explorer then
                need_restore_explorer = false
                require('neo-tree.command').execute({
                    action = 'show',
                    source = 'last',
                    dir = vim.fn.getcwd(),
                })
                vim.cmd('wincmd =')
            end
        end
        local function debug_test_under_cursor()
            if vim.bo.filetype == 'java' then
                require('jdtls').test_nearest_method()
            else
                vim.notify('Debugging test under cursor is not supported for this filetype')
            end
        end
        dap.listeners.before.attach.dapui_config = function()
            if not dap_ui_visible then dap_ui_toggle() end
        end
        dap.listeners.before.launch.dapui_config = function()
            if not dap_ui_visible then dap_ui_toggle() end
        end
        local map_set = require('utils').map_set
        map_set({ 'n' }, '<leader>D', dap_ui_toggle, { desc = 'Toggle debug ui' })
        map_set({ 'n' }, '<leader>b', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
        map_set(
            { 'n' },
            '<leader>B',
            function() dap.set_breakpoint(vim.fn.input('Breakpoint Condition: ')) end,
            { desc = 'Set condition breakpoint' }
        )
        map_set(
            { 'n' },
            '<leader>dt',
            debug_test_under_cursor,
            { desc = 'Debug test under cursor' }
        )
        map_set({ 'n' }, '<leader>dr', dap.repl.open, { desc = 'Open repl' })
        map_set(
            { 'n' },
            '<leader>df',
            function() dap_ui.float_element() end,
            { desc = 'Debug floating element' }
        )
        map_set(
            { 'n' },
            '<leader>de',
            function() dap_ui.eval(vim.fn.input('Evaluate Expression: ')) end,
            { desc = 'Debug eval expression' }
        )
        map_set({ 'n' }, '<f4>', dap.terminate, { desc = 'Debug terminate' })
        map_set({ 'n' }, '<f5>', dap.continue, { desc = 'Debug continue' })
        map_set({ 'n' }, '<f6>', dap.restart, { desc = 'Debug restart' })
        map_set({ 'n' }, '<f9>', dap.step_back, { desc = 'Debug back' })
        map_set({ 'n' }, '<f10>', dap.step_over, { desc = 'Debug next' })
        map_set({ 'n' }, '<f11>', dap.step_into, { desc = 'Debug step into' })
        map_set({ 'n' }, '<f12>', dap.step_out, { desc = 'Debug step out' })
    end,
}
