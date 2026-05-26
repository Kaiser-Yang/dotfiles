local wezterm = require('wezterm')
local act = wezterm.action

-- check if a command exists
local function command_exists(cmd)
    local handle = io.popen('command -v ' .. cmd .. " >&/dev/null && echo 'yes' || echo 'no'")
    local result = handle:read('*a')
    handle:close()
    return result:find('yes') ~= nil
end

-- Get the default program based on the operating system
local function default_program()
    local default_prog = nil
    if command_exists('zsh') then
        default_prog = { 'zsh' }
    elseif command_exists('fish') then
        default_prog = { 'fish' }
    else
        default_prog = { 'bash' }
    end
    return default_prog
end

return {
    initial_rows = 40,
    initial_cols = 80,
    automatically_reload_config = true,
    color_scheme = 'Catppuccin Mocha',
    default_prog = default_program(),
    disable_default_key_bindings = true,
    enable_tab_bar = false,
    font = wezterm.font_with_fallback({
        {
            family = 'JetBrains Mono',
            harfbuzz_features = { 'calt=0' },
        },
    }),
    font_size = 14,
    keys = {},
    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = { WheelUp = 1 } } },
            mods = 'CTRL',
            action = act.IncreaseFontSize,
        },
        {
            event = { Up = { streak = 1, button = { WheelDown = 1 } } },
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
