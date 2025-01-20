local get_browser_available = function()
    local browser_list = {
        'microsoft-edge-stable',
    }
    for _, browser in ipairs(browser_list) do
        if vim.fn.executable(browser) == 1 then
            return browser
        end
    end
    return ''
end
return {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = vim.g.markdown_support_filetype,
    init = function()
        vim.g.mkdp_browser = get_browser_available()
        vim.g.mkdp_auto_close = 0
        vim.g.mkdp_filetypes = vim.g.markdown_support_filetype
        local map_set = require('utils').map_set
        vim.api.nvim_create_autocmd('FileType', {
            pattern = vim.g.markdown_support_filetype,
            group = 'UserDIY',
            callback = function()
                map_set({ 'n' }, '<leader>r', '<cmd>MarkdownPreview<cr>',
                    { desc = 'Compile and run', buffer = true })
            end
        })
    end,
}
