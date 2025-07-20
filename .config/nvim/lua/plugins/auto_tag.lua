return {
    'windwp/nvim-ts-autotag',
    ft = {
        'astro',
        'glimmer',
        'handlebars',
        'html',
        'javascript',
        'jsx',
        'liquid',
        'markdown',
        'php',
        'rescript',
        'svelte',
        'tsx',
        'twig',
        'typescript',
        'vue',
        'xml',
    },
    opts = {
        opts = {
            enable_close_on_slash = true,
        },
    },
    config = function(_, opts)
        require('nvim-ts-autotag').setup(opts)
        vim.api.nvim_create_autocmd('BufEnter', {
            group = 'UserDIY',
            callback = function(args)
                if require('utils').is_big_file(args.buf) then
                    require('nvim-ts-autotag.internal').detach(args.buf)
                end
            end,
        })
    end,
}
