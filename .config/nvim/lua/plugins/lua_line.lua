local lua_line_ignore_ft = {
    'neo-tree',
    'Avante',
    'AvanteInput',
    'help',
}
--- @param ft_list string|string[]
local function disable_in_ft(ft_list)
    ft_list = type(ft_list) == 'string' and { ft_list } or ft_list
    return function(str)
        assert(type(ft_list) == 'table', 'Expected a table, got: ' .. type(ft_list))
        for _, f in ipairs(ft_list) do
            if vim.bo.filetype:match(f) then return '' end
        end
        return str
    end
end
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
            lualine_b = {
                {
                    'branch',
                    fmt = disable_in_ft('dap'),
                },
                {
                    'diff',
                    fmt = disable_in_ft('dap'),
                },
                'searchcount',
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
