# abbreviations for git
abbr -a gco git checkout
abbr -a gst git status
abbr -a gaa git add :/
abbr -a gad git add .
abbr -a gcm git commit
abbr -a gft git fetch
abbr -a gmg git merge
abbr -a gl git log
abbr -a gdf git diff
abbr -a ga git add
abbr -a gps git push
abbr -a gpl git pull

# abbreviations for jupyter
abbr -a jpt jupyter
abbr -a nb notebook
abbr -a nbcv nbconvert

# abbreviation for  ll not to show hidden files
abbr -a ll ls -lFh

# abbreviation for windows copy and paste,
# those is for wsl
abbr -a wcp clip.exe
abbr -a wpst powershell.exe Get-Clipboard

# this enable .. be cd ../, ... be cd ../../
# .... be cd ../../../
function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotdot --regex '^\.\.+$' --function multicd
# this is for vi mode
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end
fish_user_key_bindings

# this will not be useful for wsl
# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default block
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursors to an underscore
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
set fish_cursor_visual block
