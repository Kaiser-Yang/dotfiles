return {
  'saghen/blink.cmp',
  opts = {
    sources = {
      providers = {
        ripgrep = {
          enabled = vim.fn.has('mac') == 0,
          transform_items = function(_, items)
            items = vim.tbl_filter(function(item)
              -- Remove items that consist of only numbers
              return not (item.label:match('^%d+$') or item.label:match('^%d+%.%d+$'))
            end, items)
            if #items > 100 then
              -- Limit the number of items to 100
              items = vim.list_slice(items, 1, 100)
            end
            return items
          end,
        },
      },
    },
  },
}
