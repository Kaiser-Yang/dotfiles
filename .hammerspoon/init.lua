local non_nvim_profile = 'non-nvim'
local nvim_profile = 'nvim'

local last_profile = nil

local function check_and_switch_profile()
    local win = hs.application.frontmostApplication():focusedWindow()
    local title = win and win:title() or ''
    print(title)
    if string.match(title, 'nvim') then
        if last_profile ~= nvim_profile then
            hs.execute(
                '/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile "'
                    .. nvim_profile
                    .. '"'
            )
            last_profile = nvim_profile
        end
    else
        if last_profile ~= non_nvim_profile then
            hs.execute(
                '/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile "'
                    .. non_nvim_profile
                    .. '"'
            )
            print(
                '/Library/Application\\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile "'
                    .. non_nvim_profile
                    .. '"'
            )
            last_profile = non_nvim_profile
        end
    end
end

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, check_and_switch_profile)
hs.timer.doEvery(2, check_and_switch_profile)
