return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            python = { "autopep8" },
            java = { "google-java-format" },
            markdown = { "markdownlint" },
            vimwiki = { "markdownlint" },
            -- Use the "_" filetype to run formatters on filetypes that don't
            -- have other formatters configured.
            ["_"] = { "trim_whitespace", "codespell" },
            -- Use the "*" filetype to run formatters on all filetypes.
            -- ["*"] = { "codespell" },
            -- lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            -- go = { "goimports", "gofmt" },
            -- Use a sub-list to run only the first available formatter
            -- javascript = { { "prettierd", "prettier" } },
            -- You can use a function here to determine the formatters dynamically
            -- python = function(bufnr)
            --   if require("conform").get_formatter_info("ruff_format", bufnr).available then
            --     return { "ruff_format" }
            --   else
            --     return { "isort", "black" }
            --   end
            -- end,
        },
        -- INFO: uncomment this to auto format on save
        -- format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
        -- Customize formatters
        formatters = {
            autopep8 = {
                prepend_args = {
                    "--max-line-length=100"
                },
            },
        },
    },
    init = function()
        -- If you want the formatexpr, here is the place to set it
        ---@diagnostic disable-next-line: undefined-global
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
