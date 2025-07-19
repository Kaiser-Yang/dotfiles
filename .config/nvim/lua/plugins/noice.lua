local map_set = require('utils').map_set
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'noice',
    callback = function() map_set('n', '<esc>', 'q', { remap = true, buffer = true }) end,
})
local macro_recording_status = false
vim.api.nvim_create_autocmd('RecordingEnter', {
    group = 'UserDIY',
    callback = function()
        local msg = string.format('Recording @%s', vim.fn.reg_recording())
        macro_recording_status = true
        vim.notify(msg, nil, {
            title = 'Macro Recording',
            keep = function() return macro_recording_status end,
            timeout = 0,
        })
    end,
})
vim.api.nvim_create_autocmd('RecordingLeave', {
    group = 'UserDIY',
    callback = function() macro_recording_status = false end,
})
return {
    'folke/noice.nvim',
    -- HACK:
    -- The experience of notify is not good enough
    -- TODO:
    -- remove nvim-notify when snacks.notifier is good enough
    dependencies = {
        'MunifTanjim/nui.nvim',
        {
            'rcarriga/nvim-notify',
            opts = {
                timeout = 1500,
                stages = 'static',
            },
        },
    },
    event = 'VeryLazy',
    opts = {
        lsp = {
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
            },
            signature = {
                enabled = false,
            },
            documentation = {
                enabled = false,
            },
        },
        presets = {
            long_message_to_split = true,
            lsp_doc_border = true,
        },
        messages = {
            view_search = false,
        },
    },
    keys = {
        {
            '<leader>sn',
            function()
                if not Snacks then return end
                require('noice.integrations.snacks').open({
                    on_show = function() vim.cmd.stopinsert() end,
                })
            end,
            desc = 'Noice history',
        },
    },
}
