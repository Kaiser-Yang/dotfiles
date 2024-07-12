local mapping = require("yanky.telescope.mapping")
require("telescope").load_extension("yank_history")
-- TODO there will be some errors
require'yanky'.setup({
    picker = {
        highlight = {
            on_yank = true,
            on_put = false,
            timer = 500
        },
        telescope = {
            use_default_mappings = false,
            mappings = {
                i = {
                    ['<cr>'] = mapping.put("p"),
                },
                n = {
                    ['<cr>'] = mapping.put("p"),
                    p = mapping.put("p"),
                    P = mapping.put("P"),
                }
            },
        }
    }
})

