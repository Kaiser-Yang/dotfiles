return {
    'nvim-treesitter/nvim-treesitter',
    build = function() require('nvim-treesitter.install').update({ with_sync = true })() end,
    dependencies = {
        {
            'andymass/vim-matchup',
            init = function()
                vim.g.matchup_matchparen_offscreen = { method = 'popup' }
            end,
        },
        'nvim-treesitter/nvim-treesitter-textobjects',
        {
            'nvim-treesitter/nvim-treesitter-context',
            opts = {
                max_lines = 1,
            }
        }
    },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require 'nvim-treesitter.configs'.setup {
            ensure_installed = { 'c', 'cpp', 'cmake', 'lua', 'python', 'html', 'javascript', 'css',
                'json', 'bash', 'regex', 'markdown', 'markdown_inline', 'diff', 'vimdoc', 'java',
                'latex' },
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
            },
            matchup = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['af'] = { query = '@function.outer' },
                        ['if'] = { query = '@function.inner' },
                        ['ac'] = { query = '@class.outer' },
                        ['ic'] = { query = '@class.inner' },
                        ['al'] = { query = '@loop.outer' }
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        [']f'] = { query = '@function.outer' },
                        [']c'] = { query = '@class.outer' },
                        [']l'] = { query = '@loop.outer' },
                        [']b'] = { query = '@block.outer' },
                    },
                    goto_next_end = {
                        [']F'] = { query = '@function.outer' },
                        [']C'] = { query = '@class.outer' },
                        [']L'] = { query = '@loop.outer' },
                        [']B'] = { query = '@block.outer' },
                    },
                    goto_previous_start = {
                        ['[f'] = { query = '@function.outer' },
                        ['[c'] = { query = '@class.outer' },
                        ['[l'] = { query = '@loop.inter' },
                        ['[b'] = { query = '@block.outer' },
                    },
                    goto_previous_end = {
                        ['[F'] = { query = '@function.outer' },
                        ['[C'] = { query = '@class.outer' },
                        ['[L'] = { query = '@loop.inter' },
                        ['[B'] = { query = '@block.outer' },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['sl'] = { query = '@parameter.inner' },
                        ['sj'] = { query = '@statement.outer' },
                    },
                    swap_previous = {
                        ['sh'] = { query = '@parameter.inner' },
                        ['sk'] = { query = '@statement.outer' },
                    },
                },
            }
        }
        local map_set = require('utils').map_set
        local ts_repeat_move = require('nvim-treesitter.textobjects.repeatable_move')
        map_set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move)
        map_set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_opposite)
        map_set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
        map_set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
        map_set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
        map_set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })

        vim.o.foldmethod = 'expr'
        vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
}
