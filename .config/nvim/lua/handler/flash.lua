local u = require('utils')
local M = {}

local function format(opts)
  return {
    { opts.match.label1, 'FlashMatch' },
    { opts.match.label2, 'FlashLabel' },
  }
end

function M.jump()
  if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return false end
  require('flash').jump()
  return true
end

function M.forward_search()
  if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return false end
  require('flash').jump({ forward = true, wrap = true, search = { multi_window = false } })
  return true
end

function M.backward_search()
  if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return false end
  require('flash').jump({ forward = false, wrap = true, search = { multi_window = false } })
  return true
end

function M.remote()
  if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return false end
  require('flash').remote()
  return true
end

function M.treesitter()
  if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return false end
  require('flash').treesitter({ prompt = { enabled = false } })
  return true
end

function M.treesitter_search()
  if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return false end
  require('flash').treesitter_search()
  return true
end

function M.two_char_jump()
  if not _G.loaded['flash.nvim'] or not u.enabled('flash') then return false end
  local flash = require('flash')
  local first_visible_line = vim.fn.line('w0')
  local last_visible_line = vim.fn.line('w$')
  flash.jump({
    prompt = { enabled = false },
    search = { mode = 'search' },
    label = {
      after = false,
      before = { 0, 0 },
      uppercase = false,
      format = format,
    },
    pattern = [[\%<]] .. last_visible_line + 1 .. 'l' .. [[\%>]] .. first_visible_line - 1 .. 'l' .. [[\<]],
    action = function(match, state)
      state:hide()
      flash.jump({
        prompt = { enabled = false },
        search = { max_length = 0 },
        highlight = { matches = false },
        label = { format = format },
        matcher = function(win)
          return vim.tbl_filter(function(m) return m.label == match.label and m.win == win end, state.results)
        end,
        labeler = function(matches)
          for _, m in ipairs(matches) do
            m.label = m.label2
          end
        end,
      })
    end,
    labeler = function(matches, state)
      local labels = state:labels()
      for m, match in ipairs(matches) do
        match.label1 = labels[math.floor((m - 1) / #labels) + 1]
        match.label2 = labels[(m - 1) % #labels + 1]
        match.label = match.label1
      end
    end,
  })
end

return M
