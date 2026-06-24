local k = require('blink.cmp.types').CompletionItemKind
return {
  [k.Keyword] = {
    ['import'] = false,
    ['const'] = false,
    ['type'] = false,
    ['func'] = false,
    ['var'] = false,
    ['switch'] = false,
    ['select'] = false,
    ['case'] = false,
    ['map'] = false,
    ['defer'] = false,
  },
}
