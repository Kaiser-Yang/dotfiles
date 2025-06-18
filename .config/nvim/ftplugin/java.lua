local utils = require('utils')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local jdtls_path = vim.fn.expand('$MASON/packages/jdtls')
local os_name = vim.fn.has('mac') == 1 and 'mac' or vim.fn.has('windows') == 1 and 'win' or 'linux'
local bundles =
    vim.split(vim.fn.glob('$MASON/packages/java-debug-adapter/extension/server/*.jar'), '\n')
vim.list_extend(
    bundles,
    vim.split(vim.fn.glob('$MASON/packages/java-test/extension/server/*.jar'), '\n')
)
local config = {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens',
        'java.base/java.util=ALL-UNNAMED',
        '--add-opens',
        'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. vim.fn.expand('$MASON/packages/lombok-nightly/lombok.jar'),
        '-jar',
        vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration',
        jdtls_path .. '/config_' .. os_name,
        '-data',
        workspace_dir,
    },

    root_dir = vim.fn.getcwd(),
    capabilities = utils.get_lsp_capabilities(),
    handlers = {
        ['$/progress'] = function(_, _, _) end,
    },
    settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            maven = {
                downloadSources = true,
            },
        },
    },
    init_options = {
        bundles = bundles,
    },
}
require('jdtls').start_or_attach(config)
