local u = require('utils')
u.gh('nvim-tree/nvim-web-devicons')
u.gh('nvim-tree/nvim-tree.lua')
require('nvim-tree').setup({
  on_attach = function(buffer)
    local a = require('nvim-tree.api')
    local function opts(desc) return { desc = desc, buffer = buffer, noremap = true, silent = true, nowait = true } end
    local h = require('handler')
    local mapping = {
      { 'n', 'E', a.node.open.toggle_group_empty, opts('Toggle Group Empty') },
      { 'n', '.', a.node.run.cmd, opts('Run Nvim Command') },
      { 'n', 'O', a.node.run.system, opts('System Open') },
      { 'n', 'o', a.node.open.edit, opts('Open') },
      -- HACK: this should be focusable by pressing K again
      { 'n', 'K', a.node.show_info_popup, opts('Info') },
      { 'n', '<2-leftmouse>', a.node.open.edit, opts('Open') },
      { 'n', '<c-t>', a.node.open.tab, opts('New Tab') },
      { 'n', '<c-s>', a.node.open.horizontal, opts('Horizontal Split') },
      { 'n', '<c-v>', a.node.open.vertical, opts('Vertical Split') },
      { 'n', 'H', a.node.collapse, opts('Collapse') },
      { 'n', 'L', a.node.expand, opts('Expand') },

      { 'n', 'g?', a.tree.toggle_help, opts('Help') },
      { 'n', '<f1>', a.tree.toggle_help, opts('Help') },
      { 'n', '<f5>', a.tree.reload, opts('Refresh') },
      { 'n', 'q', a.tree.close, opts('Quit') },
      { 'n', 's', a.tree.search_node, opts('Search') },

      { 'n', 'a', a.fs.create, opts('Create') },
      { 'n', 'r', a.fs.rename, opts('Rename') },
      { 'n', 'p', a.fs.paste, opts('Paste') },
      { { 'n', 'x' }, 'y', a.fs.copy.node, opts('Copy') },
      { { 'n', 'x' }, 'd', a.fs.remove, opts('Remove') },
      { { 'n', 'x' }, 'x', a.fs.cut, opts('Cut') },

      { 'n', '[g', h.repmove.nvim_tree_previous_git, opts('Previous Git') },
      { 'n', ']g', h.repmove.nvim_tree_next_git, opts('Next Git') },
      { 'n', ']d', h.repmove.nvim_tree_next_diagnostic, opts('Next Diagnostic') },
      { 'n', '[d', h.repmove.nvim_tree_previous_diagnostic, opts('Previous Diagnostic') },

      { 'n', 'Y', h.tree.copy_node_information, opts('Copy Node Information') },
      { 'n', 'l', h.tree.open_folder_or_preview, opts('Open Folder or Preview') },
      { 'n', 'h', h.tree.collapse_or_go_to_parent, opts('Collapse or Go to Parent') },
      { 'n', '<cr>', h.tree.cd_or_open, opts('CD or Open') },
      { 'n', '<bs>', h.tree.cd_parent_directory, opts('CD parrent directory') },
      { { 'n', 'x' }, 'C', h.tree.copy_to, opts('Copy to') },
      { { 'n', 'x' }, 'R', h.tree.rename_full, opts('Rename Full Path or Move') },

      { { 'n', 'x' }, 'm', a.marks.toggle, opts('Toggle Bookmark') },
      { 'n', 'bd', a.marks.bulk.delete, opts('Delete Bookmarked') },
      { 'n', 'bt', a.marks.bulk.trash, opts('Trash Bookmarked') },
      { 'n', 'bm', a.marks.bulk.move, opts('Move Bookmarked') },
      { 'n', 'bc', a.marks.clear, opts('Clear Bookmark') },

      { 'n', 'M', a.filter.no_bookmark.toggle, opts('Toggle Filter: No Bookmark') },
      { 'n', 'B', a.filter.no_buffer.toggle, opts('Toggle Filter: No Buffer') },
      { 'n', 'G', a.filter.git.clean.toggle, opts('Toggle Filter: Git Clean') },
      { 'n', 'I', a.filter.git.ignored.toggle, opts('Toggle Filter: Git Ignored') },
      { 'n', 'D', a.filter.dotfiles.toggle, opts('Toggle Filter: Dotfiles') },
      { 'n', 'U', a.filter.custom.toggle, opts('Toggle Filter: Custom') },
      { 'n', 'f', a.filter.live.start, opts('Live Filter: Start') },
      { 'n', 'F', a.filter.live.clear, opts('Live Filter: Clear') },
    }
    for _, m in ipairs(mapping) do
      vim.keymap.set(unpack(m))
    end
  end,
  view = {
    number = true,
    relativenumber = true,
    width = 35,
  },
  renderer = {
    group_empty = true,
    indent_markers = { enable = true },
    hidden_display = 'all',
  },
  diagnostics = { enable = true, show_on_dirs = true, diagnostic_opts = true },
  modified = { enable = true },
  filters = {
    git_ignored = true,
    dotfiles = not u.in_config_dir(),
    custom = { '^\\.git$' },
  },
  actions = {
    file_popup = { open_win_config = { border = vim.o.winborder } },
    open_file = {
      resize_window = false,
      window_picker = {
        exclude = {
          filetype = {
            'CompetiTest',
            'notify',
            'packer',
            'qf',
            'diff',
            'fugitive',
            'fugitiveblame',
            'smear-cursor',
            'snacks_notif',
            'noice',
            'grug-far',
          },
          buftype = { 'nofile', 'terminal', 'quickfix', 'prompt' },
        },
      },
    },
  },
})
