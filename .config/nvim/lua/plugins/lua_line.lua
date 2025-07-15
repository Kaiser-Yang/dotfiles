local lua_line_ignore_ft = {
    'neo-tree',
    'Avante',
    'AvanteInput',
    'help',
}
return {
    'nvim-lualine/lualine.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'AndreM222/copilot-lualine',
    },
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
            lualine_b = { 'branch', 'diff', 'searchcount' },
            lualine_c = {},
            lualine_x = {
                function() return vim.g.rime_enabled and 'ㄓ' or '' end,
                'copilot',
                'encoding',
                'fileformat',
                'filetype',
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
