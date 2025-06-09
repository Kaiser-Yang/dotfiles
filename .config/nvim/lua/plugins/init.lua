return {
    -- Appearance
    require('plugins.color_scheme'),
    require('plugins.explorer'),
    require('plugins.lua_line'),
    require('plugins.noice'),
    require('plugins.rainbow_delimiter'),
    require('plugins.todo_comments'),
    require('plugins.tree_sitter'),

    -- LSP
    require('plugins.lsp_config'),
    require('plugins.lsp_saga'),
    require('plugins.mason'),
    require('plugins.mason_lsp_config'),
    require('plugins.ufo'),

    require('plugins.blink_cmp'),
    require('plugins.debugger'),
    require('plugins.formatter'),

    -- Git
    require('plugins.git_signs'),
    require('plugins.git_conflict'),
    require('plugins.octo'),

    -- AI
    require('plugins.copilot'),
    require('plugins.avante'),

    require('plugins.img_clip'),
    require('plugins.markdown_toc'),
    require('plugins.markdown_render'),

    require('plugins.auto_pairs'),
    require('plugins.auto_save'),
    require('plugins.auto_session'),
    require('plugins.auto_tag'),
    require('plugins.buffer_line'),
    require('plugins.comment'),
    require('plugins.guess_indent'),
    require('plugins.highlight_colors'),
    require('plugins.search'),
    require('plugins.snacks_config'),
    require('plugins.surround'),
    require('plugins.which_key'),
    require('plugins.win_resizer'),
    require('plugins.yanky'),
    require('plugins.zh_nvim')
}
