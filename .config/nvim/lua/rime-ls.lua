local M = {}

function M.setup_rime()
    -- global status
    vim.g.rime_enabled = true

    -- update lualine
    local function rime_status()
        if vim.g.rime_enabled then
            return 'ㄓ'
        else
            return ''
        end
    end

    require('lualine').setup({
        sections = {
            lualine_x = { rime_status, 'copilot', 'encoding', 'fileformat', 'filetype' },
        }
    })

    -- add rime-ls to lspconfig as a custom server
    -- see `:h lspconfig-new`
    local lspconfig = require('lspconfig')
    local configs = require('lspconfig.configs')
    if not configs.rime_ls then
        configs.rime_ls = {
            default_config = {
                name = "rime_ls",
                cmd = { vim.fn.expand'~/rime-ls/target/release/rime_ls' },
                -- cmd = vim.lsp.rpc.connect('127.0.0.1', 9257),
                filetypes = { 'markdown', 'vimwiki' },
                single_file_support = true,
            },
            settings = {},
            docs = {
                description = [[
https://www.github.com/wlh320/rime-ls

A language server for librime
]],
            }
        }
    end

    local rime_on_attach = function(client, _)
        local toggle_rime = function()
            client.request('workspace/executeCommand',
                { command = "rime-ls.toggle-rime" },
                function(_, result, ctx, _)
                    if ctx.client_id == client.id then
                        vim.g.rime_enabled = result
                    end
                end
            )
        end
        -- keymaps for executing command
        vim.keymap.set('i', '<C-z>', function() toggle_rime() end)
        -- vim.keymap.set('n', '<leader><space>', function() toggle_rime() end)
        -- vim.keymap.set('n', '<leader>rs', function() vim.lsp.buf.execute_command({ command = "rime-ls.sync-user-data" }) end)
    end

    -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    lspconfig.rime_ls.setup {
        init_options = {
            enabled = vim.g.rime_enabled,
            shared_data_dir = "/usr/share/rime-data",
            user_data_dir = vim.fn.expand"~/.local/share/rime-ls",
            log_dir = vim.fn.expand"~/.local/share/rime-ls",
            max_candidates = 9,
            paging_characters = {",", ".", "-", "="},
            trigger_characters = {},
            schema_trigger_character = "&" -- [since v0.2.0] 当输入此字符串时请求补全会触发 “方案选单”
        },
        on_attach = rime_on_attach,
        capabilities = capabilities,
    }
end

local just_inserted = false
local function is_rime_entry(entry)
  return vim.tbl_get(entry, "source", "name") == "nvim_lsp"
    and vim.tbl_get(entry, "source", "source", "client", "name")
      == "rime_ls"
end
local rime_ls_auto_confirm = vim.schedule_wrap(function()
  local cmp = require("cmp")
  if not cmp.visible() then
    return
  end
  local entries = cmp.core.view:get_entries()
  if entries == nil or #entries == 0 then
    return
  end
  local rime_ls_entries_cnt = 0
  for _, entry in ipairs(entries) do
    if is_rime_entry(entry) then
      rime_ls_entries_cnt = rime_ls_entries_cnt + 1
    end
  end
  local first_entry = cmp.get_selected_entry()
  if first_entry == nil then
    first_entry = cmp.core.view:get_first_entry()
  end
  if
    first_entry ~= nil
    and rime_ls_entries_cnt == 1
    and is_rime_entry(first_entry)
    -- and text_edit_range_length(first_entry) == 4
  then
    cmp.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }
  end
end)

vim.api.nvim_create_autocmd("InsertCharPre", {
  buffer = bufnr,
  callback = function()
    just_inserted = true
  end,
})
vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
  buffer = bufnr,
  callback = function()
    if just_inserted then
      -- check completion
      rime_ls_auto_confirm()
      just_inserted = false
    end
  end,
})

return M

