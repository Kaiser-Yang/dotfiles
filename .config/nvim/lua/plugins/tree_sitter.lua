-- TODO:
-- enable ts automatically??
-- Now we can use <leader>ts to toggle treesitter
--
-- vim.api.nvim_create_autocmd('FileType', {
--     pattern = '*', -- WARN: update this to only the filetypes you want
--     callback = function()
--         vim.treesitter.start()
--         vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
--         vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--     end,
-- })
local function text_objects_select_wrapper(query_string, query_group)
    return function()
        require('nvim-treesitter-textobjects.select').select_textobject(query_string, query_group)
    end
end
--- @param direction 'next'|'previous'
local function text_objects_swap_wrapper(direction, query_string)
    return function()
        require('nvim-treesitter-textobjects.swap')['swap_' .. direction](query_string)
    end
end

--- @param direction 'next'|'previous'
--- @param position 'start'|'end'|''
local function text_objects_move_wrapper(direction, position, query_string)
    return function()
        require('nvim-treesitter-textobjects.move')['goto_' .. direction .. '_' .. position](
            query_string
        )
    end
end
local comma_semicolon = require('comma_semicolon')
-- HACK:
-- This below can not cycle
local prev_function_start, next_function_start = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'start', '@function.outer'),
    text_objects_move_wrapper('next', 'start', '@function.outer')
)
local prev_class_start, next_class_start = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'start', '@class.outer'),
    text_objects_move_wrapper('next', 'start', '@class.outer')
)
local prev_loop_start, next_loop_start = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'start', '@loop.outer'),
    text_objects_move_wrapper('next', 'start', '@loop.outer')
)
local prev_block_start, next_block_start = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'start', '@block.outer'),
    text_objects_move_wrapper('next', 'start', '@block.outer')
)
local prev_return_start, next_return_start = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'start', '@return.outer'),
    text_objects_move_wrapper('next', 'start', '@return.outer')
)
local prev_parameter_start, next_parameter_start = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'start', '@parameter.inner'),
    text_objects_move_wrapper('next', 'start', '@parameter.inner')
)
local prev_if_start, next_if_start = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'start', '@conditional.outer'),
    text_objects_move_wrapper('next', 'start', '@conditional.outer')
)
local prev_function_end, next_function_end = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'end', '@function.outer'),
    text_objects_move_wrapper('next', 'end', '@function.outer')
)
local prev_class_end, next_class_end = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'end', '@class.outer'),
    text_objects_move_wrapper('next', 'end', '@class.outer')
)
local prev_loop_end, next_loop_end = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'end', '@loop.outer'),
    text_objects_move_wrapper('next', 'end', '@loop.outer')
)
local prev_block_end, next_block_end = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'end', '@block.outer'),
    text_objects_move_wrapper('next', 'end', '@block.outer')
)
local prev_return_end, next_return_end = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'end', '@return.outer'),
    text_objects_move_wrapper('next', 'end', '@return.outer')
)
local prev_parameter_end, next_parameter_end = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'end', '@parameter.inner'),
    text_objects_move_wrapper('next', 'end', '@parameter.inner')
)
local prev_if_end, next_if_end = comma_semicolon.make(
    text_objects_move_wrapper('previous', 'end', '@conditional.outer'),
    text_objects_move_wrapper('next', 'end', '@conditional.outer')
)
return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            branch = 'main',
            opts = {
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            },
        },
        {
            'nvim-treesitter/nvim-treesitter-context',
            opts = {
                max_lines = 3,
                on_attach = function(buf)
                    vim.b[buf].matchup_matchparen_enabled = 0
                    return true
                end,
            },
        },
    },
    event = 'VeryLazy',
    -- HACK:
    -- Those below only work for c if and c af can not work for ci f and ca f
    keys = {
        {
            'af',
            text_objects_select_wrapper('@function.outer'),
            desc = 'Select around function',
            mode = { 'x', 'o' },
        },
        {
            'if',
            text_objects_select_wrapper('@function.inner'),
            desc = 'Select inside function',
            mode = { 'x', 'o' },
        },
        {
            'ac',
            text_objects_select_wrapper('@class.outer'),
            mode = { 'x', 'o' },
            desc = 'Select around class',
        },
        {
            'ic',
            text_objects_select_wrapper('@class.inner'),
            mode = { 'x', 'o' },
            desc = 'Select inside class',
        },
        {
            'ab',
            text_objects_select_wrapper('@block.outer'),
            mode = { 'x', 'o' },
            desc = 'Select around block',
        },
        {
            'ib',
            text_objects_select_wrapper('@block.inner'),
            mode = { 'x', 'o' },
            desc = 'Select inside block',
        },
        {
            'ai',
            text_objects_select_wrapper('@conditional.outer'),
            mode = { 'x', 'o' },
            desc = 'Select around if',
        },
        {
            'ii',
            text_objects_select_wrapper('@conditional.inner'),
            mode = { 'x', 'o' },
            desc = 'Select inside if',
        },
        {
            'al',
            text_objects_select_wrapper('@loop.outer'),
            mode = { 'x', 'o' },
            desc = 'Select around loop',
        },
        {
            'il',
            text_objects_select_wrapper('@loop.inner'),
            mode = { 'x', 'o' },
            desc = 'Select inside loop',
        },
        {
            'ar',
            text_objects_select_wrapper('@return.outer'),
            mode = { 'x', 'o' },
            desc = 'Select around return',
        },
        {
            'ir',
            text_objects_select_wrapper('@return.inner'),
            mode = { 'x', 'o' },
            desc = 'Select inside return',
        },
        {
            'ap',
            text_objects_select_wrapper('@parameter.outer'),
            mode = { 'x', 'o' },
            desc = 'Select around parameter',
        },
        {
            'ip',
            text_objects_select_wrapper('@parameter.inner'),
            mode = { 'x', 'o' },
            desc = 'Select inside parameter',
        },
        {
            'snf',
            text_objects_swap_wrapper('next', '@function.outer'),
            desc = 'Swap with next function',
        },
        {
            'snc',
            text_objects_swap_wrapper('next', '@class.outer'),
            desc = 'Swap with next class',
        },
        {
            'snl',
            text_objects_swap_wrapper('next', '@loop.outer'),
            desc = 'Swap with next loop',
        },
        {
            'snb',
            text_objects_swap_wrapper('next', '@block.outer'),
            desc = 'Swap with next block',
        },
        {
            'snr',
            text_objects_swap_wrapper('next', '@return.outer'),
            desc = 'Swap with next return',
        },
        {
            'snp',
            text_objects_swap_wrapper('next', '@parameter.inner'),
            desc = 'Swap with next parameter',
        },
        {
            'sni',
            text_objects_swap_wrapper('next', '@conditional.outer'),
            desc = 'Swap with next if',
        },
        {
            'spf',
            text_objects_swap_wrapper('previous', '@function.outer'),
            desc = 'Swap with previous function',
        },
        {
            'spc',
            text_objects_swap_wrapper('previous', '@class.outer'),
            desc = 'Swap with previous class',
        },
        {
            'spl',
            text_objects_swap_wrapper('previous', '@loop.outer'),
            desc = 'Swap with previous loop',
        },
        {
            'spb',
            text_objects_swap_wrapper('previous', '@block.outer'),
            desc = 'Swap with previous block',
        },
        {
            'spr',
            text_objects_swap_wrapper('previous', '@return.outer'),
            desc = 'Swap with previous return',
        },
        {
            'spp',
            text_objects_swap_wrapper('previous', '@parameter.inner'),
            desc = 'Swap with previous parameter',
        },
        {
            'spi',
            text_objects_swap_wrapper('previous', '@conditional.outer'),
            desc = 'Swap with previous if',
        },
        {
            '[f',
            prev_function_start,
            desc = 'Previous function start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']f',
            next_function_start,
            desc = 'Next function start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[c',
            prev_class_start,
            desc = 'Previous class start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']c',
            next_class_start,
            desc = 'Next class start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[l',
            prev_loop_start,
            desc = 'Previous loop start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']l',
            next_loop_start,
            desc = 'Next loop start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[b',
            prev_block_start,
            desc = 'Previous block start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']b',
            next_block_start,
            desc = 'Next block start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[r',
            prev_return_start,
            desc = 'Previous return start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']r',
            next_return_start,
            desc = 'Next return start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[p',
            prev_parameter_start,
            desc = 'Previous parameter start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']p',
            next_parameter_start,
            desc = 'Next parameter start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[i',
            prev_if_start,
            desc = 'Previous if start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']i',
            next_if_start,
            desc = 'Next if start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[F',
            prev_function_end,
            desc = 'Previous function end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']F',
            next_function_end,
            desc = 'Next function end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[C',
            prev_class_end,
            desc = 'Previous class end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']C',
            next_class_end,
            desc = 'Next class end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[L',
            prev_loop_end,
            desc = 'Previous loop end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']L',
            next_loop_end,
            desc = 'Next loop end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[B',
            prev_block_end,
            desc = 'Previous block end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']B',
            next_block_end,
            desc = 'Next block end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[R',
            prev_return_end,
            desc = 'Previous return end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']R',
            next_return_end,
            desc = 'Next return end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[P',
            prev_parameter_end,
            desc = 'Previous parameter end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']P',
            next_parameter_end,
            desc = 'Next parameter end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[I',
            prev_if_end,
            desc = 'Previous if end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']I',
            next_if_end,
            desc = 'Next if end',
            mode = { 'n', 'x', 'o' },
        },
    },
}
