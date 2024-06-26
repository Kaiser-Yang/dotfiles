require'bufferline'.setup {
    options = {
        -- mode = 'tabs',
        numbers = 'ordinal',
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
      },
--     separator_style = "slope",
--     buffer_close_icon = plain and 'x' or nil,
--     modified_icon = plain and '*' or nil,
--     close_icon = plain and 'x' or nil,
--     left_trunc_marker = plain and '<' or nil,
--     right_trunc_marker = plain and '>' or nil,
    offsets = {
        {
            filetype = "aerial",
            text = "File Outlook",
            highlight = "Directory",
            text_align = "left",
            separator = true
        },
        {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            separator = true
        },
    },
    close_command = function(bufnum)
        -- when closing some files, this function will throw a exception
        -- I don't know how to fix, just ignore this exception
        pcall(require('bufdelete').bufdelete, bufnum, true)
    end,
    diagnostics = "coc",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local s = " "
        for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " " or (e == "warning" and " " or "" )
            s = s .. n .. sym
        end
        return s
    end,
--     sort_by = 'insert_after_current',
--     custom_filter = function(buf_number, buf_numbers)
--       -- filter out filetypes you don't want to see
--       if vim.bo[buf_number].filetype == "qf" then
--         return false
--       end
--       if vim.bo[buf_number].buftype == "terminal" then
--         return false
--       end
--       if vim.bo[buf_number].buftype == "nofile" then
--         return false
--       end
--       if vim.bo[buf_number].filetype == "Trouble" then
--         return false
--       end
--       -- if string.find(vim.fn.bufname(buf_number), 'term://') == 1 then
--       --     return false
--       -- end
--       return true
--     end,
    }
}

-- local function close_empty_noname_buffers()
--   local current_buf = vim.api.nvim_get_current_buf()
--   local buffers = vim.api.nvim_list_bufs()
--
--   for _, buf in ipairs(buffers) do
--     if buf ~= current_buf then
--       local name = vim.api.nvim_buf_get_name(buf)
--       local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--       if #lines == 1 and lines[1] == "" and name == "" then
--         vim.api.nvim_buf_delete(buf, { force = true })
--       end
--     end
--   end
-- end
--
-- vim.api.nvim_create_autocmd("BufEnter", {
--   callback = close_empty_noname_buffers
-- })
-- local function BufferEmpty(bufnr)
--   local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
--   return #lines == 1 and #lines[1] == 0
-- end
--
-- local function NonameBuffer(bufnr)
--   local bufname = vim.api.nvim_buf_get_name(bufnr)
--   return bufname == ""
-- end
--
-- local function CloseEmptyNonameBuffers()
--   local buffers = vim.api.nvim_list_bufs()
--
--   for _, bufnr in ipairs(buffers) do
--     if BufferEmpty(bufnr) and NonameBuffer(bufnr) then
--       vim.api.nvim_buf_delete(bufnr, { force = true })
--     end
--   end
-- end
--
-- vim.api.nvim_create_autocmd({"BufReadPost"}, {
--     callback = function (data)
--         CloseEmptyNonameBuffers()
--     end,
-- })
-- vim.cmd([[
--   augroup CloseEmptyNonameBuffers
--     autocmd!
--     autocmd BufEnter * lua CloseEmptyNonameBuffers()
--   augroup END
-- ]])

-- vim.cmd [[
-- aug buffer_accessed_time
--   au!
--   au BufEnter,BufWinEnter * let b:accessedtime = localtime()
-- aug END
--
-- function! BufferLineSortByMRU()
--   lua require'bufferline'.sort_buffers_by(function(a, b) return (vim.b[a.id].accessedtime or 0) > (vim.b[b.id].accessedtime or 0) end)
-- endfunction
--
-- command -nargs=0 BufferLineSortByMRU call BufferLineSortByMRU()
-- ]]

