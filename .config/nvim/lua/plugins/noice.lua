local map_set = require('utils').map_set
return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    -- TODO: remove nvim-notify when snacks.notifier is good enough
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('noice').setup({
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
        })
        vim.api.nvim_create_autocmd('RecordingEnter', {
            group = 'UserDIY',
            callback = function()
                local msg = string.format('Recording @%s', vim.fn.reg_recording())
                _MACRO_RECORDING_STATUS = true
                vim.notify(msg, nil, {
                    title = 'Macro Recording',
                    keep = function() return _MACRO_RECORDING_STATUS end,
                    timeout = 0,
                })
            end,
        })
        vim.api.nvim_create_autocmd('RecordingLeave', {
            group = 'UserDIY',
            callback = function() _MACRO_RECORDING_STATUS = false end,
        })
        map_set({ 'n' }, '<leader>sn', function()
            require('noice.integrations.snacks').open({
                on_show = function() vim.cmd.stopinsert() end,
            })
        end, { desc = 'Noice history' })
    end,
}
