return {
  'hakonharnes/img-clip.nvim',
  branch = 'main',
  opts = {
    default = {
      dir_path = function()
        local res = 'assets'
        if vim.fn.expand('%:p'):find('Kaiser%-Yang.github.io') then
          res = res .. '/img'
        else
          res = res .. '/' .. vim.fn.expand('%:t')
        end
        return res
      end,
      relative_to_current_file = function() return not vim.fn.expand('%:p'):find('Kaiser%-Yang.github.io') end,
    },
    filetypes = {
      markdown = {
        template = function(context)
          local res = '![$CURSOR]($FILE_PATH)'
          if vim.fn.expand('%:p'):find('Kaiser%-Yang.github.io') then
            res = '![$CURSOR](' .. string.match(context.file_path, '^.*(assets/img/.*)$') .. '){: .img-fluid}'
          end
          return res
        end,
      },
    },
  },
}
