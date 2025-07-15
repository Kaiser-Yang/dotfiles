local utils = require('utils')
local plugins = {
    require('plugins.color_scheme'),
    require('plugins.explorer'),
    require('plugins.lua_line'),
    require('plugins.noice'),
    require('plugins.rainbow_delimiter'),
    require('plugins.todo_comments'),
    require('plugins.tree_sitter'),
    require('plugins.lsp_config'),
    require('plugins.lsp_saga'),
    require('plugins.mason'),
    require('plugins.mason_lsp_config'),
    require('plugins.blink_cmp'),
    require('plugins.formatter'),
    require('plugins.git_signs'),
    require('plugins.auto_pairs'),
    require('plugins.auto_save'),
    require('plugins.auto_session'),
    require('plugins.auto_tag'),
    require('plugins.buffer_line'),
    require('plugins.comment'),
    require('plugins.guess_indent'),
    require('plugins.search'),
    require('plugins.snacks_config'),
    require('plugins.surround'),
    require('plugins.which_key'),
    require('plugins.win_resizer'),
    require('plugins.yanky'),
    require('plugins.non_ascii'),
    require('plugins.ufo'),
    require('plugins.debugger'),
    require('plugins.img_clip'),
    require('plugins.markdown_toc'),
    require('plugins.markdown_render'),
    require('plugins.highlight_colors'),
}
if vim.fn.has('mac') ~= 1 then
    if vim.fn.executable('gh') == 1 then
        vim.list_extend(plugins, {
            require('plugins.octo'),
        })
    end
    if vim.fn.executable('node') == 1 and utils.network_available() then
        vim.list_extend(plugins, {
            require('plugins.copilot'),
            require('plugins.avante'),
        })
    end
end
if utils.is_git_repo() then vim.list_extend(plugins, {
    require('plugins.git_conflict'),
}) end
return plugins
