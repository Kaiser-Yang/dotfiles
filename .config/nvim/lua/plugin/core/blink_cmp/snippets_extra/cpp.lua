local u = require('utils')
return {
  function()
    local function sanitize(s) return s:upper():gsub('[^%w_]', '_') end
    local dir_part = sanitize(vim.fn.expand('%:p:h:t'))
    local file_part = sanitize(vim.fn.expand('%:t:r'))
    local ext_part = sanitize(vim.fn.expand('%:e'))
    local default = '_' .. dir_part .. '_' .. file_part .. '_' .. ext_part .. '_'
    return u.make_snippet_wrap('#header', {
      string.format('#ifndef ${1:%s}', default),
      '#define $1',
      '',
      '$0',
      '',
      '#endif  // $1',
    }, 'header guard: `_<DIRNAME>_<FILENAME>_<EXTENSION>_`')()
  end,
  function()
    if not vim.fn.getcwd():find('OJProblems') then return end
    return u.make_snippet_wrap('oj', {
      '// problem statement: $1',
      '',
      '#include <cstdint>',
      '#include <iostream>',
      '',
      'using i64 = int64_t;',
      'using u64 = uint64_t;',
      '',
      'int main() {',
      '    std::ios::sync_with_stdio(false);',
      '    std::cin.tie(nullptr);',
      '    $0',
      '    return 0;',
      '}',
    }, 'competitive programming template')()
  end,
}
