local function is_popup(winid)
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if not ok then return false end
    return config.relative ~= ''
end
local input_action = require('utils').input_action
vim.api.nvim_create_autocmd({ 'TabClosed', 'BufWinEnter', 'TabEnter' }, {
    group = 'UserDIY',
    callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if is_popup(win) then goto continue end
            local filetype = vim.bo[buf].filetype
            if filetype:match('^dap') or filetype == 'neo-true' then
                if vim.fn.winnr('$') ~= 1 then
                    vim.wo[win].statuscolumn = ' '
                else
                    vim.wo[win].statuscolumn = ' %=%{v:lua.get_label()} '
                    vim.wo[win].cursorcolumn = false
                    vim.wo[win].cursorline = false
                end
                vim.wo[win].foldcolumn = '0'
                vim.wo[win].signcolumn = 'no'
            elseif vim.bo[buf].filetype == 'snacks_picker_preview' then
                vim.wo[win].statuscolumn = '%=%{v:lua.get_label(v:true)} '
                vim.wo[win].foldcolumn = '0'
                vim.wo[win].signcolumn = 'no'
            end
            ::continue::
        end
    end,
})
return {
    'luukvbaal/statuscol.nvim',
    event = 'VeryLazy',
    opts = {
        segments = {
            {
                click = 'v:lua.ScSa',
                sign = {
                    name = { '^[^gF]' },
                    namespace = { '^[^gf]' },
                    colwidth = 1,
                },
            },
            {
                text = { function(args) return '%=' .. _G.get_label(false, args) end, ' ' },
                click = 'v:lua.ScLa',
            },
            {
                click = 'v:lua.ScSa',
                sign = {
                    name = { 'FoldClosedSign', 'FoldOpenSign' },
                    namespace = { 'git' },
                    colwidth = 1,
                },
            },
        },
        clickhandlers = {
            Lnum = function(args)
                local ok, dap = pcall(require, 'dap')
                if not ok then
                    vim.notify('DAP not found', vim.log.levels.WARN)
                    return
                end
                -- <C-LeftMouse>
                if args.button == 'l' and args.mods:find('c') then
                    input_action(
                        'Breakpoint Condition: ',
                        function(input) require('dap').set_breakpoint(input) end
                    )()
                -- <LeftMouse>
                elseif args.button == 'l' and args.mods:match('^%s*$') then
                    dap.toggle_breakpoint()
                end
            end,
            -- TODO: beautify this
            -- ['diagnostic/signs'] = function(args)
            --     if args.button == 'l' and args.mods:match('^%s*$') then
            --     end
            -- end,
            FoldClosedSign = function(args)
                -- <C-LeftMouse>
                if args.button == 'l' and args.mods:find('c') then
                -- <LeftMouse>
                elseif args.button == 'l' and args.mods:match('^%s*$') then
                    vim.cmd('normal! zo')
                end
                require('foldsign').update_fold_signs(vim.api.nvim_get_current_buf())
            end,
            FoldOpenSign = function(args)
                -- <C-LeftMouse>
                if args.button == 'l' and args.mods:find('c') then
                -- <LeftMouse>
                elseif args.button == 'l' and args.mods:match('^%s*$') then
                    vim.cmd('normal! zc')
                end
                require('foldsign').update_fold_signs(vim.api.nvim_get_current_buf())
            end,
        },
    },
}
