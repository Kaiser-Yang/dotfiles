--- @param ft_list string|string[]
local function disable_in_ft_wrap(ft_list)
  ft_list = type(ft_list) == 'string' and { ft_list } or ft_list
  return function(str)
    assert(type(ft_list) == 'table', 'Expected a table, got: ' .. type(ft_list))
    for _, f in ipairs(ft_list) do
      if vim.bo.filetype:match(f) then return '' end
    end
    return str
  end
end
return {
  'nvim-lualine/lualine.nvim',
  opts = {
    sections = {
      lualine_x = {
        { function() return vim.g.rime_enabled and 'ㄓ' or '' end, fmt = disable_in_ft_wrap('dap') },
        { 'copilot', fmt = disable_in_ft_wrap('dap') },
        { 'filetype', fmt = disable_in_ft_wrap('dap') },
      },
    },
  },
}
