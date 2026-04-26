local u = require('utils')
local M = {}

local function check_big()
  if u.buffer.big() then
    vim.notify('Buffer is too big for nvim-treesitter-textobjects', vim.log.levels.WARN, { title = 'Light Boat' })
    return false
  end
  return true
end
local function select(query_string, query_group)
  if not check_big() then return false end
  require('nvim-treesitter-textobjects.select').select_textobject(query_string, query_group)
  -- HACK:
  -- We do not know if the operation is successful or not, so just return true
  return true
end

--- @param direction 'next'|'previous'
local function swap(direction, query_string)
  if not check_big() then return false end
  require('nvim-treesitter-textobjects.swap')['swap_' .. direction](query_string)
  -- HACK:
  -- We do not know if the operation is successful or not, so just return true
  return true
end

--- @param direction 'next'|'previous'
--- @param position 'start'|'end'
function M.go_to(direction, position, query_string, query_group)
  if not check_big() then return false end
  require('nvim-treesitter-textobjects.move')['goto_' .. direction .. '_' .. position](query_string, query_group)
  -- HACK:
  -- We do not know if the operation is successful or not, so just return true
  return true
end

-- stylua: ignore start
-- HACK:
-- Those below do not support vim.v.count
function M.around_function() return select('@function.outer') end
function M.around_class() return select('@class.outer') end
function M.around_block() return select('@block.outer') end
function M.around_conditional() return select('@conditional.outer') end
function M.around_loop() return select('@loop.outer') end
function M.around_return() return select('@return.outer') end
function M.around_parameter() return select('@parameter.outer') end
function M.around_statement() return select('@statement.outer') end
function M.around_call() return select('@call.outer') end
function M.inside_function() return select('@function.inner') end
function M.inside_class() return select('@class.inner') end
function M.inside_block() return select('@block.inner') end
function M.inside_conditional() return select('@conditional.inner') end
function M.inside_loop() return select('@loop.inner') end
function M.inside_return() return select('@return.inner') end
function M.inside_parameter() return select('@parameter.inner') end
function M.inside_statement() return select('@statement.inner') end
function M.inside_call() return select('@call.inner') end

-- HACK:
-- this below do not support vim.v.count
function M.swap_with_next_function() return swap('next', '@function.outer') end
function M.swap_with_next_class() return swap('next', '@class.outer') end
function M.swap_with_next_block() return swap('next', '@block.outer') end
function M.swap_with_next_conditional() return swap('next', '@conditional.outer') end
function M.swap_with_next_loop() return swap('next', '@loop.outer') end
function M.swap_with_next_return() return swap('next', '@return.outer') end
function M.swap_with_next_parameter() return swap('next', '@parameter.inner') end
function M.swap_with_next_statement() return swap('next', '@statement.outer') end
function M.swap_with_next_call() return swap('next', '@call.outer') end
function M.swap_with_previous_class() return swap('previous', '@class.outer') end
function M.swap_with_previous_function() return swap('previous', '@function.outer') end
function M.swap_with_previous_block() return swap('previous', '@block.outer') end
function M.swap_with_previous_conditional() return swap('previous', '@conditional.outer') end
function M.swap_with_previous_loop() return swap('previous', '@loop.outer') end
function M.swap_with_previous_return() return swap('previous', '@return.outer') end
function M.swap_with_previous_parameter() return swap('previous', '@parameter.inner') end
function M.swap_with_previous_statement() return swap('previous', '@statement.outer') end
function M.swap_with_previous_call() return swap('previous', '@call.outer') end
-- stylua: ignore end

return M
