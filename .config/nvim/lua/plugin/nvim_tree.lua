return {
  'nvim-tree/nvim-tree.lua',
  opts = {
    on_attach = function(buffer)
      local a = require('nvim-tree.api')
      local function opts(desc) return { desc = desc, buffer = buffer, noremap = true, silent = true, nowait = true } end
      local h = require('lightboat.handler')
      local mapping = {
        { 'n', '<cr>', a.node.open.edit, opts('Open') },
        { 'n', '<c-t>', a.node.open.tab, opts('New Tab') },
        { 'n', '<c-s>', a.node.open.horizontal, opts('Horizontal Split') },
        { 'n', '<c-v>', a.node.open.vertical, opts('Vertical Split') },
        { 'n', '<f1>', a.tree.toggle_help, opts('Help') },
        { 'n', '<f5>', a.tree.reload, opts('Refresh') },
        { 'n', '<2-leftmouse>', a.node.open.edit, opts('Open') },
        { 'n', '[g', h.nvim_tree_previous_git, opts('Previous Git') },
        { 'n', ']g', h.nvim_tree_next_git, opts('Next Git') },
        { 'n', ']d', h.nvim_tree_next_diagnostic, opts('Next Diagnostic') },
        { 'n', '[d', h.nvim_tree_previous_diagnostic, opts('Previous Diagnostic') },
        { 'n', 'a', a.fs.create, opts('Create') },
        { 'n', 'r', a.fs.rename, opts('Rename') },
        { 'n', 'o', a.node.open.edit, opts('Open') },
        { 'n', 'h', h.collapse_or_go_to_parent, opts('Collapse or Go to Parent') },
        { 'n', 'l', h.open_folder_or_preview, opts('Open Folder or Preview') },
        { 'n', '<bs>', a.node.navigate.parent_close, opts('Close Directory') },
        { 'n', 'p', a.fs.paste, opts('Paste') },
        { 'n', 'q', a.tree.close, opts('Quit') },
        { 'n', 'H', a.tree.collapse_all, opts('Collapse All') },
        { 'n', 'L', a.tree.expand_all, opts('Expand All') },
        { 'n', 'Y', h.copy_node_information, opts('Copy Node Information') },
        { 'n', '<c-]>', h.change_root_to_node, opts('CD') },
        { 'n', '<c-o>', h.change_root_to_parent, opts('Up') },
        { 'n', 'K', a.node.show_info_popup, opts('Info') },
        { { 'n', 'x' }, 'y', a.fs.copy.node, opts('Copy') },
        { { 'n', 'x' }, 'd', a.fs.remove, opts('Remove') },
        { { 'n', 'x' }, 'x', a.fs.cut, opts('Cut') },
        { { 'n', 'x' }, 'm', a.marks.toggle, opts('Toggle Bookmark') },
        { { 'n', 'x' }, 'c', h.copy_to, opts('Copy to') },
        { { 'n', 'x' }, 'R', h.rename_full, opts('Rename Full Path or Move') },
        { 'n', 'bd', a.marks.bulk.delete, opts('Delete Bookmarked') },
        { 'n', 'bm', a.marks.bulk.move, opts('Move Bookmarked') },
        { 'n', 'M', a.filter.no_bookmark.toggle, opts('Toggle Filter: No Bookmark') },
        { 'n', 'B', a.filter.no_buffer.toggle, opts('Toggle Filter: No Buffer') },
        { 'n', 'C', a.filter.git.clean.toggle, opts('Toggle Filter: Git Clean') },
        { 'n', 'I', a.filter.git.ignored.toggle, opts('Toggle Filter: Git Ignored') },
        { 'n', 'D', a.filter.dotfiles.toggle, opts('Toggle Filter: Dotfiles') },
        { 'n', 'U', a.filter.custom.toggle, opts('Toggle Filter: Custom') },
        { 'n', 'f', a.filter.live.start, opts('Live Filter: Start') },
        { 'n', 'F', a.filter.live.clear, opts('Live Filter: Clear') },
        { 'n', 'P', a.node.navigate.parent, opts('Parent Directory') },
        { 'n', 'E', a.node.open.toggle_group_empty, opts('Toggle Group Empty') },
        { 'n', '.', a.node.run.cmd, opts('Run Command') },
        { 'n', 's', a.node.run.system, opts('Run System') },
        { 'n', 'S', a.tree.search_node, opts('Search') },
      }
      for _, m in ipairs(mapping) do
        vim.keymap.set(unpack(m))
      end
    end,
  },
}
