require('fittencode').setup({
    action = {
        document_code = {
            -- Show "Fitten Code - Document Code" in the editor context menu, when you right-click on the code.
            show_in_editor_context_menu = true,
        },
        edit_code = {
            -- Show "Fitten Code - Edit Code" in the editor context menu, when you right-click on the code.
            show_in_editor_context_menu = true,
        },
        explain_code = {
            -- Show "Fitten Code - Explain Code" in the editor context menu, when you right-click on the code.
            show_in_editor_context_menu = true,
        },
        find_bugs = {
            -- Show "Fitten Code - Find Bugs" in the editor context menu, when you right-click on the code.
            show_in_editor_context_menu = true,
        },
        generate_unit_test = {
            -- Show "Fitten Code - Generate UnitTest" in the editor context menu, when you right-click on the code.
            show_in_editor_context_menu = true,
        },
        start_chat = {
            -- Show "Fitten Code - Start Chat" in the editor context menu, when you right-click on the code.
            show_in_editor_context_menu = true,
        },
        identify_programming_language = {
            -- Identify programming language of the current buffer
            -- * Unnamed buffer
            -- * Buffer without file extension
            -- * Buffer no filetype detected
            identify_buffer = true,
        }
    },
    disable_specific_inline_completion = {
        -- Disable auto-completion for some specific file suffixes by entering them below
        -- For example, `suffixes = {'lua', 'cpp'}`
        -- Use fittencode as chat, but not as a inline completion for all buffers.
        suffixes = {'TelescopePrompt'},
    },
    inline_completion = {
        -- Enable inline code completion.
        ---@type boolean
        -- Use fittencode as chat, but not as a inline completion for all buffers.
        enable = CopilotDisable,
        -- Disable auto completion when the cursor is within the line.
        ---@type boolean
        disable_completion_within_the_line = false,
        -- Disable auto completion when pressing Backspace or Delete.
        ---@type boolean
        disable_completion_when_delete = false,
        -- Auto triggering completion
        ---@type boolean
        auto_triggering_completion = true,
        -- Accept Mode
        -- Available options:
        -- * `commit` (VSCode style accept, also default)
        --     - `Tab` to Accept all suggestions
        --     - `Ctrl+Right` to Accept word
        --     - `Ctrl+Down` to Accept line
        --     - Interrupt
        --            - Enter a different character than suggested
        --            - Exit insert mode
        --            - Move the cursor
        -- * `stage` (Stage style accept)
        --     - `Tab` to Accept all staged characters
        --     - `Ctrl+Right` to Stage word
        --     - `Ctrl+Left` to Revoke word
        --     - `Ctrl+Down` to Stage line
        --     - `Ctrl+Up` to Revoke line
        --     - Interrupt(Same as `commit`, but with the following changes:)
        --            - Characters that have already been staged will be lost.
        accept_mode = 'commit',
    },
    delay_completion = {
        -- Delay time for inline completion (in milliseconds).
        ---@type integer
        delaytime = 0,
    },
    prompt = {
        -- Maximum number of characters to prompt for completion/chat.
        max_characters = 1000000,
    },
    chat = {
        -- Highlight the conversation in the chat window at the current cursor position.
        highlight_conversation_at_cursor = false,
        -- Style
        -- Available options:
        -- * `sidebar` (Siderbar style, also default)
        -- * `floating` (Floating style)
        style = 'sidebar',
        sidebar = {
            -- Width of the sidebar in characters.
            width = 42,
            -- Position of the sidebar.
            -- Available options:
            -- * `left`
            -- * `right`
            -- if it is in left, we must go back back pressing <c-l> two times
            position = 'right',
        },
        floating = {
            -- Border style of the floating window.
            -- Same border values as `nvim_open_win`.
            border = 'rounded',
            -- Size of the floating window.
            -- <= 1: percentage of the screen size
            -- >    1: number of lines/columns
            size = { width = 0.8, height = 0.8 },
        }
    },
    -- Enable/Disable the default keymaps in inline completion.
    use_default_keymaps = false,
    -- Default keymaps
    keymaps = {
        inline = {
            ['<C-Down>'] = 'accept_line',
            ['<esc>f'] = 'accept_word',
            ['<C-Right>'] = 'accept_word',
            ['<C-Up>'] = 'revoke_line',
            ['<C-Left>'] = 'revoke_word',
        },
        chat = {
            ['q'] = 'close',
            ['Q'] = 'close',
            ['[c'] = 'goto_previous_conversation',
            [']c'] = 'goto_next_conversation',
            ['c'] = 'copy_conversation',
            ['C'] = 'copy_all_conversations',
            ['d'] = 'delete_conversation',
            ['D'] = 'delete_all_conversations',
        }
    },
    -- Setting for source completion.
    source_completion = {
        -- Enable source completion.
        enable = true,
    },
    -- Set the mode of the completion.
    -- Available options:
    -- * 'inline' (VSCode style inline completion)
    -- * 'source' (integrates into other completion plugins)
    -- TODO: Now not support for coc, wait this feature
    completion_mode = 'inline',
    ---@class LogOptions
    log = {
        -- Log level.
        level = vim.log.levels.WARN,
        -- Max log file size in MB, default is 10MB
        max_size = 10,
    },
})
