return {
    'zbirenbaum/copilot.lua',
    dependencies = {
        'nvim-telescope/telescope.nvim',
    },
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
        local copilot = require('copilot')
        local suggestion = require('copilot.suggestion')
        copilot.setup({
            panel = {
                enabled = false,
            },
            suggestion = {
                auto_trigger = true,
                hide_during_completion = false,
                keymap = {
                    accept = false,
                    accept_word = '<m-f>',
                    accept_line = false,
                    next = false,
                    prev = false,
                    dismiss = '<c-c>',
                },
            },
            filetypes = {
                ['*'] = true,
            },
            copilot_node_command = 'node',
            server_opts_overrides = {},
        })
        local map_set = require('utils').map_set
        local feedkeys = require('utils').feedkeys
        map_set({ 'i' }, '<c-f>', function()
            if suggestion.is_visible() then
                suggestion.accept_line()
            else
                require('telescope.builtin').live_grep({
                    cwd = require('utils').get_root_directory(),
                    additional_args = { '--hidden', },
                })
            end
        end)
        map_set({ 'i' }, '<m-cr>', function()
            if suggestion.is_visible() then
                suggestion.accept()
            else
                feedkeys('<esc><cr>', 'n')
            end
        end)
    end
}
