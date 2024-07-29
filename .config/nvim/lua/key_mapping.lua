local map = vim.keymap

local function opts(opts_var)
    local desc = (opts_var and opts_var.desc) or ""
    local noremap = (opts_var and opts_var.noremap) or true
    local silent = (opts_var and opts_var.silent) or true
    return { noremap = noremap, silent = silent, desc = desc }
end

local function feedkeys(keys, mode)
    local termcodes = vim.api.nvim_replace_termcodes(keys, true, true, true)
    vim.api.nvim_feedkeys(termcodes, mode, false)
end

map.set({ 'c' }, '<c-h>', '<left>', opts())
map.set({ 'c' }, '<c-l>', '<right>', opts())

map.set({ 'n' }, 'gz', '<cmd>ZenMode<cr>', opts({ desc = 'Toggle ZenMode' }))

map.set({ 'x' }, '<leader>c<leader>', '<Plug>(comment_toggle_linewise_visual)',
    opts({ desc = 'Comment toggle current line' }))
map.set({ 'x' }, '<leader>cs', '<Plug>(comment_toggle_blockwise_visual)',
    opts({ desc = 'Comment toggle current block' }))
map.set({ 'n' }, '<leader>c', '<Plug>(comment_toggle_linewise)',
    opts({ desc = 'Comment toggle line' }))
map.set({ 'n' }, '<leader>s', '<Plug>(comment_toggle_blockwise)',
    opts({ desc = 'Comment toggle block' }))

map.set({ 'n' }, '<leader>f', function()
    require 'conform'.format({ async = true, lsp_format = "fallback" })
end, opts({ desc = 'Format current buffer' }))
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

function CopyBufferToPlusRegister()
    local cur = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command('normal! ggVGy')
    vim.api.nvim_win_set_cursor(0, cur)
    vim.defer_fn(function() vim.fn.setreg('+', vim.fn.getreg('"')) end, 0)
end

-- TODO: system clipboard not support this
map.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", opts())
map.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", opts())
-- TODO: add descriptions
map.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", opts({ desc = '' }))
map.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", opts({ desc = '' }))
map.set({ "n" }, "]p", "<Plug>(YankyPutIndentAfterLinewise)", opts({ desc = '' }))
map.set({ "n" }, "[p", "<Plug>(YankyPutIndentBeforeLinewise)", opts({ desc = '' }))
map.set({ "n" }, "]P", "<Plug>(YankyPutIndentAfterLinewise)", opts({ desc = '' }))
map.set({ "n" }, "[P", "<Plug>(YankyPutIndentBeforeLinewise)", opts({ desc = '' }))
map.set({ "n" }, ">p", "<Plug>(YankyPutIndentAfterShiftRight)", opts({ desc = '' }))
map.set({ "n" }, "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", opts({ desc = '' }))
map.set({ "n" }, ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", opts({ desc = '' }))
map.set({ "n" }, "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", opts({ desc = '' }))
map.set({ "n" }, "=p", "<Plug>(YankyPutAfterFilter)", opts({ desc = '' }))
map.set({ "n" }, "=P", "<Plug>(YankyPutBeforeFilter)", opts({ desc = '' }))
map.set({ 'n' }, '<leader>sc', '<cmd>set spell!<cr>', opts({ desc = 'Toggle spell check' }))
map.set({ 'n' }, '<leader><cr>', '<cmd>nohlsearch<cr>', opts({ desc = 'No hlsearch' }))
map.set({ 'n', 'x' }, '<leader>y', '"+y', opts({ desc = 'Yank to + reg' }))
map.set({ 'n', 'x' }, '<leader>p', '"+p', opts({ desc = 'Paste from + reg' }))
map.set({ 'n', 'x' }, '<leader>P', '"+P', opts({ desc = 'Paste before from + reg' }))
map.set({ 'n' }, '<leader>ay', CopyBufferToPlusRegister, opts({ desc = 'Yank all to + reg' }))
map.set({ 'n' }, '<leader>Y', '"+y$', opts({ desc = 'Yank till eol to + reg' }))
map.set({ 'n' }, 'Y', 'y$', opts())

local term_buf = -1
local term_win_height = -1
local term_visible = false
function CalculateNewSize(delta)
    term_win_height = math.max(1, term_win_height + delta)
end

local function validTerminalBuf(buf)
    return vim.api.nvim_buf_is_valid(buf) and
        vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal'
end
local function bufVisible(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
end
local function getTermWinCurrentTab()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_buf(win) == term_buf and validTerminalBuf(term_buf) then
            return win
        end
    end
    return -1
end
local function hideWin(win)
    local current_win = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(win)
    vim.cmd('hide')
    if win ~= current_win then
        vim.api.nvim_set_current_win(current_win)
    end
end
local function recordTermSize()
    local term_win = getTermWinCurrentTab()
    if term_win == -1 then
        return
    end
    term_win_height = vim.api.nvim_win_get_height(term_win)
end
local function adjustTermSize()
    local term_win = getTermWinCurrentTab()
    if term_win == -1 then
        return
    end
    vim.api.nvim_win_set_height(term_win, term_win_height)
end
local function setBufHiddenUnlisted(buf)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    vim.api.nvim_buf_set_option(buf, 'buflisted', false)
end
local function openTerminal()
    local current_bufnr = vim.api.nvim_get_current_buf()
    if not bufVisible(current_bufnr) then
        -- Find a visible buffer and go to the first one
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if bufVisible(buf) then
                vim.api.nvim_set_current_win(win)
                break
            end
        end
    end
    if term_win_height == -1 then
        term_win_height = math.floor(vim.api.nvim_win_get_height(0) / 4) + 1
    end
    if validTerminalBuf(term_buf) then
        vim.cmd('belowright split | buffer ' .. term_buf)
    else
        vim.cmd('belowright split | term')
    end
end
function ToggleTerm()
    -- Visible, hide it
    if term_visible then
        local term_win = getTermWinCurrentTab()
        if term_win == -1 then
            term_visible = false
            goto create_term_win
        end
        hideWin(term_win)
        term_visible = false
        return
    end
    ::create_term_win::
    -- Exists but hidden, show it
    if validTerminalBuf(term_buf) then
        openTerminal()
        adjustTermSize()
        vim.cmd 'setlocal syntax=off'
        -- Not exist or invalid buffer
    else
        openTerminal()
        term_buf = vim.api.nvim_get_current_buf()
        adjustTermSize()
        recordTermSize()
        setBufHiddenUnlisted(term_buf)
        vim.cmd 'setlocal syntax=off'
    end
    term_visible = true
end

map.set({ 'i', 'n', 't' }, '<c-t>', '<cmd>lua ToggleTerm()<cr>',
    opts({ desc = 'Toggle terminal' }))
function ToggleTermOnTabEnter()
    local term_win = getTermWinCurrentTab()
    -- create a new one
    if term_win == -1 and term_visible then
        local current_win = vim.api.nvim_get_current_win()
        vim.cmd('belowright split | buffer ' .. term_buf)
        adjustTermSize()
        -- set the cursor back to the original window
        vim.api.nvim_set_current_win(current_win)
        -- close the opened one
    elseif term_win ~= -1 and not term_visible then
        hideWin(term_win)
        -- resize the opened one
    else
        adjustTermSize()
    end
end

vim.api.nvim_create_augroup('TabEnterToggleTerm', { clear = true })
local newestTab = -1
vim.api.nvim_create_autocmd({ 'TabNew' }, {
    group = 'TabEnterToggleTerm',
    callback = function()
        newestTab = vim.api.nvim_get_current_tabpage()
    end,
})
vim.api.nvim_create_autocmd({ 'TabEnter' }, {
    group = 'TabEnterToggleTerm',
    callback = function()
        if vim.api.nvim_get_current_tabpage() ~= newestTab then
            ToggleTermOnTabEnter()
        end
    end,
})
vim.api.nvim_create_autocmd('WinResized', {
    group = 'TabEnterToggleTerm',
    callback = function() adjustTermSize() end,
})
local function emptyBuf(buf)
    local num_lines = vim.api.nvim_buf_line_count(buf)
    return num_lines == 1 and vim.api.nvim_buf_get_lines(buf, 0, -1, true)[1] == ""
end
local function autoClose()
    local windowsInCurrentTab = vim.api.nvim_tabpage_list_wins(0)
    local terminalBuf = -1
    local terminalWin = -1
    local hiddenBuf = 0
    local emptyBuffer = {}
    for _, win in ipairs(windowsInCurrentTab) do
        local buf = vim.api.nvim_win_get_buf(win)
        if validTerminalBuf(buf) then
            terminalBuf = buf
            terminalWin = win
        elseif bufVisible(buf) then
            local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
            if filetype == nil or filetype == "" then
                if emptyBuf(buf) then
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
    -- hide the terminal of current tab to avoid unloading
    if terminalBuf ~= -1 then
        hideWin(terminalWin)
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
function QuitNotSaveOnBuffer()
    local terminal = validTerminalBuf(vim.api.nvim_get_current_buf())
    if terminal then
        term_visible = false
    end
    if terminal then
        vim.cmd('silent! bd!')
        return
    elseif not bufVisible(vim.api.nvim_get_current_buf()) then
        vim.cmd('silent! q!')
        return
    end
    local windows = vim.api.nvim_tabpage_list_wins(0)
    local tabCnt = #vim.api.nvim_list_tabpages()
    local visibleBufCntCurrentTab = 0
    for _, win in ipairs(windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        if bufVisible(buf) then
            visibleBufCntCurrentTab = visibleBufCntCurrentTab + 1
        end
    end
    local buffer = vim.api.nvim_list_bufs()
    local bufferCnt = 0
    for _, buf in ipairs(buffer) do
        if bufVisible(buf) then
            bufferCnt = bufferCnt + 1
        end
    end
    if visibleBufCntCurrentTab > 1 then
        vim.cmd('silent! q')
    else
        if tabCnt == 1 and bufferCnt > 1 then
            pcall(require("bufdelete").bufdelete, 0, true)
            autoClose()
        elseif tabCnt > 1 then
            vim.cmd('silent! q!')
            autoClose()
        elseif bufferCnt == 1 then
            vim.cmd('qa!')
        end
    end
end

function QuitSaveOnBuffer()
    vim.cmd('w')
    QuitNotSaveOnBuffer()
end

map.set({ 'n' }, 'Q', QuitNotSaveOnBuffer, opts())
map.set({ 'n' }, 'S', QuitSaveOnBuffer, opts())
map.set({ "i" }, "<c-s>", require('cmp_vimtex.search').search_menu, opts())

map.set({ 'n' }, '<leader>h', '<cmd>set nosplitright<cr><cmd>vsplit<cr><cmd>set splitright<cr>',
    opts({ desc = 'Split right' }))
map.set({ 'n' }, '<leader>l', '<cmd>set splitright<cr><cmd>vsplit<cr>',
    opts({ desc = 'Split left' }))
map.set({ 'n' }, '<leader>t', '<cmd>tabnew<cr><cmd>lua ToggleTermOnTabEnter()<cr>',
    opts({ desc = 'Tabnew' }))
map.set({ 't' }, '<c-h>', '<c-\\><c-n><cmd>TmuxNavigateLeft<cr>', opts({ desc = 'Cursor left' }))
map.set({ 't' }, '<c-j>', '<c-\\><c-n><cmd>TmuxNavigateDown<cr>', opts({ desc = 'Cursor down' }))
map.set({ 't' }, '<c-k>', '<c-\\><c-n><cmd>TmuxNavigateUp<cr>', opts({ desc = 'Curor up' }))
map.set({ 't' }, '<c-l>', '<c-\\><c-n><cmd>TmuxNavigateRight<cr>', opts({ desc = 'Cursor right' }))
map.set({ 't', 'i', 'c', 'x', 'v', 'n' }, '<c-n>', '<c-\\><c-n>', opts())
map.set({ 'n' }, '<leader>J', '<c-w>J', opts({ desc = 'Reopen window down' }))
map.set({ 'n' }, '<leader>K', '<c-w>K', opts({ desc = 'Reopen window up' }))
map.set({ 'n' }, '<leader>H', '<c-w>H', opts({ desc = 'Reopen window left' }))
map.set({ 'n' }, '<leader>L', '<c-w>L', opts({ desc = 'Reopen window right' }))
map.set({ 'n' }, '<leader>T', '<c-w>T<cmd>lua ToggleTermOnTabEnter()<cr>',
    opts({ desc = 'Reopen window in tab' }))

map.set({ 'n' }, '<leader>b', '<cmd>BufferLineCyclePrev<cr>', opts({ desc = 'Buffer switch left' }))
map.set({ 'n' }, '<leader>n', '<cmd>BufferLineCycleNext<cr>',
    opts({ desc = 'Buffer switch right' }))
map.set({ 'n' }, "gb", "<cmd>BufferLinePick<CR>", opts({ desc = 'Buffer pick' }))
map.set({ 'n' }, '<leader>1', '1gt', opts({ desc = 'Go to tab 1' }))
map.set({ 'n' }, '<leader>2', '2gt', opts({ desc = 'Go to tab 2' }))
map.set({ 'n' }, '<leader>3', '3gt', opts({ desc = 'Go to tab 3' }))
map.set({ 'n' }, '<leader>4', '4gt', opts({ desc = 'Go to tab 4' }))
map.set({ 'n' }, '<leader>5', '5gt', opts({ desc = 'Go to tab 5' }))
map.set({ 'n' }, '<leader>6', '6gt', opts({ desc = 'Go to tab 6' }))
map.set({ 'n' }, '<leader>7', '7gt', opts({ desc = 'Go to tab 7' }))
map.set({ 'n' }, '<leader>8', '8gt', opts({ desc = 'Go to tab 8' }))
map.set({ 'n' }, '<leader>9', '9gt', opts({ desc = 'Go to tab 9' }))

map.set({ 'n' }, '<up>', '<cmd>lua CalculateNewSize(5)<cr><cmd>res +5<cr>', opts())
map.set({ 'n' }, '<down>', '<cmd>lua CalculateNewSize(-5)<cr><cmd>res -5<cr>', opts())
map.set({ 'n' }, '<left>', '<cmd>vertical resize -5<cr>', opts())
map.set({ 'n' }, '<right>', '<cmd>vertical resize +5<cr>', opts())

-- TODO relative line number does not work well
function MoveSelectedLines(count, direction)
    if count == nil or count == 0 then
        count = 1
    end
    if direction == 'down' then
        vim.cmd(string.format(":'<,'>move '>+%d", count))
        vim.api.nvim_command('normal! gv')
    elseif direction == 'up' then
        vim.cmd(string.format(":'<,'>move '<-%d", count + 1))
        vim.api.nvim_command('normal! gv')
    end
end

map.set({ 'v' }, 'J', ":<C-u>lua MoveSelectedLines(vim.v.count1, 'down')<CR>",
    opts({ desc = 'Selected up' }))
map.set({ 'v' }, 'K', ":<C-u>lua MoveSelectedLines(vim.v.count1, 'up')<CR>",
    opts({ desc = 'Selected down' }))

map.set({ 'n' }, '[g', require 'gitsigns'.prev_hunk, opts({ desc = 'Previous git hunk' }))
map.set({ 'n' }, ']g', require 'gitsigns'.next_hunk, opts({ desc = 'Next git hunk' }))
map.set({ 'n' }, '[c', '<cmd>GitConflictPrevConflict<cr>', opts({ desc = 'Previous git conflict' }))
map.set({ 'n' }, ']c', '<cmd>GitConflictNextConflict<cr>', opts({ desc = 'Next git conflict' }))
map.del({ 'x', 'n' }, 'gc')
map.set({ 'n' }, 'gcc', '<cmd>GitConflictChooseOurs<cr>', opts({ desc = 'Git keep current' }))
map.set({ 'n' }, 'gci', '<cmd>GitConflictChooseTheirs<cr>', opts({ desc = 'Git keep incomming' }))
map.set({ 'n' }, 'gcb', '<cmd>GitConflictChooseBoth<cr>', opts({ desc = 'Git keep both' }))
map.set({ 'n' }, 'gcn', '<cmd>GitConflictChooseNone<cr>', opts({ desc = 'Git keep none' }))
map.set({ 'n' }, 'gcu', require 'gitsigns'.reset_hunk, opts({ desc = 'Git reset current hunk' }))
map.set({ 'n' }, 'gcd', require 'gitsigns'.preview_hunk, opts({ desc = 'Git diff current hunk' }))

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
map.set({ 'n' }, '[d', '<cmd>Lspsaga diagnostic_jump_prev<cr>',
    opts({ desc = 'Previous diagnostic' }))
map.set({ 'n' }, ']d', '<cmd>Lspsaga diagnostic_jump_next<cr>', opts({ desc = 'Next diagnostic' }))
map.set({ 'n' }, 'gr', '<cmd>Telescope lsp_references<cr>', opts({ desc = 'Go references' }))
-- optional implementation of goto definitions
-- map.set({ 'n' }, 'gd', '<cmd>Telescope lsp_definitions<cr>', DefaultOpt())
-- map.set({ 'n' }, 'gd', vim.lsp.tagfunc, DefaultOpt())
map.set({ 'n' }, 'gd', '<cmd>Lspsaga goto_definition<cr>', opts({ desc = 'Go to definition' }))
map.set({ 'n' }, '<leader>d', '<cmd>Lspsaga hover_doc<cr>', opts({ desc = 'Hover document' }))
map.set({ 'n' }, '<leader>R', "<cmd>Lspsaga rename mode=n<cr>", opts({ desc = 'Rename' }))
map.set({ 'n' }, '<leader>i', function()
    ---@diagnostic disable-next-line: missing-parameter
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, opts({ desc = 'Toggle inlay hints' }))
map.set({ 'n', 'x' }, 'ga', "<cmd>Lspsaga code_action<cr>", opts({ desc = 'Code action' }))
map.set({ 'n' }, 'gi', "<cmd>Lspsaga finder imp<cr>", opts({ desc = 'Go to implementations' }))
-- TODO without implementation
-- map.set({ 'n' }, 'gh', '<cmd>CocCommand clangd.switchSourceHeader<CR>', DefaultOpt())

map.set({ 'n' }, 'gpt', '<cmd>CopilotChatToggle<cr>', opts({ desc = 'Toggle copilot-chat' }))
map.set({ 'v' }, 'gpt', ':CopilotChat', opts({ silent = false, desc = 'Copilot chat' }))
-- Custom buffer for CopilotChat
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "copilot-*",
    callback = function()
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true

        -- insert at the end to chat with Copilot
        vim.api.nvim_buf_set_keymap(0, 'n', 'i', 'Gi', opts())
        -- q for stop the chat
        vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<cmd>CopilotChatStop<cr>', opts())

        -- Get current filetype and set it to markdown if the current filetype is copilot-chat
        local ft = vim.bo.filetype
        if ft == "copilot-chat" then
            vim.bo.filetype = "markdown"
        end
    end,
})


function GetRootDirectory()
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

function NvimTreeToggleOnRootDirectory()
    require('nvim-tree.api').tree.toggle({
        path = GetRootDirectory(),
        update_root = false,
        find_file = false,
        focus = true,
    })
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
            path = GetRootDirectory(),
            update_root = false,
            find_file = false,
            focus = false,
        })
        -- must be a non-exist named file
    elseif not directory and #vim.v.argv == 3 then
        require('nvim-tree.api').tree.toggle({
            path = GetRootDirectory(),
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

function CompileRun()
    -- ignore the error
    -- this usually happens on readonly file
    pcall(vim.cmd, 'silent w')
    local fullpath = vim.fn.expand('%:p')
    local directory = vim.fn.fnamemodify(fullpath, ':h')
    local filename = vim.fn.fnamemodify(fullpath, ':t')
    local filename_noext = vim.fn.fnamemodify(fullpath, ':t:r')
    local command = ""
    if vim.bo.filetype == 'c' then
        command = string.format(
            'cd %s && gcc -g -Wall %s -I include -o %s.out && echo RUNNING && time ./%s.out',
            directory, filename, filename_noext, filename_noext)
    elseif vim.bo.filetype == 'cpp' then
        command = string.format(
            'cd %s && g++ -g -Wall -std=c++17 -I include %s -o %s.out && echo RUNNING && time ./%s.out',
            directory, filename, filename_noext, filename_noext)
    elseif vim.bo.filetype == 'java' then
        command = string.format(
            'cd %s && javac %s && echo RUNNING && time java %s',
            directory, filename, filename_noext)
    elseif vim.bo.filetype == 'sh' then
        command = string.format('cd %s && time ./%s', directory, filename)
    elseif vim.bo.filetype == 'python' then
        command = string.format('cd %s && time python3 %s', directory, filename)
    elseif vim.bo.filetype == 'html' then
        command = string.format('cd %s && wslview %s &', directory, filename)
    elseif vim.bo.filetype == 'lua' then
        command = string.format('cd %s && lua %s', directory, filename)
    elseif vim.bo.filetype == 'tex' then
        autoFollow = false
        toggleVimtexCursorFollow()
        vim.api.nvim_command('VimtexView')
        return
    elseif vim.bo.filetype == 'markdown' then
        vim.api.nvim_command('MarkdownPreviewToggle')
        return
    elseif vim.bo.filetype == 'vimwiki' then
        vim.api.nvim_command('MarkdownPreviewToggle')
        return
    elseif vim.bo.filetype == 'gitcommit' then
        vim.api.nvim_command('MarkdownPreviewToggle')
        return
    end
    if command == "" then
        vim.cmd 'echo "Unsupported filetype"'
        return
    end
    if not term_visible then
        ToggleTerm()
    end
    vim.api.nvim_set_current_win(getTermWinCurrentTab())
    feedkeys('G', 'n')
    local chan_id = vim.api.nvim_buf_get_var(term_buf, "terminal_job_id")
    vim.fn.chansend(chan_id, command .. "\n")
end

map.set({ 'n' }, '<leader>r', '<cmd>lua CompileRun()<cr>', opts({ desc = 'Compile run' }))

map.del({ 'n' }, '<c-w>d')
map.del({ 'n' }, '<c-w><c-d>')
map.set({ 'n' }, '<c-w>', '<cmd>Lspsaga outline<cr>', opts())
map.set({ 'i' }, '<c-w>', '<esc><cmd>Lspsaga outline<cr>', opts())

map.set({ 'n' }, '<c-e>', NvimTreeToggleOnRootDirectory, opts())
map.set({ 'i' }, '<c-e>', NvimTreeToggleOnRootDirectory, opts())

vim.cmd [[
" This function is copied from vimwiki
function! COPY_CR(normal, just_mrkr) abort
    let res = vimwiki#tbl#kbd_cr()
    if res !=? ''
        exe 'normal! ' . res . "\<Right>"
        startinsert
        return
    endif
    call vimwiki#lst#kbd_cr(a:normal, a:just_mrkr)
endfunction
autocmd FileType vimwiki,git*,markdown,copilot-chat inoremap <silent><buffer> <S-CR>
    \ <Esc>:call COPY_CR(2, 2)<CR>
]]
map.set({ 'n' }, '<leader>wh', '<cmd>VimwikiAll2HTML<cr>', opts({ desc = 'Vimwiki all to HTML' }))

local cmp = require 'cmp'
function CmpSelected()
    return cmp.get_active_entry() ~= nil
end

local copilot = require 'copilot.suggestion'
local _, fittencode = pcall(require, 'fittencode')
map.set({ 'c' }, '<c-j>', cmp.select_next_item, opts())
map.set({ 'c' }, '<c-k>', cmp.select_prev_item, opts())
-- TEST: the mapping for fittencode is not tested yet
map.set({ 'i' }, '<c-space>', function()
    if not DisableCopilot then
        if copilot.is_visible() then
            vim.b.copilot_suggestion_auto_trigger = false
            copilot.dismiss()
        else
            vim.b.copilot_suggestion_auto_trigger = true
            copilot.next()
        end
    else
        if fittencode.has_suggestions() then
            fittencode.enable_completions({ enable = false })
            fittencode.dismiss()
        else
            fittencode.enable_completions({ enable = true })
            fittencode.triggering_completion()
        end
    end
end, opts())
map.set({ 'i' }, '<esc>f', copilot.accept_word, opts())
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
map.set({ 'i' }, '<c-c>', function()
    if CmpSelected() then
        cmp.abort()
    elseif cmp.visible() then
        cmp.abort()
        if not DisableCopilot then
            copilot.dismiss()
        else
            fittencode.dismiss()
        end
    elseif not DisableCopilot and copilot.is_visible() then
        copilot.dismiss()
    elseif DisableCopilot and fittencode.has_suggestions() then
        fittencode.dismiss()
    else
        feedkeys("<c-\\><c-n>", 'i')
    end
end, opts({ silent = false }))
if not DisableCopilot then
    vim.cmd [[
    inoremap <silent><expr> <CR>
        \ luaeval('CmpSelected()') ?
        \ '<cmd>lua require"cmp".confirm()<cr>' :
        \ luaeval('require"copilot.suggestion".is_visible()') ?
        \ '<cmd>lua require"copilot.suggestion".accept()<cr>' :
        \ '<C-g>u<CR><C-r>=AutoPairsReturn()<CR>'
    autocmd FileType vimwiki,git*,markdown,copilot-chat
        \ inoremap <silent><script><buffer><expr> <CR>
        \ luaeval('CmpSelected()') ?
        \ '<cmd>lua require"cmp".confirm()<cr>' :
        \ luaeval('require"copilot.suggestion".is_visible()') ?
        \ '<cmd>lua require"copilot.suggestion".accept()<cr>' :
        \ '<C-]><Esc>:call COPY_CR(3, 5)<CR>'
    ]]
else
    vim.cmd [[
    inoremap <silent><expr> <CR>
        \ luaeval('CmpSelected()') ?
        \ '<cmd>lua require"cmp".confirm()<cr>' :
        \ luaeval('require("fittencode").has_suggestions()') ?
        \ '<cmd>lua require("fittencode").accept_all_suggestions()<cr>' :
        \ '\<C-g>u\<CR><C-r>=AutoPairsReturn()\<cr>'
    autocmd FileType vimwiki,git*,markdown,copilot-chat
        \ inoremap <silent><script><buffer><expr> <CR>
        \ luaeval('CmpSelected()') ?
        \ '<cmd>lua require"cmp".confirm()<cr>' :
        \ luaeval('require("fittencode").has_suggestions()') ?
        \ '<cmd>lua require("fittencode").accept_all_suggestions()<cr>' :
        \ '<C-]><Esc>:call COPY_CR(3, 5)<CR>'
    ]]
end

-- TODO: update this with nvim-cmp
-- map.set("n", "gcl", "<Plug>(coc-codelens-action)", opts)

local telescope = require 'telescope.builtin'
function FindFilesOnRootDirectory()
    telescope.find_files({ search_dirs = { GetRootDirectory() }, hidden = true })
end

function LiveGrepOnRootDirectory()
    telescope.live_grep({ search_dirs = { GetRootDirectory() }, additional_args = { '--hidden', } })
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
            path = GetRootDirectory(),
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

vim.cmd [[
" find next placeholder and remove it.
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,f <Esc>/<++><CR>:nohlsearch<CR>c4l

" bold
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,b ****<++><Esc>F*hi

" italic
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,i **<++><Esc>F*i

" for code blocks
autocmd Filetype git*,markdown,copilot-chat
    \ inoremap<buffer> ,c <CR><CR>```<CR>```<CR><CR><++><Esc>3kA

" for pictures, mostly, we don't add pictures' descriptions
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,p <CR><CR>![]()<CR><CR><++><Esc>2k0f(a

" for for links <a> are html links tag, so we use ,a
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,a [](<++>)<++><Esc>F[a

" for headers
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,1 #<Space>
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,2 ##<Space>
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,3 ###<Space>
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,4 ####<Space>

" delete lines
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,d ~~~~<++><Esc>F~hi

" tilde
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,t ``<++><Esc>F`i

" math formulas
autocmd Filetype git*,markdown,copilot-chat
    \ inoremap<buffer> ,M <CR><CR>$$<CR><CR>$$<CR><CR><++><Esc>3kA

" math formulas in line
autocmd Filetype git*,markdown,copilot-chat inoremap<buffer> ,m $$<++><Esc>F$i

" newline but not new paragraph
autocmd FileType git*,markdown,copilot-chat inoremap<buffer> ,n <br><CR>

autocmd FileType git* set cc=50,72

autocmd Filetype git*,markdown,copilot-chat setlocal spell
]]
