vim.g.copilot_no_maps = true
if DisableCopilot then
    vim.cmd[[    
    let g:copilot_filetypes = { '*': v:false }
    ]]
end
