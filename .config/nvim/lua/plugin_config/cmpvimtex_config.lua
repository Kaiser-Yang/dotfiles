require('cmp_vimtex').setup({
    -- Eventual options can be specified here.
    -- Check out the tutorial for further details.
})
map_set({ 'i' }, '<c-s>', require('cmp_vimtex.search').search_menu)
