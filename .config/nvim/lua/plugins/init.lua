local utils = require('utils')
local plugins = {
    -- Not lazy loaded plugins
    require('plugins.color_scheme'),
    require('plugins.mason'),
    require('plugins.auto_session'),
    require('plugins.lua_line'),
    require('plugins.vim_matchup'),
    require('plugins.lsp_config'), -- PERF: large files performance issue
    require('plugins.tree_sitter'), -- PERF: large files performance issue

    -- VeryLazy event plugins
    require('plugins.noice'),
    require('plugins.todo_comments'),
    require('plugins.auto_save'),
    require('plugins.buffer_line'),
    require('plugins.guess_indent'),
    require('plugins.which_key'),
    require('plugins.statuscol'),
    require('plugins.snacks_config'), -- PERF: some pickers has performance issues
    require('plugins.ufo'), -- PERF: large files performance issue
    require('plugins.rainbow_delimiter'), -- PERF: large files performance issue

    -- Lazy loaded plugins
    require('plugins.explorer'),
    require('plugins.blink_cmp'),
    require('plugins.formatter'),
    require('plugins.auto_pairs'),
    require('plugins.win_resizer'),
    require('plugins.markdown_toc'),
    require('plugins.non_ascii'),
    require('plugins.img_clip'),
    require('plugins.jobs'),
    require('plugins.debugger'),
    require('plugins.lsp_saga'),
    require('plugins.yanky'),
    require('plugins.comment'),
    require('plugins.nvim_jdtls'),
    require('plugins.action_preview'),
    require('plugins.surround'),
    require('plugins.auto_tag'), -- PERF: disabled in large files
    require('plugins.highlight_colors'), -- PERF: disabled in large files
    require('plugins.search'), -- PERF: disabled in large files
    require('plugins.markdown_render'), -- PERF: may have performance issues with large files
}
if utils.is_git_repo() then
    vim.list_extend(plugins, {
        -- VeryLazy event plugins
        require('plugins.git_conflict'),
        require('plugins.git_signs'),
    })
end
if vim.fn.executable('gh') == 1 then
    vim.list_extend(plugins, {
        -- Loaded when UserGettingBored
        require('plugins.octo'),
    })
end
if vim.fn.has('mac') ~= 1 then
    if vim.fn.executable('node') == 1 then
        -- WARN: not check if those plugins have performance issues
        vim.list_extend(plugins, {
            -- Loaded when NetworkCheckedOK
            require('plugins.avante'),
            require('plugins.copilot'),
        })
    end
end
return plugins
