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
    require('plugins.lazy_dev'),
    require('plugins.lsp_config'),
    require('plugins.lsp_saga'),
    require('plugins.mason'),
    require('plugins.mason_lsp_config'),
    require('plugins.nvim_java'),
    require('plugins.ufo'),

    require('plugins.blink_cmp'),
    require('plugins.formatter'),

    -- Git
    require('plugins.git_signs'),
    require('plugins.git_conflict'),
    require('plugins.octo'),

    -- AI
    require('plugins.copilot'),
    require('plugins.avante'),


    require('plugins.auto_pairs'),
    require('plugins.auto_save'),
    require('plugins.auto_session'),
    require('plugins.auto_tag'),
    require('plugins.buffer_line'),
    require('plugins.comment'),
    require('plugins.snacks'),
    require('plugins.surround'),
    require('plugins.which_key'),
    require('plugins.win_resizer'),
    require('plugins.yanky'),

}
