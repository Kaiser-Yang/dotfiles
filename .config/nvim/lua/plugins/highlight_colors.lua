return {
    'brenoprata10/nvim-highlight-colors',
    cmd = 'HighlightColors',
    opts = {
        exclude_buffer = require('utils').is_big_file,
    },
    ft = { 'css', 'scss', 'less', 'html', 'javascript', 'typescript', 'vue', 'svelte', 'astro' },
}
