local k = require('blink.cmp.types').CompletionItemKind
local u = require('utils')
return {
  [k.Snippet] = {
    ['if .. then'] = u.make_snippet_wrap('if', {
      'if ${1:true} then',
      '\t$0',
      'end',
    }),
    ['elseif .. then'] = u.make_snippet_wrap('elif', {
      'elseif ${1:true} then',
      '\t$0',
    }),
    ['for i = ..'] = u.make_snippet_wrap('for', {
      'for ${1:true} do',
      '\t$0',
      'end',
    }, 'normal for'),
    ['for .. ipairs'] = function(item) return u.make_snippet_wrap('fori', item.insertText, 'for iparis')(item) end,
    ['for .. pairs'] = function(item) return u.make_snippet_wrap('forp', item.insertText, 'for pairs')(item) end,
    ['function ()'] = function(item)
      if not item.insertText:find('function %$') then
        item.insertText = item.insertText:gsub('function ', 'function')
      end
      return u.make_snippet_wrap('fu', item.insertText, 'function')(item)
    end,
    ['local function'] = function(item) return u.make_snippet_wrap('lfu', item.insertText, 'local function')(item) end,
    ['while .. do'] = function(item) return u.make_snippet_wrap('while', item.insertText)(item) end,
  },
  [k.Keyword] = {
    ['local'] = u.make_snippet_wrap('l', 'local ', 'local'),
    ['else'] = u.make_snippet_wrap('else', {
      'else',
      '\t',
    }),
  },
  [k.Event] = {
    ['field'] = false,
    ['param'] = false,
    ['return'] = false,
    ['see'] = false,
    ['class'] = false,
  },
}
