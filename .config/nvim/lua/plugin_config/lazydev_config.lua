return{
    library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
    -- enable this may not complete right on other lua projects
    -- NOTE: you can create a .luarc.json in your project root to disable this
    enabled = function(root_dir)
        return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
    end,
}
