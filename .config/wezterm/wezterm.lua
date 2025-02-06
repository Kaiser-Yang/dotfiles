local wezterm = require('wezterm')
local act = wezterm.action
-- check if a command exists
local function command_exists(cmd)
    local handle = io.popen("command -v " .. cmd .. " >/dev/null 2>&1 && echo 'yes' || echo 'no'")
    local result = handle:read("*a")
    handle:close()
    return result:find('yes') ~= nil
end

-- Check if WSL is available
local function is_wsl_available()
    local handle = io.popen("wsl.exe -l")
    local result = handle:read("*a")
    handle:close()
    return result ~= nil and result ~= ""
end

-- Get the default program based on the operating system
local function default_program()
    local default_prog = nil
    local target = wezterm.target_triple
    if target:find("windows") then
        if is_wsl_available() then
            default_prog = { "wsl.exe" }
        else
            default_prog = { "powershell.exe" }
        end
    else
        if command_exists("zsh") then
            default_prog = { "zsh" }
        elseif command_exists("fish") then
            default_prog = { "fish" }
        else
            default_prog = { "bash" }
        end
    end
    return default_prog
end

return {
    automatically_reload_config = true,
    color_scheme = 'Catppuccin Mocha',
    default_prog = default_program(),
    disable_default_key_bindings = true,
    enable_tab_bar = false,
    font = wezterm.font_with_fallback({
        'CaskaydiaMono Nerd Font',
        'JetBrains Mono'
    }),
    keys = {
        { key = "z", mods = "CTRL|ALT", action = "Nop" },
        { key = '=', mods = 'CTRL',   action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL',   action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL',   action = act.ResetFontSize },
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
            action = act.CompleteSelection 'ClipboardAndPrimarySelection',
        },
        {
            event = { Down = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor,
        },
        {
            event = { Down = { streak = 1, button = 'Right' } },
            mods = 'NONE',
            action = act.PasteFrom('Clipboard'),
        }
    },
    window_close_confirmation = 'NeverPrompt',
    window_decorations = 'NONE',
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },
}
