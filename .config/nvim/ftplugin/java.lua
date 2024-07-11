local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = { vim.fn.expand("~") .. '/jdtls/bin/jdtls' },
  root_dir = vim.fs.root(0, {".root", ".git", "mvnw", "gradlew"}),
  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },
}
local bundles = {
    vim.fn.glob(vim.fn.expand("~") .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
};
vim.list_extend(bundles, vim.split(vim.fn.glob(vim.fn.expand("~") .. "/vscode-java-test/server/*.jar", 1), "\n"))
config['init_options'] = {
    bundles = bundles;
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
