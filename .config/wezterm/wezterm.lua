local wezterm = require('wezterm')
local act = wezterm.action

local function basename(path) return path:gsub('(.*[/\\])(.*)', '%2') end

local function get_running_program(pane)
    local proc_path = pane:get_foreground_process_name()
    if not proc_path then return '' end
    local proc_name = basename(proc_path)
    if proc_name == 'tmux' then
        local ok, stdout = wezterm.run_child_process({
            'env',
            'PATH_ONLY=true',
            os.getenv('SHELL'),
            '-ci',
            "tmux display-message -p -t . '#{pane_current_command}'",
        })
        if not ok then return '' end
        if stdout then return stdout:gsub('[\r\n]+', '') end
    end
    return proc_name
end

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
        { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '0', mods = 'CTRL', action = act.ResetFontSize },
        {
            key = 'v',
            mods = 'ALT',
            action = wezterm.action_callback(function(window, pane)
                local prog = get_running_program(pane)
                if prog == 'nvim' then
                    window:perform_action(act.SendKey({ key = 'v', mods = 'ALT' }), pane)
                else
                    window:perform_action(act.PasteFrom('Clipboard'), pane)
                end
            end),
        },
    },
    mouse_bindings = {
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
