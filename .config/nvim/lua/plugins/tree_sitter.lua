-- TODO:
-- enable ts automatically??
-- Now we can use <leader>ts to toggle treesitter
--
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function(args)
        if require('utils').is_big_file(args.buf) then return end
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        pcall(vim.treesitter.start)
    end,
})
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
local big_file_checker_wrapper = require('utils').big_file_checker_wrapper
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
            big_file_checker_wrapper(text_objects_select_wrapper('@function.outer')),
            desc = 'Select around function',
            mode = { 'x', 'o' },
        },
        {
            'if',
            big_file_checker_wrapper(text_objects_select_wrapper('@function.inner')),
            desc = 'Select inside function',
            mode = { 'x', 'o' },
        },
        {
            'ac',
            big_file_checker_wrapper(text_objects_select_wrapper('@class.outer')),
            mode = { 'x', 'o' },
            desc = 'Select around class',
        },
        {
            'ic',
            big_file_checker_wrapper(text_objects_select_wrapper('@class.inner')),
            mode = { 'x', 'o' },
            desc = 'Select inside class',
        },
        {
            'ab',
            big_file_checker_wrapper(text_objects_select_wrapper('@block.outer')),
            mode = { 'x', 'o' },
            desc = 'Select around block',
        },
        {
            'ib',
            big_file_checker_wrapper(text_objects_select_wrapper('@block.inner')),
            mode = { 'x', 'o' },
            desc = 'Select inside block',
        },
        {
            'ai',
            big_file_checker_wrapper(text_objects_select_wrapper('@conditional.outer')),
            mode = { 'x', 'o' },
            desc = 'Select around if',
        },
        {
            'ii',
            big_file_checker_wrapper(text_objects_select_wrapper('@conditional.inner')),
            mode = { 'x', 'o' },
            desc = 'Select inside if',
        },
        {
            'al',
            big_file_checker_wrapper(text_objects_select_wrapper('@loop.outer')),
            mode = { 'x', 'o' },
            desc = 'Select around loop',
        },
        {
            'il',
            big_file_checker_wrapper(text_objects_select_wrapper('@loop.inner')),
            mode = { 'x', 'o' },
            desc = 'Select inside loop',
        },
        {
            'ar',
            big_file_checker_wrapper(text_objects_select_wrapper('@return.outer')),
            mode = { 'x', 'o' },
            desc = 'Select around return',
        },
        {
            'ir',
            big_file_checker_wrapper(text_objects_select_wrapper('@return.inner')),
            mode = { 'x', 'o' },
            desc = 'Select inside return',
        },
        {
            'ap',
            big_file_checker_wrapper(text_objects_select_wrapper('@parameter.outer')),
            mode = { 'x', 'o' },
            desc = 'Select around parameter',
        },
        {
            'ip',
            big_file_checker_wrapper(text_objects_select_wrapper('@parameter.inner')),
            mode = { 'x', 'o' },
            desc = 'Select inside parameter',
        },
        {
            'snf',
            big_file_checker_wrapper(text_objects_swap_wrapper('next', '@function.outer')),
            desc = 'Swap with next function',
        },
        {
            'snc',
            big_file_checker_wrapper(text_objects_swap_wrapper('next', '@class.outer')),
            desc = 'Swap with next class',
        },
        {
            'snl',
            big_file_checker_wrapper(text_objects_swap_wrapper('next', '@loop.outer')),
            desc = 'Swap with next loop',
        },
        {
            'snb',
            big_file_checker_wrapper(text_objects_swap_wrapper('next', '@block.outer')),
            desc = 'Swap with next block',
        },
        {
            'snr',
            big_file_checker_wrapper(text_objects_swap_wrapper('next', '@return.outer')),
            desc = 'Swap with next return',
        },
        {
            'snp',
            big_file_checker_wrapper(text_objects_swap_wrapper('next', '@parameter.inner')),
            desc = 'Swap with next parameter',
        },
        {
            'sni',
            big_file_checker_wrapper(text_objects_swap_wrapper('next', '@conditional.outer')),
            desc = 'Swap with next if',
        },
        {
            'spf',
            big_file_checker_wrapper(text_objects_swap_wrapper('previous', '@function.outer')),
            desc = 'Swap with previous function',
        },
        {
            'spc',
            big_file_checker_wrapper(text_objects_swap_wrapper('previous', '@class.outer')),
            desc = 'Swap with previous class',
        },
        {
            'spl',
            big_file_checker_wrapper(text_objects_swap_wrapper('previous', '@loop.outer')),
            desc = 'Swap with previous loop',
        },
        {
            'spb',
            big_file_checker_wrapper(text_objects_swap_wrapper('previous', '@block.outer')),
            desc = 'Swap with previous block',
        },
        {
            'spr',
            big_file_checker_wrapper(text_objects_swap_wrapper('previous', '@return.outer')),
            desc = 'Swap with previous return',
        },
        {
            'spp',
            big_file_checker_wrapper(text_objects_swap_wrapper('previous', '@parameter.inner')),
            desc = 'Swap with previous parameter',
        },
        {
            'spi',
            big_file_checker_wrapper(text_objects_swap_wrapper('previous', '@conditional.outer')),
            desc = 'Swap with previous if',
        },
        {
            '[f',
            big_file_checker_wrapper(prev_function_start),
            desc = 'Previous function start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']f',
            big_file_checker_wrapper(next_function_start),
            desc = 'Next function start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[c',
            big_file_checker_wrapper(prev_class_start),
            desc = 'Previous class start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']c',
            big_file_checker_wrapper(next_class_start),
            desc = 'Next class start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[l',
            big_file_checker_wrapper(prev_loop_start),
            desc = 'Previous loop start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']l',
            big_file_checker_wrapper(next_loop_start),
            desc = 'Next loop start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[b',
            big_file_checker_wrapper(prev_block_start),
            desc = 'Previous block start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']b',
            big_file_checker_wrapper(next_block_start),
            desc = 'Next block start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[r',
            big_file_checker_wrapper(prev_return_start),
            desc = 'Previous return start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']r',
            big_file_checker_wrapper(next_return_start),
            desc = 'Next return start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[p',
            big_file_checker_wrapper(prev_parameter_start),
            desc = 'Previous parameter start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']p',
            big_file_checker_wrapper(next_parameter_start),
            desc = 'Next parameter start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[i',
            big_file_checker_wrapper(prev_if_start),
            desc = 'Previous if start',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']i',
            big_file_checker_wrapper(next_if_start),
            desc = 'Next if start',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[F',
            big_file_checker_wrapper(prev_function_end),
            desc = 'Previous function end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']F',
            big_file_checker_wrapper(next_function_end),
            desc = 'Next function end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[C',
            big_file_checker_wrapper(prev_class_end),
            desc = 'Previous class end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']C',
            big_file_checker_wrapper(next_class_end),
            desc = 'Next class end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[L',
            big_file_checker_wrapper(prev_loop_end),
            desc = 'Previous loop end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']L',
            big_file_checker_wrapper(next_loop_end),
            desc = 'Next loop end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[B',
            big_file_checker_wrapper(prev_block_end),
            desc = 'Previous block end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']B',
            big_file_checker_wrapper(next_block_end),
            desc = 'Next block end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[R',
            big_file_checker_wrapper(prev_return_end),
            desc = 'Previous return end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']R',
            big_file_checker_wrapper(next_return_end),
            desc = 'Next return end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[P',
            big_file_checker_wrapper(prev_parameter_end),
            desc = 'Previous parameter end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']P',
            big_file_checker_wrapper(next_parameter_end),
            desc = 'Next parameter end',
            mode = { 'n', 'x', 'o' },
        },
        {
            '[I',
            big_file_checker_wrapper(prev_if_end),
            desc = 'Previous if end',
            mode = { 'n', 'x', 'o' },
        },
        {
            ']I',
            big_file_checker_wrapper(next_if_end),
            desc = 'Next if end',
            mode = { 'n', 'x', 'o' },
        },
    },
}
