local utils = require('utils')
local plugins = {
    require('plugins.color_scheme'),
    require('plugins.explorer'),
    require('plugins.lua_line'),
    require('plugins.noice'),
    require('plugins.todo_comments'),
    require('plugins.lsp_config'),
    require('plugins.mason'),
    require('plugins.mason_lsp_config'),
    require('plugins.blink_cmp'),
    require('plugins.formatter'),
    require('plugins.auto_pairs'),
    require('plugins.auto_save'),
    require('plugins.auto_session'),
    require('plugins.buffer_line'),
    require('plugins.comment'),
    require('plugins.guess_indent'),
    require('plugins.surround'),
    require('plugins.which_key'),
    require('plugins.win_resizer'),
    require('plugins.non_ascii'),
    require('plugins.ufo'),
    require('plugins.img_clip'),
    require('plugins.markdown_toc'),
    require('plugins.highlight_colors'),
    require('plugins.vim_matchup'),
    require('plugins.lsp_saga'),
    require('plugins.jobs'),
    require('plugins.debugger'),
    require('plugins.nvim_jdtls'),
    require('plugins.action_preview'),
    -- INFO:
    -- Those plugins may cause performance problems
    -- require('plugins.rainbow_delimiter'),
    -- require('plugins.tree_sitter'),
    require('plugins.auto_tag'),
    require('plugins.yanky'),
    require('plugins.search'),
    require('plugins.markdown_render'),
    require('plugins.snacks_config'),
}
if vim.fn.has('mac') ~= 1 then
    if vim.fn.executable('node') == 1 and utils.network_available() then
        vim.list_extend(plugins, {
            require('plugins.avante'),
        })
    end
end
if utils.is_git_repo() then
    vim.list_extend(plugins, {
        require('plugins.git_conflict'),
        require('plugins.git_signs'),
    })
    if
        vim.fn.executable('gh') == 1
        and utils.get_repo_remote_url():find('github.com')
        and utils.network_available()
    then
        vim.list_extend(plugins, {
            require('plugins.octo'),
        })
    end
end
return plugins
