return {
    'pwntester/octo.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'Kaiser-Yang/snacks.nvim',
    },
    opts = {
        picker = 'snacks',
    },
    event = { { event = 'User', pattern = 'NetworkCheckedOK' } },
}
