#!/bin/bash

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
    ".p10k.zsh"
    # ".config/zsh/plugins/zsh-completions/src"
)
INSTALLATION_COMMANDS=()

SUDO=$(command -v sudo)

# arch linux related configurations
if grep -qi '^ID=arch' /etc/os-release; then
    INSTALLATION_COMMANDS+=(
        "$SUDO pacman -Sy --noconfirm curl git lazygit neovim tmux zsh zoxide nodejs"
    )
    DIRS+=(
        ".config/fontconfig"
        ".config/lazygit"
        ".config/wezterm"
    )
fi

log () {
    echo "INFO: $*"
}

log_error() {
    echo "ERROR: $*" >&2
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "VERBOSE: $*"
    fi
}

usage() {
    echo "Usage: $0 [OPTION]"
    echo "Set up dotfiles by creating symbolic links, or restoring from backup."
    echo ""
    echo "  -c, --create     Bakc up original files and create symbolic links."
    echo "  -i, --install    Install required packages."
    echo "  -r, --restore    Restore the original files from backup."
    echo "  -v, --verbose    Enable verbose output."
    echo "  -h, --help       Show this help message."
}

check_options() {
    if [ "$RESTORE" = false ] && [ "$CREATE_LINKS" = false ] && [ "$INSTALL_PACKAGES" = false ]; then
        log_error "No valid option provided. Please use -c, -i, or -r."
        usage
        return 1
    fi
    if [ "$RESTORE" = true ] && [ "$CREATE_LINKS" = true ]; then
        log_error "Cannot use both -c and -r options at the same time."
        usage
        return 1
    fi
}

init_options() {
    RESTORE=false
    VERBOSE=false
    INSTALL_PACKAGES=false
    CREATE_LINKS=false
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -r|--restore)
                RESTORE=true
                shift
                ;;
            -h|--help)
                usage
                return 1
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -i|--install)
                INSTALL_PACKAGES=true
                shift
                ;;
            -c|--create)
                CREATE_LINKS=true
                shift
                ;;
            *)
                log_erro "Unknown option: $1"
                usage
                return 1
                ;;
        esac
    done
    check_options
    return $?
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_verbose "Installing Oh My Zsh..."
        if ! sh -c "$(curl -fsSL \
            https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        then
            local error_code = $?
            log_error "Failed to install Oh My Zsh. " \
                "Please check your internet connection or the installation script."
            return $error_code
        fi
        log_verbose "Oh My Zsh installed successfully."
    else
        log_verbose "Oh My Zsh is already installed."
    fi
}

install_packages() {
    log "Start to install required packages."
    install_oh_my_zsh || return $?
    for cmd in "${INSTALLATION_COMMANDS[@]}"; do
        log_verbose "Executing command: $cmd"
        if ! eval "$cmd"; then
            log_error "Failed to execute command: $cmd. "\
                "Please check the command and your system configuration."
            return 1
        fi
        log_verbose "Command executed successfully: $cmd"
    done
    log "Packages installed successfully."
}

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

restore_one_file() {
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

find_files() {
    # check if the files array is already initialized
    if declare -p files &>/dev/null; then
        log_verbose "Files array is already initialized."
        return 0
    fi

    log_verbose "Start to update git submodules."
    if ! git submodule update --init --recursive; then
        log_error "Failed to update git submodules. Please check your git configuration."
        return 1
    fi
    log_verbose "Git submodules updated successfully."

    log_verbose "Start to find files in directories."
    files=()
    # Do not add double quotes around the array elements,
    # as it will cause issues with globbing and word splitting.
    for dir_or_file in ${DIRS[@]}; do
        if [ -d "$dir_or_file" ]; then 
            if ! mapfile -t tmp < <(
                find "$dir_or_file" \
                    \( -name ".git" -o -name ".github" \) -type d -prune -o \
                    -type f ! -name '*.md'
            ); then
                log_error "Failed to find files in $dir_or_file. "\
                    "Please check the directory path."
                return 1
            fi
            log_verbose "Found ${#tmp[@]} files in $dir_or_file."
            files+=("${tmp[@]}")
        elif [ -f "$dir_or_file" ]; then
            files+=("$dir_or_file")
            log_verbose "Found the file: $dir_or_file"
        else
            log_error "Directory or file $dir_or_file does not exist."
            return 1
        fi
    done
    log_verbose "Total ${#files[@]} files found."
}

restore_or_create() {
    find_files || return $?
    if [ "$1" = "restore" ]; then
        log "Restoring original files from backup."
    elif [ "$1" = "create" ]; then
        log "Creating symbolic links."
    else
        log_error "Invalid operation: $1. Use 'restore' or 'create'."
        return 1
    fi
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            if [ "$1" = "restore" ]; then
                restore_one_file "$REPO_ROOT/$file" "$HOME/$file" || return $?
            elif [ "$1" = "create" ]; then
                back_up_and_link "$REPO_ROOT/$file" "$HOME/$file" || return $?
            fi
        else
            log_error "File $file does not exist."
            return 1
        fi
    done
    if [ "$1" = "restore" ]; then
        log "All original files restored successfully."
    elif [ "$1" = "create" ]; then
        log "All symbolic links created successfully."
    fi
}

create() {
    restore_or_create create || return $?
}

restore() {
    restore_or_create restore || return $?
}

main() {
    init_options "$@" || return $?
    if [ "$INSTALL_PACKAGES" = true ]; then
        install_packages || return $?
    else
        log_verbose "Skipping package installation."
    fi
    if [ "$CREATE_LINKS" = true ]; then
        create || return $?
    else
        log_verbose "Skipping symbolic link creation."
    fi
    if [ "$RESTORE" = true ]; then
        restore || return $?
    else
        log_verbose "Skipping restoration of original files."
    fi
}

main "$@" || exit $?
