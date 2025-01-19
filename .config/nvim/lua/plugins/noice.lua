return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('noice').setup({
            routes = {
                -- FIX: copilot gives this all the time
                -- see: https://github.com/zbirenbaum/copilot.lua/issues/321
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = 'Agent service not initialized' },
                        },
                    },
                    opts = { skip = true },
                },
                -- NOTE: ignore the written message
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                },
                signature = {
                    enabled = false,
                },
                hover = {
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
                vim.notify(msg, vim.log.levels.INFO, {
                    title = 'Macro Recording',
                    keep = function() return _MACRO_RECORDING_STATUS end,
                    timeout = 0
                })
            end,
        })
        vim.api.nvim_create_autocmd('RecordingLeave', {
            group = 'UserDIY',
            callback = function()
                _MACRO_RECORDING_STATUS = false
            end,
        })
    end,
}
