return {
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update({ with_sync = true })() end,
    dependencies = {
        {
            'andymass/vim-matchup',
            init = function() vim.g.matchup_matchparen_offscreen = { method = 'popup' } end,
        },
        'nvim-treesitter/nvim-treesitter-textobjects',
        {
            'nvim-treesitter/nvim-treesitter-context',
            opts = {
                max_lines = 1,
            },
        },
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup({
            sync_install = false,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = {
                enable = true,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = 'gn',
                    node_incremental = 'gn',
                    node_decremental = 'gp',
                    scope_incremental = 'gs',
                },
            },
            matchup = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['af'] = {
                            query = '@function.outer',
                            desc = 'Around function',
                        },
                        ['if'] = {
                            query = '@function.inner',
                            desc = 'Inside function',
                        },
                        ['ac'] = {
                            query = '@class.outer',
                            desc = 'Around class',
                        },
                        ['ic'] = {
                            query = '@class.inner',
                            desc = 'Inside class',
                        },
                        ['al'] = {
                            query = '@loop.outer',
                            desc = 'Around loop',
                        },
                        ['il'] = {
                            query = '@loop.inner',
                            desc = 'Inside loop',
                        },
                        ['ab'] = {
                            query = '@block.outer',
                            desc = 'Around block',
                        },
                        ['ib'] = {
                            query = '@block.inner',
                            desc = 'Inside block',
                        },
                        ['ar'] = {
                            query = '@return.outer',
                            desc = 'Around return',
                        },
                        ['ir'] = {
                            query = '@return.inner',
                            desc = 'Inside return',
                        },
                        ['ap'] = {
                            query = '@parameter.outer',
                            desc = 'Around parameter',
                        },
                        ['ip'] = {
                            query = '@parameter.inner',
                            desc = 'Inside parameter',
                        },
                        ['ai'] = {
                            query = '@conditional.outer',
                            desc = 'Around if',
                        },
                        ['ii'] = {
                            query = '@conditional.inner',
                            desc = 'Inside if',
                        },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        [']f'] = {
                            query = '@function.outer',
                            desc = 'Next function start',
                        },
                        [']c'] = {
                            query = '@class.outer',
                            desc = 'Next class start',
                        },
                        [']l'] = {
                            query = '@loop.outer',
                            desc = 'Next loop start',
                        },
                        [']b'] = {
                            query = '@block.outer',
                            desc = 'Next block start',
                        },
                        [']r'] = {
                            query = '@return.outer',
                            desc = 'Next return start',
                        },
                        [']p'] = {
                            query = '@parameter.inner',
                            desc = 'Next parameter start',
                        },
                        [']i'] = {
                            query = '@conditional.outer',
                            desc = 'Next if start',
                        },
                    },
                    goto_next_end = {
                        [']F'] = {
                            query = '@function.outer',
                            desc = 'Next function end',
                        },
                        [']C'] = {
                            query = '@class.outer',
                            desc = 'Next class end',
                        },
                        [']L'] = {
                            query = '@loop.outer',
                            desc = 'Next loop end',
                        },
                        [']B'] = {
                            query = '@block.outer',
                            desc = 'Next block end',
                        },
                        [']R'] = {
                            query = '@return.outer',
                            desc = 'Next return end',
                        },
                        [']P'] = {
                            query = '@parameter.inner',
                            desc = 'Next parameter end',
                        },
                        [']I'] = {
                            query = '@conditional.outer',
                            desc = 'Next if end',
                        },
                    },
                    goto_previous_start = {
                        ['[f'] = {
                            query = '@function.outer',
                            desc = 'Previous function start',
                        },
                        ['[c'] = {
                            query = '@class.outer',
                            desc = 'Previous class start',
                        },
                        ['[l'] = {
                            query = '@loop.outer',
                            desc = 'Previous loop start',
                        },
                        ['[b'] = {
                            query = '@block.outer',
                            desc = 'Previous block start',
                        },
                        ['[r'] = {
                            query = '@return.outer',
                            desc = 'Previous return start',
                        },
                        ['[p'] = {
                            query = '@parameter.inner',
                            desc = 'Previous parameter start',
                        },
                        ['[i'] = {
                            query = '@conditional.outer',
                            desc = 'Previous if start',
                        },
                    },
                    goto_previous_end = {
                        ['[F'] = {
                            query = '@function.outer',
                            desc = 'Previous function end',
                        },
                        ['[C'] = {
                            query = '@class.outer',
                            desc = 'Previous class end',
                        },
                        ['[L'] = {
                            query = '@loop.outer',
                            desc = 'Previous loop end',
                        },
                        ['[B'] = {
                            query = '@block.outer',
                            desc = 'Previous block end',
                        },
                        ['[R'] = {
                            query = '@return.outer',
                            desc = 'Previous return end',
                        },
                        ['[P'] = {
                            query = '@parameter.inner',
                            desc = 'Previous parameter end',
                        },
                        ['[I'] = {
                            query = '@conditional.outer',
                            desc = 'Previous if end',
                        },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['snf'] = {
                            query = '@function.outer',
                            desc = 'Swap with next function',
                        },
                        ['snc'] = {
                            query = '@class.outer',
                            desc = 'Swap with next class',
                        },
                        ['snl'] = {
                            query = '@loop.outer',
                            desc = 'Swap with next loop',
                        },
                        ['snb'] = {
                            query = '@block.outer',
                            desc = 'Swap with next block',
                        },
                        ['snr'] = {
                            query = '@return.outer',
                            desc = 'Swap with next return',
                        },
                        ['snp'] = {
                            query = '@parameter.inner',
                            desc = 'Swap with next parameter',
                        },
                        ['sni'] = {
                            query = '@conditional.outer',
                            desc = 'Swap with next if',
                        },
                    },
                    swap_previous = {
                        ['spf'] = {
                            query = '@function.outer',
                            desc = 'Swap with previous function',
                        },
                        ['spc'] = {
                            query = '@class.outer',
                            desc = 'Swap with previous class',
                        },
                        ['spl'] = {
                            query = '@loop.outer',
                            desc = 'Swap with previous loop',
                        },
                        ['spb'] = {
                            query = '@block.outer',
                            desc = 'Swap with previous block',
                        },
                        ['spr'] = {
                            query = '@return.outer',
                            desc = 'Swap with previous return',
                        },
                        ['spp'] = {
                            query = '@parameter.inner',
                            desc = 'Swap with previous parameter',
                        },
                        ['spi'] = {
                            query = '@conditional.outer',
                            desc = 'Swap with previous if',
                        },
                    },
                },
            },
        })
        local map_set = require('utils').map_set
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        map_set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
        map_set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)
        map_set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
        map_set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
        map_set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
        map_set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
        local feedkeys = require('utils').feedkeys
        local next_misspell, prev_misspell = ts_repeat_move.make_repeatable_move_pair(
            function() feedkeys(']s', 'n') end,
            function() feedkeys('[s', 'n') end
        )
        map_set('n', ']s', next_misspell, { desc = 'Next misspelled word' })
        map_set('n', '[s', prev_misspell, { desc = 'Previous misspelled word' })
        vim.o.foldmethod = 'expr'
        vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end,
}
