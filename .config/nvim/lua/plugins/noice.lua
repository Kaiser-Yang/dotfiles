return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
    },
    config = function()
        require('noice').setup {
            -- FIX: copilot gives this all the time
            -- see: https://github.com/zbirenbaum/copilot.lua/issues/321
            routes = {
                {
                    filter = {
                        event = 'msg_show',
                        any = {
                            { find = 'Agent service not initialized' },
                        },
                    },
                    opts = { skip = true },
                },
            },
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
            cmdline = {
                enabled = true,
                view = 'cmdline_popup',
                format = {
                    cmdline = { pattern = '^:', icon = '', lang = 'vim' },
                    search_down = { kind = 'search', pattern = '^/', icon = ' ', lang = 'regex' },
                    search_up = { kind = 'search', pattern = '^%?', icon = ' ', lang = 'regex' },
                    filter = { pattern = '^:%s*!', icon = '', lang = 'bash' },
                    lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '', lang = 'lua' },
                    help = { pattern = '^:%s*he?l?p?%s+', icon = '󰋗' },
                },
            },
        }
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
