return {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
        'williamboman/mason.nvim',
    },
    branch = 'v1.x',
    event = 'LspAttach',
    opts = {
        automatic_installation = false,
    },
}
