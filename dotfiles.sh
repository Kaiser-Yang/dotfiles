#!/bin/bash

print_usage() {
    echo "Usage: $0 [--restore]"
    echo "Set up dotfiles by creating symbolic links, or restoring from backup."
    echo ""
    echo "Options:"
    echo "  -r, --restore    Restore the original files from backup."
    echo "  -h, --help       Show this help message."
    echo "  -v, --verbose    Enable verbose output."
    exit 1
}

RUN_RESTORE=false
VERBOSE=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--restore)
            RUN_RESTORE=true
            shift
            ;;
        -h|--help)
            print_usage
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            print_usage
            ;;
    esac
done

REPO_ROOT=`pwd`
DIRS=(
    # nvim related configurations
    ".config/nvim"
    ".local/share/rime-ls/lua"
    ".local/share/rime-ls/opencc"
    ".local/share/rime-ls/*.yaml"
    ".local/share/rime-ls/*.lua"

    # tmux related configurations
    ".tmux.conf"
    ".config/tmux/plugins/catppuccin/catppuccin.tmux"
    ".config/tmux/plugins/tmux-battery/battery.tmux"
    ".config/tmux/plugins/tmux-cpu/cpu.tmux"
    ".config/tmux/plugins/tmux-yank/yank.tmux"
    ".config/tmux/plugins/conda_inherit.sh"

    # input method related configurations
    ".local/share/fcitx5/rime/colors"
    ".local/share/fcitx5/rime/icons"
    ".local/share/fcitx5/rime/lua"
    ".local/share/fcitx5/rime/opencc"
    ".local/share/fcitx5/rime/*.yaml"
    ".local/share/fcitx5/rime/*.lua"

    # zsh related configurations
    ".zshrc"
)
# arch linux related configurations
if grep -qi '^ID=arch' /etc/os-release; then
    DIRS+=(
        ".config/fontconfig"
        ".config/lazygit"
        ".config/wezterm"
    )
fi


log_error() {
    echo "ERROR: $1" >&2
}

log_and_exit() {
    log_error "$1"
    exit 1
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "VERBOSE: $1"
    fi
}

log_verbose "Start to update git submodules."
git submodule update --init --recursive || \
    log_and_exit "Failed to update git submodules. Please check your git configuration."
log_verbose "Git submodules updated successfully."

log_verbose "Start to find files in directories."
files=()
# Do not add double quotes around the array elements,
# as it will cause issues with globbing and word splitting.
for dir_or_file in ${DIRS[@]}; do
    if [ -d "$dir_or_file" ]; then 
        mapfile -t tmp < <(
            find "$dir_or_file" \
                \( -name ".git" -o -name ".github" \) -type d -prune -o \
                -type f ! -name '*.md'
        ) || log_and_exit "Failed to find files in $dir_or_file. Please check the directory path."
        log_verbose "Found ${#tmp[@]} files in $dir_or_file."
        files+=("${tmp[@]}")
    elif [ -f "$dir_or_file" ]; then
        files+=("$dir_or_file")
        log_verbose "Found the file: $dir_or_file"
    else
        log_and_exit "Directory or file $dir_or_file does not exist."
    fi
done
log_verbose "Total ${#files[@]} files found."

back_up_and_link() {
    local src="$1"
    local dst="$2"
    if [ ! -e "$src" ]; then
        log_error "Source file $src does not exist. Please check the file path."
        return 1
    fi
    if [ -e "$dst" ]; then
        if [ "$(readlink -f "$dst")" = "$(realpath "$src")" ]; then
            log_verbose "Skip same file $src <--> $dst."
            return 0
        fi
        # Back up existing $dest to $dest.bak
        log_verbose "Backing up existing $dst to $dst.bak."
        if ! mv "$dst" "$dst.bak"; then
            log_error "Failed to back up $dst. Please check the file path."
            return 1
        fi
        log_verbose "Backup of $dst created as $dst.bak."
    else
        # Create parent directories if they do not exist
        mkdir -p "$(dirname "$dst")" || {
            log_error "Failed to create parent directories for $dst. Please check the path."
            return 1
        }
        log_verbose "No existing file at $dst, no backup needed."
    fi
    # Create a symbolic link: $dst --> $src
    if ! ln -s "$src" "$dst"; then
        log_error "Failed to create symbolic link from $src to $dst. Please check the file path."
        return 1
    fi
}

restore() {
    local src="$1"
    local dst="$2"
    if [ "$(readlink -f "$dst")" = "$(realpath "$src")" ]; then
        log_verbose "Removing existing $dst before restoring from backup."
        rm -f "$dst" || {
            log_error "Failed to remove existing $dst. Please check the file path."
            return 1
        }
        log_verbose "Removed existing $dst."
    elif [ -e "$dst" ]; then
        log_error "Cannot restore $dst because it is not a symbolic link to $src."
        return 1
    fi
    if [ ! -e "$dst.bak" ]; then
        log_verbose "No backup found for $dst."
        return 0
    fi
    log_verbose "Restoring $dst from backup $dst.bak."
    mv "$dst.bak" "$dst" || {
        log_error "Failed to restore $dst from backup. Please check the file path."
        return 1
    }
    log_verbose "Restored $dst from backup successfully."
}

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        if [ "$RUN_RESTORE" = true ]; then
            restore "$REPO_ROOT/$file" "$HOME/$file" || exit 1
        else
            back_up_and_link "$REPO_ROOT/$file" "$HOME/$file" || exit 1
        fi
    else
        log_and_exit "File $file does not exist."
    fi
done
