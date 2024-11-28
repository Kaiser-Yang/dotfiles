local map = vim.keymap

local function opts(opts_var)
    local desc = ""
    local silent = true
    local remap = false
    if opts_var and opts_var.desc ~= nil then
        desc = opts_var.desc
    end
    if opts_var and opts_var.silent ~= nil then
        silent = opts_var.silent
    end
    if opts_var and opts_var.remap ~= nil then
        remap = opts_var.remap
    end
    return { silent = silent, desc = desc, remap = remap }
end

local function feedkeys(keys, mode)
    local termcodes = vim.api.nvim_replace_termcodes(keys, true, true, true)
    vim.api.nvim_feedkeys(termcodes, mode, false)
end

map.set({ 'c' }, '<c-h>', '<left>', opts({ silent = false }))
map.set({ 'c' }, '<c-l>', '<right>', opts({ silent = false }))

map.set({ 'x' }, '<leader>c<leader>', '<Plug>(comment_toggle_linewise_visual)',
    opts({ desc = 'Comment toggle current line' }))
map.set({ 'x' }, '<leader>cs', '<Plug>(comment_toggle_blockwise_visual)',
    opts({ desc = 'Comment toggle current block' }))
map.set({ 'n' }, '<leader>c', '<Plug>(comment_toggle_linewise)',
    opts({ desc = 'Comment toggle line' }))
map.set({ 'n' }, '<leader>s', '<Plug>(comment_toggle_blockwise)',
    opts({ desc = 'Comment toggle block' }))

map.set({ 'n', 'v' }, '<leader>f', function()
    require 'conform'.format({ async = true, lsp_format = "fallback" }, function()
        local mode = vim.api.nvim_get_mode().mode
        if mode == 'v' or mode == 'V' then
            -- go back to normal mode
            feedkeys('<esc>', 'n')
        end
    end)
end, opts({ desc = 'Format current buffer' }))

function CopyBufferToPlusRegister()
    local cur = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command('normal! ggVGy')
    vim.api.nvim_win_set_cursor(0, cur)
    vim.defer_fn(function() vim.fn.setreg('+', vim.fn.getreg('"')) end, 0)
end

-- TODO: system clipboard not support this
map.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)', opts())
map.set({ 'n' }, 'gy', function()
    require 'telescope'.extensions.yank_history.yank_history({
        layout_strategy = "vertical",
        layout_config = {
            vertical = {
                anchor = 'S',
                height = 0.5,
                preview_height = 0.3,
                width = { padding = 0 },
                prompt_position = 'bottom',
            },
        },
        initial_mode = 'normal',
    })
end, opts())
map.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", opts())
map.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", opts())
map.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)",
    opts({ desc = 'Put yanked text after cursor and leave the cursor after pasted text' }))
map.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)",
    opts({ desc = 'Put yanked text before cursor and leave the cursor after pasted text' }))
-- TODO: add descriptions
-- map.set({ "n" }, "]p", "<Plug>(YankyPutIndentAfterLinewise)", opts({ desc = '' }))
-- map.set({ "n" }, "]P", "<Plug>(YankyPutIndentAfterLinewise)", opts({ desc = '' }))
-- map.set({ "n" }, "[p", "<Plug>(YankyPutIndentBeforeLinewise)", opts({ desc = '' }))
-- map.set({ "n" }, "[P", "<Plug>(YankyPutIndentBeforeLinewise)", opts({ desc = '' }))
-- map.set({ "n" }, ">p", "<Plug>(YankyPutIndentAfterShiftRight)", opts({ desc = '' }))
-- map.set({ "n" }, "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", opts({ desc = '' }))
-- map.set({ "n" }, ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", opts({ desc = '' }))
-- map.set({ "n" }, "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", opts({ desc = '' }))
-- map.set({ "n" }, "=p", "<Plug>(YankyPutAfterFilter)", opts({ desc = '' }))
-- map.set({ "n" }, "=P", "<Plug>(YankyPutBeforeFilter)", opts({ desc = '' }))
map.set({ 'n', 'x' }, '<leader>y', '"+y', opts({ desc = 'Yank to + reg' }))
map.set({ 'n', 'x' }, '<leader>p', '"+p', opts({ desc = 'Paste from + reg' }))
map.set({ 'n', 'x' }, '<leader>P', '"+P', opts({ desc = 'Paste before from + reg' }))
map.set({ 'n' }, '<leader>ay', CopyBufferToPlusRegister, opts({ desc = 'Yank all to + reg' }))
map.set({ 'n' }, '<leader>Y', '"+y$', opts({ desc = 'Yank till eol to + reg' }))
map.set({ 'n' }, 'Y', 'y$', opts())

map.set({ 'n' }, '<leader>sc', '<cmd>set spell!<cr>', opts({ desc = 'Toggle spell check' }))
map.set({ 'n' }, '<leader><cr>', '<cmd>nohlsearch<cr>', opts({ desc = 'No hlsearch' }))

-- map.set({ 'n' }, 'gz', '<cmd>ZenMode<cr>', opts({ desc = 'Toggle ZenMode' }))

local lazygit = require('toggleterm.terminal').Terminal:new({ cmd = "lazygit", hidden = true })
map.set({ 'i', 'n', 't' }, "<c-g>", function() lazygit:toggle() end, opts('Toggle lazygit'))
map.set({ 'i', 'n', 't' }, '<c-t>', '<cmd>ToggleTerm<cr>', opts({ desc = 'Toggle terminal' }))

local function is_visible_buffer(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
end
local function is_empty_buffer(buf)
    local num_lines = vim.api.nvim_buf_line_count(buf)
    return num_lines == 1 and vim.api.nvim_buf_get_lines(buf, 0, -1, true)[1] == ""
end
local function auto_close_empty_buffer()
    local windowsInCurrentTab = vim.api.nvim_tabpage_list_wins(0)
    local hiddenBuf = 0
    local emptyBuffer = {}
    for _, win in ipairs(windowsInCurrentTab) do
        local buf = vim.api.nvim_win_get_buf(win)
        if is_visible_buffer(buf) then
            local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
            if filetype == nil or filetype == "" then
                if is_empty_buffer(buf) then
                    emptyBuffer[#emptyBuffer + 1] = buf
                else
                    return
                end
            else
                return
            end
        else
            hiddenBuf = hiddenBuf + 1
        end
    end
    -- unload all empty buffers
    if #emptyBuffer > 0 then
        for _, buf in ipairs(emptyBuffer) do
            vim.cmd('silent! bd! ' .. buf)
        end
    end
    if #vim.api.nvim_list_tabpages() > 1 then
        -- only when there are hidden buffers, we need close current tab
        -- because when there is no hidden buffer, bd! will close the tab, too
        if hiddenBuf > 0 then
            vim.cmd 'silent! tabclose!'
        end
    else
        vim.cmd('qa!')
    end
end

local function quit_not_save_on_buffer()
    if not is_visible_buffer(vim.api.nvim_get_current_buf()) then
        vim.cmd('silent! q!')
        return
    end
    local windows = vim.api.nvim_tabpage_list_wins(0)
    local tabCnt = #vim.api.nvim_list_tabpages()
    local visibleBufCntCurrentTab = 0
    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        if is_visible_buffer(buf) then
            visibleBufCntCurrentTab = visibleBufCntCurrentTab + 1
        end
    end
    local buffer = vim.api.nvim_list_bufs()
    local bufferCnt = 0
    for _, buf in ipairs(buffer) do
        if is_visible_buffer(buf) then
            bufferCnt = bufferCnt + 1
        end
    end
    if visibleBufCntCurrentTab > 1 then
        vim.cmd('silent! q')
    else
        if tabCnt == 1 and bufferCnt > 1 then
            pcall(require("bufdelete").bufdelete, 0, true)
            auto_close_empty_buffer()
        elseif tabCnt > 1 then
            vim.cmd('silent! q!')
            auto_close_empty_buffer()
        elseif bufferCnt == 1 then
            vim.cmd('qa!')
        end
    end
end

-- map.set({ "i" }, "<c-s>", require('cmp_vimtex.search').search_menu, opts())
map.set({ 'n' }, 'Q', quit_not_save_on_buffer, opts())
map.set({ 'n' }, 'S', quit_not_save_on_buffer, opts())

map.set({ 'n' }, '<leader>h', '<cmd>set nosplitright<cr><cmd>vsplit<cr><cmd>set splitright<cr>',
    opts({ desc = 'Split right' }))
map.set({ 'n' }, '<leader>l', '<cmd>set splitright<cr><cmd>vsplit<cr>',
    opts({ desc = 'Split left' }))
map.set({ 't' }, '<c-h>', '<c-\\><c-n><cmd>TmuxNavigateLeft<cr>', opts({ desc = 'Cursor left' }))
map.set({ 't' }, '<c-j>', '<c-\\><c-n><cmd>TmuxNavigateDown<cr>', opts({ desc = 'Cursor down' }))
map.set({ 't' }, '<c-k>', '<c-\\><c-n><cmd>TmuxNavigateUp<cr>', opts({ desc = 'Curor up' }))
map.set({ 't' }, '<c-l>', '<c-\\><c-n><cmd>TmuxNavigateRight<cr>', opts({ desc = 'Cursor right' }))
map.set({ 't', 'i', 'c', 'x', 'v', 'n' }, '<c-n>', '<c-\\><c-n>', opts())
map.set({ 'n' }, '<leader>J', '<c-w>J', opts({ desc = 'Reopen window down' }))
map.set({ 'n' }, '<leader>K', '<c-w>K', opts({ desc = 'Reopen window up' }))
map.set({ 'n' }, '<leader>H', '<c-w>H', opts({ desc = 'Reopen window left' }))
map.set({ 'n' }, '<leader>L', '<c-w>L', opts({ desc = 'Reopen window right' }))
local bufferline = require 'bufferline'
map.set({ 'n' }, '<leader>1', function() bufferline.go_to(1, true) end, opts({ desc = 'Go to the 1st buffer' }))
map.set({ 'n' }, '<leader>2', function() bufferline.go_to(2, true) end, opts({ desc = 'Go to the 2nd buffer' }))
map.set({ 'n' }, '<leader>3', function() bufferline.go_to(3, true) end, opts({ desc = 'Go to the 3rd buffer' }))
map.set({ 'n' }, '<leader>4', function() bufferline.go_to(4, true) end, opts({ desc = 'Go to the 4th buffer' }))
map.set({ 'n' }, '<leader>5', function() bufferline.go_to(5, true) end, opts({ desc = 'Go to the 5th buffer' }))
map.set({ 'n' }, '<leader>6', function() bufferline.go_to(6, true) end, opts({ desc = 'Go to the 6th buffer' }))
map.set({ 'n' }, '<leader>7', function() bufferline.go_to(7, true) end, opts({ desc = 'Go to the 7th buffer' }))
map.set({ 'n' }, '<leader>8', function() bufferline.go_to(8, true) end, opts({ desc = 'Go to the 8th buffer' }))
map.set({ 'n' }, '<leader>9', function() bufferline.go_to(9, true) end, opts({ desc = 'Go to the 9th buffer' }))
map.set({ 'n' }, '<leader>0', function() bufferline.go_to(10, true) end, opts({ desc = 'Go to the 10th buffer' }))
map.set({ 'n' }, '<leader>b', '<cmd>BufferLineCyclePrev<cr>', opts({ desc = 'Buffer switch left' }))
map.set({ 'n' }, '<leader>n', '<cmd>BufferLineCycleNext<cr>', opts({ desc = 'Buffer switch right' }))
map.set({ 'n' }, "gb", "<cmd>BufferLinePick<CR>", opts({ desc = 'Buffer pick' }))

map.set({ 'n' }, '<up>', '<cmd>res +5<cr>', opts())
map.set({ 'n' }, '<down>', '<cmd>res -5<cr>', opts())
map.set({ 'n' }, '<left>', '<cmd>vertical resize -5<cr>', opts())
map.set({ 'n' }, '<right>', '<cmd>vertical resize +5<cr>', opts())

-- TODO relative line number does not work well
-- function MoveSelectedLines(count, direction)
--     if count == nil or count == 0 then
--         count = 1
--     end
--     if direction == 'down' then
--         vim.cmd(string.format(":'<,'>move '>+%d", count))
--         vim.api.nvim_command('normal! gv')
--     elseif direction == 'up' then
--         vim.cmd(string.format(":'<,'>move '<-%d", count + 1))
--         vim.api.nvim_command('normal! gv')
--     end
-- end
-- map.set({ 'v' }, 'J', ":<C-u>lua MoveSelectedLines(vim.v.count1, 'down')<CR>",
--     opts({ desc = 'Selected up' }))
-- map.set({ 'v' }, 'K', ":<C-u>lua MoveSelectedLines(vim.v.count1, 'up')<CR>",
--     opts({ desc = 'Selected down' }))

map.set({ 'n' }, '[g', function() require 'gitsigns'.nav_hunk('prev') end, opts({ desc = 'Previous git hunk' }))
map.set({ 'n' }, ']g', function() require 'gitsigns'.nav_hunk('next') end, opts({ desc = 'Next git hunk' }))
map.set({ 'n' }, '[c', '<cmd>GitConflictPrevConflict<cr>', opts({ desc = 'Previous git conflict' }))
map.set({ 'n' }, ']c', '<cmd>GitConflictNextConflict<cr>', opts({ desc = 'Next git conflict' }))
map.del({ 'x', 'n' }, 'gc')
map.set({ 'n' }, 'gcc', '<cmd>GitConflictChooseOurs<cr>', opts({ desc = 'Git keep current' }))
map.set({ 'n' }, 'gci', '<cmd>GitConflictChooseTheirs<cr>', opts({ desc = 'Git keep incomming' }))
map.set({ 'n' }, 'gcb', '<cmd>GitConflictChooseBoth<cr>', opts({ desc = 'Git keep both' }))
map.set({ 'n' }, 'gcn', '<cmd>GitConflictChooseNone<cr>', opts({ desc = 'Git keep none' }))
map.set({ 'n' }, 'gcu', require 'gitsigns'.reset_hunk, opts({ desc = 'Git reset current hunk' }))
map.set({ 'n' }, 'gcd', require 'gitsigns'.preview_hunk, opts({ desc = 'Git diff current hunk' }))

map.set({ 'n' }, '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>', opts({ desc = 'Previous diagnostic' }))
map.set({ 'n' }, ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts({ desc = 'Next diagnostic' }))
map.set({ 'n' }, 'gr', '<cmd>Telescope lsp_references<cr>', opts({ desc = 'Go references' }))
map.set({ 'n' }, 'gd', '<cmd>Lspsaga goto_definition<cr>', opts({ desc = 'Go to definition' }))
map.set({ 'n' }, '<leader>d', '<cmd>Lspsaga hover_doc<cr>', opts({ desc = 'Hover document' }))
map.set({ 'n' }, '<leader>R', "<cmd>Lspsaga rename mode=n<cr>", opts({ desc = 'Rename' }))
map.set({ 'n' }, '<leader>i', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, opts({ desc = 'Toggle inlay hints' }))
map.set({ 'n' }, 'gi', "<cmd>Lspsaga finder imp<cr>", opts({ desc = 'Go to implementations' }))
map.set({ 'n', 'x' }, 'ga', "<cmd>Lspsaga code_action<cr>", opts({ desc = 'Code action' }))
-- TODO without implementation
-- map.set({ 'n' }, 'gh', '<cmd>CocCommand clangd.switchSourceHeader<CR>', DefaultOpt())

-- map.set({ 'n' }, 'gpt', '<cmd>CopilotChatToggle<cr>', opts({ desc = 'Toggle copilot-chat' }))
-- map.set({ 'v' }, 'gpt', ':CopilotChat', opts({ silent = false, desc = 'Copilot chat' }))
-- Custom buffer for CopilotChat
-- vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = "copilot-*",
--     callback = function()
--         vim.opt_local.relativenumber = true
--         vim.opt_local.number = true
--
--         -- insert at the end to chat with Copilot
--         map.set({ 'n' }, 'i', 'Gi', { silent = true, noremap = true, buffer = true })
--         -- q for stop the chat
--         map.set({ 'n' }, 'q', '<cmd>CopilotChatStop<cr>', { silent = true, noremap = true, buffer = true })
--     end,
-- })

local function get_root_directory()
    local rootDir = vim.fn.finddir(".root", ";")
    if rootDir ~= "" then
        if string.sub(rootDir, -1) == "/" then
            rootDir = rootDir.sub(1, -2)
        end
        rootDir = rootDir:match("(.+)/[^/]*$")
        return rootDir
    else
        local gitDir = vim.fn.system("git rev-parse --show-toplevel 2> /dev/null")
        if gitDir ~= "" and vim.fn.filereadable(gitDir) then
            return gitDir:sub(1, -2)
        else
            return vim.fn.getcwd()
        end
    end
end

function HasRootDirectory()
    local rootDir = vim.fn.finddir(".root", ";")
    if rootDir ~= "" then
        return true
    else
        local gitDir = vim.fn.system("git rev-parse --show-toplevel 2> /dev/null")
        if gitDir ~= "" and vim.fn.filereadable(gitDir) then
            return true
        else
            return false
        end
    end
end

local function OpenNvimTreeOnStart(data)
    -- only support with one extra parameter: a file or directory
    if #vim.v.argv > 3 then
        return
    end
    -- buffer is a real file on the disk
    local nameFile = vim.fn.filereadable(data.file) == 1

    -- check if data.file contain NvimTree
    -- buffer is a [No Name]
    local noName = #vim.v.argv == 2

    -- buffer is a directory
    local directory = string.find(data.file, "NvimTree") ~= nil

    -- current open file's filetype is git*
    local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype")
    local gitfile = #filetype > 3 and filetype:sub(1, 3) == "git"

    if gitfile then
        return
    end

    -- with no parameter or a file, then open nvim-tree on root directory, but do not focus
    if HasRootDirectory() and (nameFile or noName) then
        require('nvim-tree.api').tree.toggle({
            path = get_root_directory(),
            update_root = false,
            find_file = false,
            focus = false,
        })
        -- must be a non-exist named file
    elseif not directory and #vim.v.argv == 3 then
        require('nvim-tree.api').tree.toggle({
            path = get_root_directory(),
            update_root = false,
            find_file = false,
            focus = false,
        })
    end
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = OpenNvimTreeOnStart })

local autoFollow = false
local function toggleVimtexCursorFollow()
    if autoFollow then
        vim.cmd([[
        augroup VimtexViewOnCursorHold
            autocmd!
        augroup END
        ]])
        autoFollow = false
        vim.cmd('echo "Cursor follow disabled"')
    else
        vim.cmd([[
        augroup VimtexViewOnCursorHold
            autocmd!
            autocmd CursorHold *.tex silent! VimtexView
        augroup END
        ]])
        autoFollow = true
        vim.cmd('echo "Cursor follow enabled"')
    end
end
vim.api.nvim_create_user_command("VimtexToggleCursorFollow", toggleVimtexCursorFollow,
    { range = false, nargs = 0 })

local function compile_and_run()
    local fullpath = vim.fn.expand('%:p')
    local directory = vim.fn.fnamemodify(fullpath, ':h')
    local filename = vim.fn.fnamemodify(fullpath, ':t')
    local filename_noext = vim.fn.fnamemodify(fullpath, ':t:r')
    local command = ""
    if vim.bo.filetype == 'c' then
        command = string.format(
            'gcc -g -Wall "%s" -I include -o "%s.out" && echo RUNNING && time "./%s.out"',
            filename, filename_noext, filename_noext)
    elseif vim.bo.filetype == 'cpp' then
        command = string.format(
            'g++ -g -Wall -std=c++17 -I include "%s" -o "%s.out" && echo RUNNING && time "./%s.out"',
            filename, filename_noext, filename_noext)
    elseif vim.bo.filetype == 'java' then
        command = string.format(
            'javac "%s" && echo RUNNING && time java "%s"',
            filename, filename_noext)
    elseif vim.bo.filetype == 'sh' then
        command = string.format('time "./%s"', filename)
    elseif vim.bo.filetype == 'python' then
        command = string.format('time python3 "%s"', filename)
    elseif vim.bo.filetype == 'html' then
        command = string.format('wslview "%s" &', filename)
    elseif vim.bo.filetype == 'lua' then
        command = string.format('lua "%s"', filename)
        -- elseif vim.bo.filetype == 'tex' then
        --     toggleVimtexCursorFollow()
        --     if autoFollow then
        --         vim.api.nvim_command('VimtexView')
        --     end
        --     return
    elseif vim.bo.filetype == 'markdown' then
        vim.api.nvim_command('MarkdownPreview')
        return
    elseif vim.bo.filetype == 'vimwiki' then
        vim.api.nvim_command('MarkdownPreview')
        return
    elseif vim.bo.filetype == 'gitcommit' then
        vim.api.nvim_command('MarkdownPreview')
        return
    end
    if command == "" then
        vim.cmd 'echo "Unsupported filetype"'
        return
    end
    command = string.format("TermExec cmd='cd \"%s\" && %s' dir='%s'", directory, command, directory)
    vim.cmd(command)
end

map.set({ 'n' }, '<leader>r', compile_and_run, opts({ desc = 'Compile run' }))

map.del({ 'n' }, '<c-w>d')
map.del({ 'n' }, '<c-w><c-d>')
map.set({ 'n', 'i' }, '<c-w>', function()
    vim.cmd('Lspsaga outline')
    local mode = vim.api.nvim_get_mode().mode;
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    if filetype == 'sagaoutline' and (mode == 'i' or mode == 'I') then
        feedkeys('<esc>', 'n')
    end
end, opts())

map.set({ 'n', 'i' }, '<c-e>', function()
    local api = require('nvim-tree.api')
    api.tree.toggle({
        path = get_root_directory(),
        update_root = false,
        find_file = false,
        focus = true,
    })
    local mode = vim.api.nvim_get_mode().mode;
    if api.tree.is_tree_buf() and (mode == 'i' or mode == 'I') then
        feedkeys('<esc>', 'n')
    end
end, opts())

-- vim.cmd [[
-- " This function is copied from vimwiki
-- function! COPY_CR(normal, just_mrkr) abort
--     let res = vimwiki#tbl#kbd_cr()
--     if res !=? ''
--         exe 'normal! ' . res . "\<Right>"
--         startinsert
--         return
--     endif
--     call vimwiki#lst#kbd_cr(a:normal, a:just_mrkr)
-- endfunction
-- autocmd FileType vimwiki,git*,markdown,copilot-chat inoremap <silent><buffer> <S-CR>
--     \ <Esc>:call COPY_CR(2, 2)<CR>
-- ]]
-- map.set({ 'n' }, '<leader>wh', '<cmd>VimwikiAll2HTML<cr>', opts({ desc = 'Vimwiki all to HTML' }))

local cmp = require 'cmp'
function CmpSelected()
    return cmp.get_active_entry() ~= nil
end

local copilot = require 'copilot.suggestion'
local _, fittencode = pcall(require, 'fittencode')
map.set({ 'c' }, '<c-j>', cmp.select_next_item, opts())
map.set({ 'c' }, '<c-k>', cmp.select_prev_item, opts())
-- map.set({ 'i' }, '<c-z>', function()
--     if not DisableCopilot then
--         if copilot.is_visible() then
--             vim.b.copilot_suggestion_auto_trigger = false
--             copilot.dismiss()
--         else
--             vim.b.copilot_suggestion_auto_trigger = true
--             copilot.next()
--         end
--     else
--         if fittencode.has_suggestions() then
--             fittencode.enable_completions({ enable = false })
--             fittencode.dismiss()
--         else
--             fittencode.enable_completions({ enable = true })
--             fittencode.triggering_completion()
--         end
--     end
-- end, opts())
-- TEST: the mapping for fittencode is not tested yet
map.set({ 'i' }, '<m-f>', copilot.accept_word, opts())
map.set({ 'i' }, '<c-f>', function()
    if not DisableCopilot and copilot.is_visible() then
        copilot.accept_line()
    elseif DisableCopilot and fittencode.has_suggestions() then
        fittencode.accept_line()
    else
        LiveGrepOnRootDirectory()
    end
end, opts())
map.set({ 'i' }, '<c-j>', function()
    if cmp.visible() then
        cmp.select_next_item()
    elseif not DisableCopilot and copilot.is_visible() then
        copilot.next()
    elseif DisableCopilot and fittencode.has_suggestions() then
        fittencode.next()
    else
        feedkeys('<down>', 'n')
    end
end, opts())
map.set({ 'i' }, '<c-k>', function()
    if cmp.visible() then
        cmp.select_prev_item()
    elseif not DisableCopilot and copilot.is_visible() then
        copilot.prev()
    elseif DisableCopilot and fittencode.has_suggestions() then
        fittencode.prev()
    else
        feedkeys('<up>', 'n')
    end
end, opts())
map.set({ 'i' }, '<c-h>', '<left>', opts())
map.set({ 'i' }, '<c-l>', '<right>', opts())
map.set({ 'i' }, '<c-c>', function()
    if CmpSelected() then
        cmp.abort()
    elseif cmp.visible() then
        cmp.abort()
    elseif not DisableCopilot and copilot.is_visible() then
        copilot.dismiss()
    elseif DisableCopilot and fittencode.has_suggestions() then
        fittencode.dismiss()
    else
        feedkeys("<c-\\><c-n>", 'n')
    end
end, opts({ silent = false }))

if not DisableCopilot then
    map.set({ 'i' }, '<m-cr>', function()
        if copilot.is_visible() then
            copilot.accept()
        else
            feedkeys("<esc><cr>", 'n')
        end
    end, opts())
    vim.cmd [[
    inoremap <silent><expr> <CR>
        \ luaeval('CmpSelected()') ?
        \ '<cmd>lua require"cmp".confirm()<cr>' :
        \ '<C-g>u<CR><C-r>=AutoPairsReturn()<CR>'
    " autocmd FileType vimwiki,git*,markdown,copilot-chat
    "     \ inoremap <silent><script><buffer><expr> <CR>
    "     \ luaeval('CmpSelected()') ?
    "     \ '<cmd>lua require"cmp".confirm()<cr>' :
    "     \ luaeval('require"copilot.suggestion".is_visible()') ?
    "     \ '<cmd>lua require"copilot.suggestion".accept()<cr>' :
    "     \ '<C-]><Esc>:call COPY_CR(3, 5)<CR>'
    ]]
else
    map.set({ 'i' }, '<m-cr>', function()
        if fittencode.has_suggestions() then
            fittencode.accept_all_suggestions()
        else
            feedkeys("<esc><cr>", 'n')
        end
    end, opts())
    vim.cmd [[
    inoremap <silent><expr> <CR>
        \ luaeval('CmpSelected()') ?
        \ '<cmd>lua require"cmp".confirm()<cr>' :
        \ '\<C-g>u\<CR><C-r>=AutoPairsReturn()\<cr>'
    " autocmd FileType vimwiki,git*,markdown,copilot-chat
    "     \ inoremap <silent><script><buffer><expr> <CR>
    "     \ luaeval('CmpSelected()') ?
    "     \ '<cmd>lua require"cmp".confirm()<cr>' :
    "     \ luaeval('require("fittencode").has_suggestions()') ?
    "     \ '<cmd>lua require("fittencode").accept_all_suggestions()<cr>' :
    "     \ '<C-]><Esc>:call COPY_CR(3, 5)<CR>'
    ]]
end

-- TODO: update this with nvim-cmp
-- map.set("n", "gcl", "<Plug>(coc-codelens-action)", opts)

local telescope = require 'telescope.builtin'
function FindFilesOnRootDirectory()
    telescope.find_files({ search_dirs = { get_root_directory() }, hidden = true, no_ignore = true })
end

function LiveGrepOnRootDirectory()
    telescope.live_grep({ search_dirs = { get_root_directory() }, additional_args = { '--hidden', } })
end

map.set({ 'n', 'i' }, '<c-p>', FindFilesOnRootDirectory, opts())
map.set({ 'n' }, '<c-f>', LiveGrepOnRootDirectory, opts())
map.set({ 'n' }, '<leader><leader>', telescope.current_buffer_fuzzy_find,
    opts({ desc = 'Current buffer fuzzy find' }))

Nvim_tree_visible = false
DapUIVisible = false
function DapUIToggle()
    DapUIVisible = not DapUIVisible
    if DapUIVisible and require('nvim-tree.api').tree.is_visible() then
        Nvim_tree_visible = true
        require('nvim-tree.api').tree.close()
    elseif not DapUIVisible and Nvim_tree_visible then
        Nvim_tree_visible = false
        require('nvim-tree.api').tree.toggle({
            path = get_root_directory(),
            update_root = false,
            find_file = false,
            focus = false,
        })
    end
    require 'dapui'.toggle()
end

local dap = require 'dap'
map.set({ 'n' }, '<leader>D', DapUIToggle, opts({ desc = 'Toggle debug ui' }))
map.set({ 'n' }, '<c-b>', dap.toggle_breakpoint, opts({ desc = 'Toggle breakpoint' }))
map.set({ 'n' }, '<f4>', dap.terminate, opts({ desc = 'Debug terminate' }))
map.set({ 'n' }, '<f5>', dap.continue, opts({ desc = 'Debug continue' }))
map.set({ 'n' }, '<f6>', dap.restart, opts({ desc = 'Debug restart' }))
map.set({ 'n' }, '<f9>', dap.step_back, opts({ desc = 'Debug back' }))
map.set({ 'n' }, '<f10>', dap.step_over, opts({ desc = 'Debug next' }))
map.set({ 'n' }, '<f11>', dap.step_into, opts({ desc = 'Debug step into' }))
map.set({ 'n' }, '<f12>', dap.step_out, opts({ desc = 'Debug step out' }))

local function contain_chinese_character(content)
    for i = 1, #content do
        local byte = string.byte(content, i)
        if byte >= 0xE4 and byte <= 0xE9 then
            return true
        end
    end
    return false
end
local function is_rime_entry(entry)
    return entry ~= nil and entry.source.name == "nvim_lsp"
        and entry.source.source.client.name == "rime_ls"
        and (entry.word:match("%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d%+%d%d%d%d") or contain_chinese_character(entry.word))
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
map.set({ 'n', 'i', 's' }, '<c-space>', function()
    -- RimeToggle is async, so we must check the status before the toggle
    if vim.g.rime_enabled then
        for i = 1, #punc_en do
            map.del({ 'i', 's' }, punc_en[i] .. '<space>')
        end
    else
        for i = 1, #punc_en do
            map.set({ 'i', 's' }, punc_en[i] .. '<space>', punc_zh[i], opts())
        end
    end
    vim.cmd('RimeToggle')
end, opts())
for numkey = 1, 9 do
    local numkey_str = tostring(numkey)
    map.set({ 'i', 's' }, numkey_str, function()
        local visible = cmp.visible()
        vim.fn.feedkeys(numkey_str, 'n')
        if visible then
            vim.schedule(auto_upload_rime)
        end
    end, opts())
end
-- <f30> not used
map.set({ 'i' }, '<f30>', '<c-]><c-r>=AutoPairsSpace()<cr>', opts())
map.set({ 'i', 's' }, '<space>', function()
    if not vim.g.rime_enabled then
        feedkeys('<f30>', 'm')
    else
        local entry = cmp.get_selected_entry()
        if entry ~= nil then
            feedkeys('<f30>', 'm')
            return
        end
        entry = cmp.core.view:get_first_entry()
        if is_rime_entry(entry) then
            cmp.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            })
        else
            feedkeys('<f30>', 'm')
        end
    end
end, opts())

vim.cmd [[
" undo the last ,
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer><silent> ,u <esc>u`z:delmarks z<CR>a

" find next placeholder and remove it.
autocmd Filetype git*,markdown,copilot-chat
    \ inoremap<buffer><silent> ,f <c-g>u<c-o>mz<Esc>/<++><CR>:nohlsearch<CR>c4l

" bold
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,b <c-g>u<c-o>mz****<++><Esc>F*hi

" italic
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,i <c-g>u<c-o>mz**<++><Esc>F*i

" for code blocks
autocmd Filetype git*,markdown,copilot-chat
    \ inoremap<buffer> ,c <c-g>u<CR><CR>```<CR>```<CR><CR><++><Esc>3kA

" for pictures, mostly, we don't add pictures' descriptions
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,p <c-g>u<c-o>mz<CR><CR>![](){: .img-fluid}<CR><CR><++><Esc>2k0f(a

" for for links <a> are html links tag, so we use ,a
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,a <c-g>u<c-o>mz[](<++>)<++><Esc>F[a

" for headers
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,1 <c-g>u<c-o>mz#<Space>
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,2 <c-g>u<c-o>mz##<Space>
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,3 <c-g>u<c-o>mz###<Space>
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,4 <c-g>u<c-o>mz####<Space>

" delete lines
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,d <c-g>u<c-o>mz~~~~<++><Esc>F~hi

" tilde
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,t <c-g>u<c-o>mz``<++><Esc>F`i

" math formulas
autocmd Filetype git*,markdown,copilot-chat
    \ inoremap<buffer> ,M <c-g>u<c-o>mz<CR><CR>$$<CR><CR>$$<CR><CR><++><Esc>3kA

" math formulas in line
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,m <c-g>u<c-o>mz$$<++><Esc>F$i

" newline but not new paragraph
autocmd FileType git*,markdown,copilot-chat inoremap<buffer> ,n <c-g>u<c-o>mz<br><CR>

autocmd FileType git* setlocal cc=50,72

autocmd Filetype git*,markdown,copilot-chat setlocal spell
]]
