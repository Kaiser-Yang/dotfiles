local lua_line_ignore_ft = {
    'neo-tree',
    'Avante',
    'AvanteInput',
    'help',
}
local disable_in_ft = require('utils').disable_in_ft
local utils = require('utils')
return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'AndreM222/copilot-lualine',
    },
    lazy = false,
    opts = {
        options = {
            icons_enabled = true,
            theme = 'catppuccin',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = lua_line_ignore_ft,
                winbar = lua_line_ignore_ft,
            },
            ignore_focus = lua_line_ignore_ft,
            globalstatus = false,
        },
        sections = {
            lualine_a = { 'progress', 'location' },
            lualine_b = {
                {
                    'branch',
                    fmt = disable_in_ft('dap'),
                },
                {
                    'diff',
                    fmt = disable_in_ft('dap'),
                },
                {
                    function()
                        -- PERF: performance issue for large files
                        if utils.is_big_file() then return '' end
                        local last_search = vim.fn.getreg('/')
                        if not last_search or last_search == '' then return '' end
                        local searchcount = vim.fn.searchcount({ maxcount = 9999 })
                        return last_search
                            .. '['
                            .. searchcount.current
                            .. '/'
                            .. searchcount.total
                            .. ']'
                    end,
                },
            },
            lualine_c = {},
            lualine_x = {
                function() return vim.g.rime_enabled and 'ㄓ' or '' end,
                'copilot',
                {
                    'encoding',
                    fmt = disable_in_ft('dap'),
                },
                {
                    'fileformat',
                    fmt = disable_in_ft('dap'),
                },
                {
                    'filetype',
                    fmt = disable_in_ft('dap'),
                },
            },
            lualine_y = { 'quickfix' },
            lualine_z = { 'filename' },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
    },
}
