local u = require('utils')
vim.pack.add({ u.gh('AlexvZyl/nordic.nvim') }, { confirm = false })
local n = require('nordic')
n.setup({
  transparent = { bg = true, float = true },
  on_highlight = function(h, p)
    h.Folded.bg = 'none'
    h.FoldColumn.bg = 'none'
    h.MatchParen.bg = p.gray3
    h.Comment.fg = 'NvimLightGray4'

    local blink_color_map = {
      Red = p.red.base,
      Orange = p.orange.base,
      Yellow = p.yellow.base,
      Green = p.green.base,
      Blue = p.blue0,
      Cyan = p.cyan.base,
      Purple = p.magenta.base,
      Violet = p.magenta.base,
    }
    -- BlinkPairs*
    for name, color in pairs(blink_color_map) do
      h['BlinkPairs' .. name] = { fg = color }
    end
    -- BlinkIndent* + BlinkIndent*Underline
    for name, color in pairs(blink_color_map) do
      h['BlinkIndent' .. name] = { fg = color }
      h['BlinkIndent' .. name .. 'Underline'] = { sp = color, underline = true }
    end
    h.BlinkPairsUnmatched = { fg = p.red.base, sp = p.red.base, underline = true }

    h.FloatBorder = { fg = p.white0 }
    local float_border_links = {
      'WhichKeyBorder',
      'BlinkCmpDocBorder',
      'BlinkCmpMenuBorder',
      'BlinkCmpSignatureHelpBorder',
      'TelescopeBorder',
      'TelescopePromptBorder',
      'TelescopeResultsBorder',
      'TelescopePreviewBorder',
    }
    for _, group in ipairs(float_border_links) do
      h[group] = { link = 'FloatBorder' }
    end

    h.Search = { fg = p.bg_visual, bg = p.yellow.dim, bold = true }
    h.IncSearch = { fg = p.bg_visual, bg = p.yellow.bright, bold = true }
    h.CurSearch = { link = 'IncSearch' }
    h.TelescopePreviewMatch = { link = 'CurSearch' }

    h.CursorLine.bg = p.gray1
    h.Visual = { bg = p.gray2, bold = true }
    h.CursorLineNr.bold = true
    h.TelescopePreviewLine = { link = 'Visual' }
    h.TelescopeSelection = { link = 'Visual' }

    h.GitSignsCurrentLineBlame = { link = 'Comment' }
  end,
  telescope = { style = 'classic' },
})
n.load()
