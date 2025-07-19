-- TODO:
-- completion for dap commands
vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98C379' })
vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#31353F' })
vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#888888' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DapStopped', linehl = 'DapStoppedLine' })
vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint' })
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text = 'x', texthl = 'DapBreakpointRejected' })
vim.fn.sign_define('DapBreakpointCondition', { text = '○', texthl = 'DapBreakpointCondition' })
local dap_ui_visible = false
local need_restore_explorer = false
local utils = require('utils')
local function has_neo_tree() return utils.get_win_with_filetype('neo-tree') ~= nil end
local function dap_ui_toggle()
    dap_ui_visible = not dap_ui_visible
    local dap_ui = require('dapui')
    if dap_ui_visible then
        dap_ui.open()
        if has_neo_tree() then
            need_restore_explorer = true
            require('neo-tree.command').execute({ action = 'close' })
        end
    else
        dap_ui.close()
        if need_restore_explorer then
            need_restore_explorer = false
            require('neo-tree.command').execute({
                action = 'show',
                source = 'last',
            })
        end
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
local function input_action(prompt, callback)
    return function()
        local input = vim.fn.input(prompt)
        if not input or input:match('^%s*$') then
            return -- do nothing if input is empty
        end
        callback(input)
    end
end
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'UserDIY',
    callback = function()
        if vim.bo.filetype:match('^dap') and vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
    end,
})
vim.api.nvim_create_autocmd({ 'TabClosed', 'BufWinEnter' }, {
    group = 'UserDIY',
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
local has_last = false
local nvim_dap = {
    'mfussenegger/nvim-dap',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local dap, dap_ui = require('dap'), require('dapui')
        dap.listeners.before.attach.dapui_config = function() dap_ui.open() end
        dap.listeners.before.attach.set_has_last = function() has_last = true end
        dap.listeners.before.launch.dapui_config = function() dap_ui.open() end
        local vscode = require('dap.ext.vscode')
        local json = require('plenary.json')
        vscode.json_decode = function(str) return vim.json.decode(json.json_strip_comments(str)) end
        if vim.g.only_vscode_launch then return end
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
                    if utils.is_file(vim.g.path_to_executable) then
                        return vim.g.path_to_executable
                    end
                    local res = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                    if utils.is_file(res) then vim.g.path_to_executable = res end
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
                    if vim.g.process_id then return vim.g.process_id end
                    if utils.is_file(vim.g.process_name) then
                        return dap.utils.pick_process({ filter = vim.g.process_name })
                    end
                    local id_or_name = vim.fn.input(
                        'Process ID or Executable name (filter): ',
                        vim.fn.getcwd() .. '/',
                        'file'
                    )
                    -- remove leading and trailing spaces
                    id_or_name = id_or_name:gsub('^%s*(.-)%s*$', '%1')
                    if tonumber(id_or_name) then
                        vim.g.process_id = tonumber(id_or_name)
                        return vim.g.process_id
                    elseif utils.is_file(id_or_name) then
                        vim.g.process_name = id_or_name
                    end
                    return dap.utils.pick_process({ filter = vim.g.process_name })
                end,
                cwd = '${workspaceFolder}',
            },
        }
        dap.configurations.cpp = vim.deepcopy(dap.configurations.c)
        dap.configurations.rust = vim.deepcopy(dap.configurations.c)
        dap.configurations.objc = vim.deepcopy(dap.configurations.c)
        dap.configurations.objcpp = vim.deepcopy(dap.configurations.c)
    end,
}
return {
    'rcarriga/nvim-dap-ui',
    dependencies = {
        nvim_dap,
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
                size = math.max(30, math.ceil(vim.o.columns * 0.14)),
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
        { '<leader>D', dap_ui_toggle, desc = 'Toggle debug ui' },
        { '<leader>du', dap_ui_toggle, desc = 'Toggle debug ui' },
        {
            '<leader>b',
            function() require('dap').toggle_breakpoint() end,
            desc = 'Toggle breakpoint',
        },
        {
            '<leader>B',
            input_action(
                'Breakpoint Condition: ',
                function(input) require('dap').set_breakpoint(input) end
            ),
            desc = 'Set condition breakpoint',
        },
        {
            '<leader>df',
            function() require('dapui').float_element() end,
            desc = 'Debug floating element',
        },
        {
            '<leader>de',
            input_action('Evaluate Expression: ', function(input) require('dapui').eval(input) end),
            desc = 'Debug eval expression',
        },
        {
            '<Leader>dl',
            input_action(
                'Log point message: ',
                function(input) require('dap').set_breakpoint(nil, nil, input) end
            ),
            desc = 'Set log point for current line',
        },
        { '<f4>', function() require('dap').terminate() end, desc = 'Debug terminate' },
        {
            '<f5>',
            function()
                local dap = require('dap')
                local session = dap.session()
                if session or not has_last then
                    dap.continue()
                else
                    dap.run_last()
                end
            end,
            desc = 'Debug continue or run last',
        },
        { '<f6>', function() require('dap').restart() end, desc = 'Debug restart' },
        { '<f9>', function() require('dap').step_back() end, desc = 'Debug back' },
        { '<f10>', function() require('dap').step_over() end, desc = 'Debug next' },
        { '<f11>', function() require('dap').step_into() end, desc = 'Debug step into' },
        { '<f12>', function() require('dap').step_out() end, desc = 'Debug step out' },
    },
}
