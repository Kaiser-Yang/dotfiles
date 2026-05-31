local u = require('utils')
return {
  function()
    if not vim.fn.getcwd():find('github%.io') then return end
    local now = os.date('%Y-%m-%d %H:%M:%S')
    return u.make_snippet_wrap('io', {
      '---',
      'layout: post',
      'title: $1',
      'date: ' .. now .. '+0800',
      'last_updated: ' .. now .. '+0800',
      'description: $2',
      'tags:',
      '  - $3',
      'categories: $4',
      'featured:',
      'giscus_comments: true',
      'toc:',
      '  sidebar: left',
      'related_posts: true',
      'pretty_table: true',
      '---',
      '',
      '$0',
    }, 'github io page template')()
  end,
}
