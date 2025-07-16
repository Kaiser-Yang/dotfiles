return {
    'windwp/nvim-ts-autotag',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
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
}
