return {
    opts = {
        sections = {
            lualine_x = {
                function() return vim.g.rime_enabled and 'ㄓ' or '' end,
            },
        },
    },
}
