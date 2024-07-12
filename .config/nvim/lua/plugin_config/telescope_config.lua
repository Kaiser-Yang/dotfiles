require'telescope'.setup({
    defaults = {
        mappings = {
            i = {
                ['<c-p>'] = false,
                ['<c-n>'] = false,
                ['<c-f>'] = false,
                ['<tab>'] = false,
                ['<s-tab>'] = false,
                ['<c-j>'] = 'move_selection_next',
                ['<c-k>'] = 'move_selection_previous',
            },
            n = {
                ['<c-n>'] = 'close',
                ['q'] = 'close',
            }
        },
    },
})
