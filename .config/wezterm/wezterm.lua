local wezterm = require('wezterm')
local act = wezterm.action

return {
    automatically_reload_config = true,
    color_scheme = 'Catppuccin Mocha',
    default_prog = { 'zsh' },
    disable_default_key_bindings = true,
    enable_tab_bar = false,
    font = wezterm.font_with_fallback({
        {
            family = 'JetBrains Mono',
            harfbuzz_features = { 'calt=0' },
        },
    }),
    font_size = 14,
    keys = {
        {
            key = 'v',
            mods = 'CMD',
            action = act.PasteFrom('Clipboard'),
        },
    },
    mouse_bindings = {
        {
            event = { Down = { streak = 1, button = { WheelUp = 1 } } },
            mods = 'CTRL',
            action = act.IncreaseFontSize,
        },
        {
            event = { Down = { streak = 1, button = { WheelDown = 1 } } },
            mods = 'CTRL',
            action = act.DecreaseFontSize,
        },
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'NONE',
            action = act.CompleteSelection('ClipboardAndPrimarySelection'),
        },
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor,
        },
        {
            event = { Up = { streak = 1, button = 'Right' } },
            mods = 'NONE',
            action = act.PasteFrom('Clipboard'),
        },
    },
    window_close_confirmation = 'NeverPrompt',
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
