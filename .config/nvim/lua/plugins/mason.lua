return {
    "williamboman/mason.nvim",
    -- do not update this with config, nvim-java requires this be loaded with opts
    branch = 'v1.x',
    opts = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }
}
