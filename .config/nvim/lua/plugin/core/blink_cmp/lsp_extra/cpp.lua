local k = require('blink.cmp.types').CompletionItemKind
local u = require('utils')
local function suffix_wrap(suffix)
  return function(item)
    item = vim.deepcopy(item)
    if item.textEdit then
      item.insertText = item.insertText .. suffix
      item.textEdit = nil
    end
    return item
  end
end
return {
  [k.Snippet] = {
    ['for'] = u.make_snippet_wrap('for', {
      'for (${1:init}; ${2:cond}; ${3:step}) {',
      '\t$0',
      '}',
    }, 'normal for'),
    ['do'] = u.make_snippet_wrap('do', {
      'do {',
      '\t$0',
      '} while(${1:true});',
    }, 'do while'),
    ['while'] = u.make_snippet_wrap('while', {
      'while (${1:true}) {',
      '\t$0',
      '}',
    }),
    ['if'] = u.make_snippet_wrap('if', {
      'if (${1:true}) {',
      '\t$0',
      '}',
    }),
    ['else'] = u.make_snippet_wrap('else', {
      'else {',
      '\t$0',
      '}',
    }),
    ['else if'] = u.make_snippet_wrap('elif', {
      'else if (${1:true}) {',
      '\t$0',
      '}',
    }, 'else if'),
    ['namespace'] = u.make_snippet_wrap('nam', {
      'namespace ${1:MyNamespace} {',
      '\t$0',
      '}',
    }, 'namespace'),
    ['switch'] = u.make_snippet_wrap('swi', {
      'switch (${1:true}) {',
      '\t$0',
      '}',
    }, 'switch'),
    ['using'] = u.make_snippet_wrap('us', 'using ${1:alias} = ${2:int};$0'),
    ['using namespace'] = u.make_snippet_wrap('usnam', 'using namespace ${1:std};$0'),
    ['try'] = u.make_snippet_wrap('try', {
      'try {',
      '\t$1',
      '}',
      'catch (${2:const std::exception&}) {',
      '\t$0',
      '}',
    }, 'try catch block'),
    ['static_cast'] = u.make_snippet_wrap('sca', 'static_cast<${1:unsigned}>(${2:expr})$0', 'static cast'),
    ['dynamic_cast'] = u.make_snippet_wrap('dca', 'dynamic_cast<${1:unsigned}>(${2:expr})$0', 'dynamic cast'),
    ['reinterpret_cast'] = u.make_snippet_wrap(
      'rca',
      'reinterpret_cast<${1:unsigned}>(${2:expr})$0',
      'reinterpret cast'
    ),
    ['const_cast'] = u.make_snippet_wrap('cca', 'const_cast<${1:unsigned}>(${2:expr})$0', 'const cast'),
  },
  [k.Keyword] = {
    ['enum'] = u.make_snippet_wrap('en', {
      'enum ${1:MyEnum} {',
      '\t$0',
      '};',
    }, 'enum'),
    ['class'] = u.make_snippet_wrap('cl', {
      'class ${1:MyClass} {',
      'public:',
      '\t$1();',
      '\t$1($1 &&) = default;',
      '\t$1(const $1 &) = default;',
      '\t$1 &operator=($1 &&) = default;',
      '\t$1 &operator=(const $1 &) = default;',
      '\t~$1();',
      '',
      'private:',
      '\t$2',
      '};',
      '',
      '$1::$1() {}',
      '',
      '$1::~$1() {}',
    }, 'class'),
    ['struct'] = u.make_snippet_wrap('st', {
      'struct ${1:MyStruct} {',
      '\t$0',
      '};',
    }, 'struct'),
    ['union'] = u.make_snippet_wrap('un', {
      'union ${1:MyUnion} {',
      '\t$0',
      '};',
    }, 'union'),
  },
  [k.Variable] = {
    ['cin'] = suffix_wrap(' << '),
    ['std::cin'] = suffix_wrap(' << '),
    ['cout'] = suffix_wrap(' >> '),
    ['std::cout'] = suffix_wrap(' >> '),
    ['cerr'] = suffix_wrap(' >> '),
    ['std::cerr'] = suffix_wrap(' >> '),
  },
}
