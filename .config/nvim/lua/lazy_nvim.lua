local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
CopilotDisable = false
require('lazy').setup({
    spec = {
        {
            'gbprod/yanky.nvim',
            config = function() require'plugin_config/yanky_config' end,
        },
        {
            'nvim-treesitter/nvim-treesitter',
            build = function() require('nvim-treesitter.install').update({ with_sync = true })() end,
            config = function() require'plugin_config/nvimtreesitter_config' end,
            dependencies = {
                -- without these two line works well
                'p00f/nvim-ts-rainbow',
                'nvim-treesitter/nvim-treesitter-context',
            }
        },
        {
            'nvim-telescope/telescope.nvim', tag = '0.1.8',
            dependencies = {
                'nvim-lua/plenary.nvim',
                {
                    'nvim-telescope/telescope-fzf-native.nvim',
                    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
                },
            },
            config = function() require'plugin_config/telescope_config' end,
        },
    }
})
