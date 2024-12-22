utils = {}

--- @param keys string
--- @param mode string
function utils.feedkeys(keys, mode)
    local termcodes = vim.api.nvim_replace_termcodes(keys, true, true, true)
    vim.api.nvim_feedkeys(termcodes, mode, false)
end

--- @param extended_opts table | nil
function utils.keymap_opts(extended_opts)
    local default_opts = {
        silent = true,
        remap = false,
    }
    return vim.tbl_extend('force', default_opts, extended_opts or {})
end

return utils
