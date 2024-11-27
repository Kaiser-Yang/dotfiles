local bufferline = require'bufferline'
bufferline.setup {
    options = {
        numbers = 'ordinal',
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },
        -- separator_style = "slope",
        -- buffer_close_icon = plain and 'x' or nil,
        -- modified_icon = plain and '*' or nil,
        -- close_icon = plain and 'x' or nil,
        -- left_trunc_marker = plain and '<' or nil,
        -- right_trunc_marker = plain and '>' or nil,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
                separator = true
            },
            -- INFO: this is not used
            -- {
            --     filetype = "aerial",
            --     text = "File Outlook",
            --     highlight = "Directory",
            --     text_align = "left",
            --     separator = true
            -- },
            -- INFO: put sagaoutline at left will cause problem, there is no need to configure this
            -- {
            --     filetype = "sagaoutline",
            --     text = "File Outline",
            --     highlight = "Directory",
            --     text_align = "left",
            --     separator = true
            -- },
        },
        close_command = function(bufnum)
            -- when closing some files, this function will throw a exception
            -- I don't know how to fix, just ignore this exception
            pcall(require('bufdelete').bufdelete, bufnum, true)
        end,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " " or (e == "warning" and " " or "" )
                s = s .. n .. sym
            end
            return s
        end,
        sort_by = 'insert_after_current',
    }
}
