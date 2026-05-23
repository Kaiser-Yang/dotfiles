vim.schedule(function()
  local h = require('handler')
  local u = require('utils')

  local function comma_typed()
    local key = u.key.last_key()
    return key and key:match(',$') ~= nil
  end

  local mappings = {
    -- Markdown insert mappings
    { 'i', '1', h.markdown.title(1), { desc = 'Insert Markdown Title 1' } },
    { 'i', '2', h.markdown.title(2), { desc = 'Insert Markdown Title 2' } },
    { 'i', '3', h.markdown.title(3), { desc = 'Insert Markdown Title 3' } },
    { 'i', '4', h.markdown.title(4), { desc = 'Insert Markdown Title 4' } },
    { 'i', 's', h.markdown.separate_line, { desc = 'Insert Markdown Separate Line' } },
    { 'i', 'm', h.markdown.math_inline, { desc = 'Insert Markdown Inline Math' } },
    { 'i', 't', h.markdown.code_inline, { desc = 'Insert Markdown Code Line' } },
    { 'i', 'x', h.markdown.todo, { desc = 'Insert Markdown Todo' } },
    { 'i', 'a', h.markdown.link, { desc = 'Insert Markdown Link' } },
    { 'i', 'b', h.markdown.bold, { desc = 'Insert Markdown Bold Text' } },
    { 'i', 'd', h.markdown.delete_line, { desc = 'Insert Markdown Delete Line' } },
    { 'i', 'i', h.markdown.italic, { desc = 'Insert Markdown Italic Text' } },
    { 'i', 'M', h.markdown.math_block, { desc = 'Insert Markdown Math Block' } },
    { 'i', 'c', h.markdown.code_block, { desc = 'Insert Markdown Code Block' } },
    { 'i', 'f', h.markdown.goto_placeholder, { desc = 'Goto&Delete Markdown Placeholder' } },
  }

  for _, m in ipairs(mappings) do
    local rhs = m[3]
    m[3] = function()
      local res = m[2]
      if not comma_typed() then return res end
      if type(rhs) == 'function' then
        res = rhs()
        if not res then res = m[2] end
      else
        res = rhs
      end
      return res
    end
    m[4].expr = true
    m[4].buffer = true
    vim.keymap.set(unpack(m))
  end
end)
