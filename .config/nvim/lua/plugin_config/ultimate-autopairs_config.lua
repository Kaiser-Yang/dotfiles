return {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter', 'CmdlineEnter' },
    branch = 'v0.6', --recommended as each new version will have breaking changes
    opts = {
        bs = {       -- *ultimate-autopair-map-backspace-config*
            overjumps = false,
            space = 'balance',
            indent_ignore = true,
        },
        cr = { -- *ultimate-autopair-map-newline-config*
            autoclose = true,
        },
        space = { -- *ultimate-autopair-map-space-config*
            -- TODO: understand this configurations
            --+ [|] > space > + [ ]
            check_box_ft = { 'markdown', 'vimwiki', 'org', 'git*' },
            _check_box_ft2 = { 'norg' },
        },
        fastwarp = { -- *ultimate-autopair-map-fastwarp-config*
            enable = false,
        },
        close = { -- *ultimate-autopair-map-close-config*
            enable = false,
        },
        config_internal_pairs = { -- *ultimate-autopair-pairs-configure-default-pairs*
            --configure internal pairs
            --example:
            --{'{','}',suround=true},
        },
    },
}
