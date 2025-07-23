local input_action = require('utils').input_action
local diagnostic_bufnr = nil
local diagnostic_win_id = nil
local get_fold_start = require('utils').get_fold_start
vim.api.nvim_create_autocmd({ 'BufNew', 'TabClosed', 'BufWinEnter', 'TabEnter' }, {
    group = 'UserDIY',
    callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local filetype = vim.bo[buf].filetype
            if filetype:match('^dap') then
                if vim.fn.winnr('$') ~= 1 then
                    vim.wo[win].statuscolumn = ' '
                else
                    vim.wo[win].statuscolumn = ' %=%{v:lua.get_label()} '
                    vim.wo[win].cursorcolumn = false
                    vim.wo[win].cursorline = false
                end
                vim.wo[win].foldcolumn = '0'
                vim.wo[win].signcolumn = 'no'
            elseif vim.bo[buf].filetype == 'snacks_picker_preview' or filetype == 'neo-tree' then
                vim.wo[win].statuscolumn = '%=%{v:lua.get_label('
                    .. (filetype == 'neo-tree' and 'v:false' or 'v:true')
                    .. ')} '
                vim.wo[win].foldcolumn = '0'
                vim.wo[win].signcolumn = 'no'
            end
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
                    name = { 'FoldClosed', 'FoldOpen' },
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
            FoldClosed = function(args)
                -- <C-LeftMouse>
                if args.button == 'l' and args.mods:find('c') then
                    get_fold_start(args.mousepos.line)
                -- <LeftMouse>
                elseif args.button == 'l' and args.mods:match('^%s*$') then
                    vim.cmd('normal! zo')
                end
                require('foldsign').update_fold_signs(vim.api.nvim_get_current_buf())
            end,
            FoldOpen = function(args)
                -- <C-LeftMouse>
                if args.button == 'l' and args.mods:find('c') then
                    local fold_start = get_fold_start(args.mousepos.line)
                    -- reverse the order to close from the bottom up
                    table.sort(fold_start, function(a, b) return a > b end)
                    for _, lnum in ipairs(fold_start) do
                        if vim.fn.foldclosed(lnum) == -1 then vim.cmd(lnum .. 'foldclose') end
                    end
                -- <LeftMouse>
                elseif args.button == 'l' and args.mods:match('^%s*$') then
                    vim.cmd('normal! zc')
                end
                require('foldsign').update_fold_signs(vim.api.nvim_get_current_buf())
            end,
            gitsigns = function(args)
                local ok, gitsigns = pcall(require, 'gitsigns')
                if not ok then
                    vim.notify('Gitsigns not found', vim.log.levels.WARN)
                    return
                end
                -- <LeftMouse>
                if args.button == 'l' and args.mods:match('^%s*$') then
                    for _, winid in ipairs(vim.api.nvim_list_wins()) do
                        -- Hunk is visible, we close the preview window
                        if vim.w[winid].gitsigns_preview == 'hunk' then
                            vim.api.nvim_win_close(winid, true)
                            return
                        end
                    end
                    gitsigns.preview_hunk()
                -- <MiddleMouse>
                elseif args.button == 'm' and args.mods:match('^%s*$') then
                    gitsigns.reset_hunk()
                -- <RightMouse>
                elseif args.button == 'r' and args.mods:match('^%s*$') then
                    gitsigns.stage_hunk()
                end
            end,
            ['diagnostic'] = function(args)
                -- <LeftMouse>
                if args.button == 'l' and args.mods:match('^%s*$') then
                    -- Hide if it is already open
                    if diagnostic_bufnr and diagnostic_win_id then
                        if vim.api.nvim_win_is_valid(diagnostic_win_id) then
                            vim.api.nvim_win_close(diagnostic_win_id, true)
                            diagnostic_bufnr = nil
                            diagnostic_win_id = nil
                            return
                        end
                    end
                    diagnostic_bufnr, diagnostic_win_id =
                        vim.diagnostic.open_float({ border = 'rounded' })
                end
            end,
            ['diagnostic/signs'] = false,
        },
    },
}
