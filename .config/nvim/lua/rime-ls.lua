local M = {}
local rime_ls_filetypes = { 'markdown', 'vimwiki', 'copilot-chat' }
local cmp = require("cmp")

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
                cmd = { vim.fn.expand '~/rime-ls/target/release/rime_ls' },
                filetypes = rime_ls_filetypes,
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
                    if cmp.visible() then
                        if not vim.g.rime_enabled then
                            cmp.close()
                        end
                        cmp.complete()
                    end
                end
            )
        end
        -- keymaps for executing command
        vim.keymap.set('i', '<c-space>', toggle_rime)
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
            user_data_dir = vim.fn.expand "~/.local/share/rime-ls",
            log_dir = vim.fn.expand "~/.local/share/rime-ls",
            paging_characters = { "-", "=" },
            trigger_characters = {},
            schema_trigger_character = "&"
        },
        on_attach = rime_on_attach,
        capabilities = capabilities,
    }
end

local function is_rime_entry(entry)
    return entry ~= nil and vim.tbl_get(entry, "source", "name") == "nvim_lsp"
        and vim.tbl_get(entry, "source", "source", "client", "name") == "rime_ls"
end
local function auto_upload_rime()
    if not cmp.visible() then
        return
    end
    local entries = cmp.core.view:get_entries()
    if entries == nil or #entries == 0 then
        return
    end
    local first_entry = cmp.get_selected_entry()
    if first_entry == nil then
        first_entry = cmp.core.view:get_first_entry()
    end
    if first_entry ~= nil and is_rime_entry(first_entry) then
        local rime_ls_entry_occur = false
        for _, entry in ipairs(entries) do
            if is_rime_entry(entry) then
                if rime_ls_entry_occur then
                    return
                end
                rime_ls_entry_occur = true
            end
        end
        if rime_ls_entry_occur then
            cmp.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            }
        end
    end
end
local punc_en = { ',', '.', ':', ';', '?', '\\' }
local punc_zh = { '，', '。', '：', '；', '？', '、' }
vim.api.nvim_create_autocmd('FileType', {
    pattern = rime_ls_filetypes,
    callback = function(env)
        -- copilot cannot attach client automatically, we must attach manually.
        local rime_ls_client = vim.lsp.get_clients({ name = 'rime_ls' })
        if #rime_ls_client == 0 then
            vim.cmd('LspStart rime_ls')
            rime_ls_client = vim.lsp.get_clients({ name = 'rime_ls' })
        end
        if #rime_ls_client > 0 then
            vim.lsp.buf_attach_client(env.buf, rime_ls_client[1].id)
        end
        for numkey = 1, 9 do
            local numkey_str = tostring(numkey)
            vim.keymap.set({ 'i', 's' }, numkey_str, function()
                local visible = cmp.visible()
                vim.fn.feedkeys(numkey_str, 'n')
                if visible then
                    vim.schedule(auto_upload_rime)
                end
            end, {
                noremap = true,
                silent = false,
                buffer = true,
            })
        end
        for i = 1, #punc_en do
            local src = punc_en[i] .. '<space>'
            local dst = 'rime_enabled ? "' .. punc_zh[i] .. '" : "' .. punc_en[i] .. ' "'
            vim.keymap.set({ 'i', 's' }, src, dst, {
                noremap = true,
                silent = false,
                expr = true,
                buffer = true,
            })
        end
        vim.keymap.set({ 'i', 's' }, '<space>', function()
            local entry = cmp.get_selected_entry()
            if entry == nil then
                entry = cmp.core.view:get_first_entry()
            end
            if is_rime_entry(entry) then
                cmp.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                })
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<f30>', true, true, true), 'm', false)
            end
        end, {
            noremap = true,
            silent = true,
            buffer =true
        })
    end
})
return M
