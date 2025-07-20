local utils = require('utils')
utils.init_for_wsl()
return {
    'Kaiser-Yang/img-clip.nvim',
    branch = 'main',
    ft = vim.g.markdown_support_filetype,
    opts = {
        default = {
            prompt_for_file_name = false,
            embed_image_as_base64 = false,
            dir_path = function()
                local res = 'assets/'
                if utils.current_file_in_github_io() then
                    res = res .. 'img/'
                else
                    res = res .. vim.fn.expand('%:t') .. '/'
                end
                return res
            end,
            drag_and_drop = {
                enabled = utils.markdown_support_enabled,
                insert_mode = utils.markdown_support_enabled,
                use_absolute_path = vim.fn.has('win32') == 1,
            },
        },
        filetypes = {
            markdown = {
                template = function()
                    local res = '![$CURSOR]($FILE_PATH)'
                    if utils.current_file_in_github_io() then res = res .. '{: .img-fluid}' end
                    res = res .. '<++>'
                    return res
                end,
            },
        },
    },
    config = function(_, opts)
        require('img-clip').setup(opts)
        if not Snacks then return end
        require('utils').map_set({ 'n' }, '<leader>sp', function()
            if not utils.should_enable_paste_image() then
                vim.notify('Paste image is not supported in this context', vim.log.levels.WARN)
                return
            end
            Snacks.picker.files({
                cwd = vim.fn.getcwd(),
                cmd = 'rg',
                hidden = not utils.should_ignore_hidden_files(),
                ft = { 'gif', 'jpg', 'jpeg', 'png', 'webp' },
                confirm = function(self, item, _)
                    self:close()
                    require('img-clip').paste_image({}, './' .. item.file)
                end,
            })
        end, { desc = 'Paste image from file' })
    end,
}
