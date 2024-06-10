#                   __ _          __ _     _       _         _               
#   ___ ___  _ __  / _(_) __ _   / _(_)___| |__   | | ____ _(_)___  ___ _ __ 
#  / __/ _ \| '_ \| |_| |/ _` | | |_| / __| '_ \  | |/ / _` | / __|/ _ \ '__|
# | (_| (_) | | | |  _| | (_| |_|  _| \__ \ | | | |   < (_| | \__ \  __/ |   
#  \___\___/|_| |_|_| |_|\__, (_)_| |_|___/_| |_| |_|\_\__,_|_|___/\___|_|   
#                        |___/                                               
# abbreviations for git
abbr -a lzg lazygit
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
abbr -a grbs git rebase -i
abbr -a gdag git log --graph --abbrev-commit --decorate --format=format:"'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'" --all
abbr -a gdagol git log --all --decorate --oneline --graph
abbr -a gcco git checkout
abbr -a gbrc git branch
abbr -a gcln git clone
abbr -a grst git reset

# abbreviations for jupyter
abbr -a jpt jupyter
abbr -a jptnb jupyter notebook
abbr -a jptnbcv jupyter nbconvert --to

# abbreviations for ll not to show hidden files
abbr -a ll ls -lFh

# abbreviations for windows copy and paste,
# those is for wsl
abbr -a wcp clip.exe
abbr -a wpst powershell.exe Get-Clipboard

# abbreviations for tmux
abbr -a tm tmux
abbr -a tmls tmux ls
abbr -a tmlsbf tmux list-buffers
abbr -a tmlscli tmux list-clients
abbr -a tmlscmd tmux list-commands
abbr -a tmlsk tmus list-keys
abbr -a tmlspn tmus list-panes
abbr -a tmlsss tmux list-session
abbr -a tmlswd tmux list-window
abbr -a tmnss tmux new-session -s
abbr -a tmatc tmux attach -t
abbr -a tmksv tmux kill-server
abbr -a tmkss tmux kill-session -t
abbr -a tmswt tmux switch -t
abbr -a tmrnss tmux rename-session -t
abbr -a tmrnwd tmux rename-window -t

if test -e ~/proxy.fish
    source ~/proxy.fish unset 2>&1 > /dev/null
end

# function for proxy setting
function proxy
    if ! test -e ~/proxy.fish
        echo "Can not find file: ~/proxy.fish"
    else if test (count $argv) -gt 1
        echo "Usage: proxy [set|unset|debug]"
    else if test (count $argv) -eq 0
        source ~/proxy.fish set
    else
        switch $argv[1]
            case 'set' 'unset' 'debug'
                source ~/proxy.fish $argv[1]
            case '*'
                echo "Usage: proxy [set|unset|debug]"
        end
    end
end

# node for coc
set PATH $PATH ~/node-v20.13.0-linux-x64/bin
# the directory where user lib pip will install
set PATH $PATH ~/.local/bin

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
