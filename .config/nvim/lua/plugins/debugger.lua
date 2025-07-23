-- TODO:
-- completion for dap commands
local utils = require('utils')
local function has_neo_tree() return utils.get_win_with_filetype('neo%-tree')[1] ~= nil end
local function get_dap_win_num()
    local res = 0
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.bo[vim.api.nvim_win_get_buf(win)].filetype:match('dap') then res = res + 1 end
    end
    return res
end
local function dap_ui_toggle()
    local dap_ui = require('dapui')
    local dap_win_num = get_dap_win_num()
    if dap_win_num < 6 then
        if dap_win_num ~= 0 then dap_ui.close() end
        if has_neo_tree() then require('neo-tree.command').execute({ action = 'close' }) end
        dap_ui.open({ reset = true })
    else
        dap_ui.close()
    end
end
local function debug_test_under_cursor()
    if vim.bo.filetype ~= 'java' then return end
    require('jdtls').test_nearest_method()
end
local input_action = require('utils').input_action
vim.api.nvim_create_autocmd('BufEnter', {
    group = 'UserDIY',
    callback = function()
        if vim.bo.filetype:match('^dap') and vim.fn.mode() == 'i' then vim.cmd('stopinsert') end
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
        local before_start = function()
            has_last = true
            if has_neo_tree() then require('neo-tree.command').execute({ action = 'close' }) end
            dap_ui.open({ reset = true })
        end
        dap.listeners.before.attach.dapui_config = before_start
        dap.listeners.before.launch.dapui_config = before_start
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
        -- INFO:
        -- Some colorschemes may have set some highlights, we use force here to override them
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
