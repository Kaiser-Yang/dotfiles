vim.api.nvim_create_autocmd('LspAttach', {
    group = 'UserDIY',
    callback = function(args)
        require('utils').map_set(
            { 'v', 'n' },
            'ga',
            require('actions-preview').code_actions,
            { desc = 'Code action', buffer = args.buf }
        )
    end,
})
return {
    'aznhe21/actions-preview.nvim',
    event = 'LspAttach',
}
