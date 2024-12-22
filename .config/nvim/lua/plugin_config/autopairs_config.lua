vim.g.AutoPairsShortcutBackInsert = '<c-b>'
-- We map this manually in key_mapping.lua
vim.g.AutoPairsMapCR = 0
vim.g.AutoPairsMapSpace = 1
vim.g.AutoPairsMapCh = 0
vim.g.AutoPairsMapBS = 1
vim.g.AutoPairsCenterLine = 0
vim.api.nvim_create_autocmd('Filetype', {
    pattern = '*Prompt',
    callback = function()
        vim.b.autopairs_enabled = 0
    end
})
-- vim.cmd [[autocmd Filetype vim let b:AutoPairs = {'(':')', '[':']', '{':'}', "`":"`", '```':'```', '"""':'"""'}]]
