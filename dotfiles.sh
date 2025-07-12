#!/bin/bash

REPO_ROOT=$(pwd)
DIRS=(
    # nvim related configurations
    ".config/nvim"
    ".local/share/rime-ls"

    # tmux related configurations
    ".tmux.conf"
    ".config/tmux/plugins"

    # zsh related configurations
    ".zshrc"
    ".p10k.zsh"
    ".config/zsh/plugins/zsh-completions/src"
    ".config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
    ".config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
    ".config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
    # zsh-vi-mode do not expand to absolute path, and we must add 'zsh-vi-mode.zsh' here
    ".config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.zsh"
    ".config/zsh/plugins/zsh-expand/zsh-expand.plugin.zsh"
    ".config/zsh/themes/powerlevel10k"

    # lazygit related configurations
    ".config/lazygit"
)
# The reason why we use both `REQUIRED_EXECUTABLES` and `INSTALLATION_COMMANDS`
# is to control the sequence of installation commands.
REQUIRED_EXECUTABLES=(
    "curl"
    "wget"
    "tar"
    "git"
    "lazygit"
    "nvim"
    "tmux"
    "zsh"
    "zoxide"
    "node"
    "rg"
    "rime_ls"
    "wn"
)
declare -A INSTALLATION_COMMANDS
COMMANDS_AFTER_INSTALLATION=()

if [[ "$XDG_CURRENT_DESKTOP" == 'KDE' ]]; then
    DIRS+=(
        ".config/autostart/keyd-application-mapper.desktop"
    )
fi
# Configurations that require a graphical interface
if [[ -n "$DISPLAY" || "$(uname)" == "Darwin" ]]; then
    DIRS+=(
        # input method related configurations
        ".local/share/fcitx5/rime"
        # terminal
        ".config/wezterm"
    )
fi
SUDO=$(command -v sudo)
# Arch linux related configurations
if grep -qi '^ID=arch' /etc/os-release &> /dev/null; then
    if [ -n "$DISPLAY" ]; then
        REQUIRED_EXECUTABLES+=(
            "fcitx5-im"
            "fcitx5-rime"
            "keyd"
            "wezterm"
        )
    fi
    REQUIRED_EXECUTABLES+=(
        "base-devel" # required to compile yay
        "yay"
    )
    INSTALLATION_COMMANDS+=(
        [curl]="$SUDO pacman -Sy --noconfirm curl"
        [wget]="$SUDO pacman -Sy --noconfirm wget"
        [tar]="$SUDO pacman -Sy --noconfirm tar"
        [git]="$SUDO pacman -Sy --noconfirm git"
        [lazygit]="$SUDO pacman -Sy --noconfirm lazygit"
        [nvim]="$SUDO pacman -Sy --noconfirm neovim"
        [tmux]="$SUDO pacman -Sy --noconfirm tmux"
        [zsh]="$SUDO pacman -Sy --noconfirm zsh"
        [zoxide]="$SUDO pacman -Sy --noconfirm zoxide"
        [node]="$SUDO pacman -Sy --noconfirm nodejs"
        [rg]="$SUDO pacman -Sy --noconfirm ripgrep"
        [base-devel]="$SUDO pacman -Sy --noconfirm base-devel"
        [yay]="git clone https://aur.archlinux.org/yay.git &&
            cd yay && \
            makepkg -si && \
            cd .. && rm -rf yay"
        [wn]="yay -Sy --noconfirm wordnet-common"
        [rime_ls]="yay -Sy --noconfirm rime-ls"
        [fcitx5-im]="$SUDO pacman -Sy --noconfirm fcitx5-im"
        [fcitx5-rime]="$SUDO pacman -Sy --noconfirm fcitx5-rime"
        [keyd]="$SUDO pacman -Sy --noconfirm keyd"
        [wezterm]="$SUDO pacman -Sy --noconfirm wezterm"
    )
    DIRS+=(
        ".config/fontconfig/fonts_arch.conf"
    )
# Ubuntu related configurations
elif grep -qi '^ID=ubuntu' /etc/os-release &> /dev/null; then
    DIRS+=(".config/fontconfig/fonts_ubuntu.conf")
    LAZYGIT_VERSION=$(curl -s \
        https://api.github.com/repos/jesseduffield/lazygit/releases/latest | \
        \grep -Po '"tag_name": *"v\K[^"]*')
    if [ -n "$DISPLAY" ]; then
        # WARN:
        # Those packages are not checked
        REQUIRED_EXECUTABLES+=(
            "fcitx5"
            "fcitx5-chinese-addons"
            "fcitx5-diagnose"
            "gpg" # required for wezterm installation
            "wezterm"
            "keyd"
        )
    fi
    # The 'update_package_list' is a placeholder for the command to update package list
    REQUIRED_EXECUTABLES=("_update_package_list" "${REQUIRED_EXECUTABLES[@]}")
    INSTALLATION_COMMANDS+=(
        [_update_package_list]="$SUDO apt update"
        [curl]="$SUDO apt install -y curl"
        [wget]="$SUDO apt install -y wget"
        [tar]="$SUDO apt install -y tar"
        [git]="$SUDO apt install -y git"
        [lazygit]="[[ $(uname -m) == 'x86_64' ]] &&
            curl -Lo lazygit.tar.gz \
                https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz && \
            tar xf lazygit.tar.gz lazygit && \
            $SUDO install lazygit -D -t /usr/local/bin/ && \
            rm -f lazygit.tar.gz lazygit"
        [nvim]="$SUDO apt install -y neovim"
        [tmux]="$SUDO apt install -y tmux"
        [zsh]="$SUDO apt install -y zsh"
        [zoxide]="$SUDO apt install -y zoxide"
        [node]="$SUDO apt install -y nodejs"
        [rg]="$SUDO apt install -y ripgrep"
        [rime_ls]="$SUDO apt install -y librime-dev && custom_install rime_ls"
        [wn]="$SUDO apt install -y wordnet" 
        [fcitx5]="$SUDO apt install -y fcitx5"
        [fcitx5-chinese-addons]="$SUDO apt install -y fcitx5-chinese-addons"
        [fcitx5-diagnose]="$SUDO apt install -y fcitx5-diagnose"
        [gpg]="$SUDO apt install -y gnupg"
        [wezterm]="apt list &> /dev/null && \
            curl -fsSL https://apt.fury.io/wez/gpg.key | \
                $SUDO gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
            echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | \
                $SUDO tee /etc/apt/sources.list.d/wezterm.list
            $SUDO chmod 644 /usr/share/keyrings/wezterm-fury.gpg &&
            $SUDO apt update && $SUDO apt install -y wezterm"
        [keyd]="git clone https://github.com/rvaiya/keyd && \
            cd keyd && make && $SUDO make install && \
            cd .. && rm -rf keyd"
    )
# macOS related configurations
elif [[ "$(uname)" == "Darwin" ]]; then
    DIRS+=(".config/fontconfig/fonts_mac.conf")
    REQUIRED_EXECUTABLES=(
        "brew"
        "_update_package_list"
        "${REQUIRED_EXECUTABLES[@]}"
        "wezterm"
        "squirrel"
    )
    INSTALLATION_COMMANDS+=(
        [brew]="custom_install brew"
        [_update_package_list]="brew update"
        [curl]="brew install curl"
        [wget]="brew install wget"
        [tar]="brew install gnu-tar"
        [git]="brew install git"
        [lazygit]="brew install lazygit"
        [nvim]="brew install neovim"
        [tmux]="brew install tmux"
        [zsh]="brew install zsh"
        [zoxide]="brew install zoxide"
        [node]="brew install node"
        [rg]="brew install ripgrep"
        [rime_ls]="brew install librime && install rime_ls"
        [wn]="brew install wordnet"
        # macOS should hava GUI always, we do not need to check it
        [wezterm]="brew install --cask wezterm"
        [squirrel]="brew install --cask squirrel"
    )
fi
# Configurations for all Linux distributions
if [[ "$(uname)" == "Linux" ]]; then
    DIRS+=(
        ".config/keyd/config"
        ".config/keyd/app.conf"
    )
fi

# This will check if a command or package is installed.
# Usage: is_installed <expected_executable> <package_manager> <package_name>
# Returns:
#     0  if installed
#     1  if not installed
#     2  if an error occurred (e.g., unsupported package manager)
is_installed() {
    if [ -z "$3" ]; then
        log_error "Usage: is_installed <expected_executable> <package_manager> <package_name>"
        return 2
    fi
    local expected_executable="$1"
    if command -v "$expected_executable" &>/dev/null; then
        log_verbose "Command '$expected_executable' is installed."
        return 0
    fi
    local package_manager="$2"
    if ! command -v "$package_manager" &>/dev/null; then
        log_error "Package manager '$package_manager' is not installed."
        return 2
    fi
    local package_name="$3"
    if [[ "$package_manager" == "apt" ]]; then
        if ! command -v dpkg &>/dev/null; then
            log_error "dpkg is not installed. Please install dpkg first."
            return 2
        fi
        if ! dpkg -s "$package_name" &>/dev/null; then
            log_verbose "Package '$package_name' is not installed."
            return 1
        fi
    elif [[ "$package_manager" == "pacman" || "$package_manager" == 'yay' ]]; then
        if  "$package_manager" -Q "$package_name" &> /dev/null || \
            "$package_manager" -Qg "$package_name" &> /dev/null; then
            cat /dev/null
        else
            log_verbose "Package '$package_name' is not installed."
            return 1
        fi
    elif [[ "$package_manager" == "brew" ]]; then
        if ! "$package_manager" list --formula | grep -wq "$package_name" || \
            "$package_manager" list --cask | grep -wq "$package_name"; then
            log_verbose "Package '$package_name' is not installed."
            return 1
        fi
    else
        log_error "Unsupported package manager: $package_manager"
        return 2
    fi
    log_verbose "Package '$package_name' is installed, but '$expected_executable' is not found."
}

# Usage: check_and_install_package <expected_executable> <installation_command>
# Note: the last argument is the package name, and you can only install one package at a time.
check_and_install_package() {
    local expected_executable="$1"
    local installation_command="${*:2}"
    IFS=" " read -r -a cmd_array <<< "$installation_command"
    local package_manager="${cmd_array[0]}"
    [[ "$package_manager" == "$SUDO" ]] && package_manager="${cmd_array[1]}"
    local package_name="${cmd_array[-1]}"
    is_installed "$expected_executable" "$package_manager" "$package_name"
    local res=$?
    if [ "$res" -eq 1 ]; then
        log_verbose "Command '$expected_executable' is not installed. Installing..."
        log_verbose "Installation command: $installation_command"
        if ! "${cmd_array[@]}"; then
            log_error "Failed to install '$expected_executable'. "\
                "Please check the installation command."
            return 1
        fi
        log_verbose "'$expected_executable' installed successfully."
        return 0
    elif [ "$res" -eq 2 ]; then
        log_verbose "An error occurred while checking '$expected_executable'."
        return "$res"
    fi
}

# Destination path for symbolic links
get_destination() {
    local file="$1"
    if [[ "$(uname)" == "Darwin" && "$file" == ".local/share/fcitx5/rime"* ]]; then
        file="${file#".local/share/fcitx5/rime"}"
        if [[ "$file" == "" ]]; then
            echo "$HOME/Library/Rime"
            return
        fi
        echo "$HOME/Library/Rime/$file"
    elif [[ "$file" == ".config/keyd/config" ]]; then
        echo "/etc/keyd/default.conf"
    elif [[ "$file" == ".config/fontconfig"* ]]; then
        echo "$HOME/.config/fontconfig/fonts.conf"
    else
        echo "$HOME/$file"
    fi
}

log () {
    echo "INFO: $*" >&2
}

log_error() {
    echo "ERROR: $*" >&2
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo "VERBOSE: $*" >&2
    fi
}

usage() {
    echo "Usage: $0 [OPTION]"
    echo "Set up dotfiles by creating symbolic links, or restoring from backup."
    echo ""
    echo "  -c, --create     Bakc up original files and create symbolic links."
    echo "  -i, --install    Install required packages."
    echo "  -f, --fonts      Install optional fonts."
    echo "  -r, --restore    Restore the original files from backup."
    echo "  -s, --change     Change the default shell to zsh."
    echo "  -e, --extract    Extract files from directories. When use this with -c,"
    echo "                   it will create symbolic links for every file in directories."
    echo "                   You should use this with -r when you use it with -c."
    echo "  -v, --verbose    Enable verbose output."
    echo "  -h, --help       Show this help message."
}

check_options() {
    if [[ "$RESTORE" == false && "$CREATE_LINKS" == false && "$INSTALL_PACKAGES" == false && \
          "$INSTALL_FONTS" == false && "$CHANGE_SHELL" == false ]]; then
        log_error "No valid option provided. Please use -c, -i, -s, or -r."
        usage
        return 1
    fi
    if [[ "$RESTORE" == true && "$CREATE_LINKS" == true ]]; then
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
    EXTRACT=false
    INSTALL_FONTS=false
    CHANGE_SHELL=false
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --restore)
                RESTORE=true
                shift
                ;;
            --help)
                usage
                return 1
                ;;
            --verbose)
                VERBOSE=true
                shift
                ;;
            --install)
                INSTALL_PACKAGES=true
                shift
                ;;
            --create)
                CREATE_LINKS=true
                shift
                ;;
            --extract)
                EXTRACT=true
                shift
                ;;
            --fonts)
                INSTALL_FONTS=true
                shift
                ;;
            --change)
                CHANGE_SHELL=true
                shift
                ;;
            -*)
                short_opts="${1:1}"
                for ((i=0; i<${#short_opts}; i++)); do
                    case "${short_opts:$i:1}" in
                        r) RESTORE=true ;;
                        h) usage; return 1 ;;
                        v) VERBOSE=true ;;
                        i) INSTALL_PACKAGES=true ;;
                        c) CREATE_LINKS=true ;;
                        e) EXTRACT=true ;;
                        f) INSTALL_FONTS=true ;;
                        s) CHANGE_SHELL=true ;;
                        *) log_erro "Unknown option: -${short_opts:$i:1}"; usage; return 1 ;;
                    esac
                done
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

custom_install() {
    eval install_"$1" || return "$?"
}

install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log_verbose "Installing Oh My Zsh..."
        if ! sh -c "$(curl -fsSL \
            https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        then
            local error_code=$?
            log_error "Failed to install Oh My Zsh. " \
                "Please check your internet connection or the installation script."
            return $error_code
        fi
        log_verbose "Oh My Zsh installed successfully."
    else
        log_verbose "Oh My Zsh is already installed."
    fi
}

install_brew() {
    if ! command -v brew &>/dev/null; then
        log_verbose "Installing Home brew..."
        if ! bash -c "$(curl -fsSL \
            https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
            local error_code=$?
            log_error "Failed to install Home brew. "\
                "Please check your internet connection or the installation script."
            return $error_code
        fi
        log_verbose "Home brew installed successfully."
    else
        log_verbose "Home brew is already installed."
    fi
}
install_rime_ls() {
    if command -v rime_ls &>/dev/null; then
        log_verbose "rime_ls is already installed."
        return 0
    fi
    log_verbose "Installing rime_ls..."
    if ! command -v wget &>/dev/null; then
        log_error "wget is not installed. Please install wget first."
        return 1
    fi
    if ! command -v tar &>/dev/null; then
        log_error "tar is not installed. Please install tar first."
        return 1
    fi
    local RIME_LS_RELEASE_URL="https://github.com/wlh320/rime-ls/releases"
    local RIME_LS_TAG="v0.4.3"
    local RIME_LS_PACKAGE_NAME=""
    local RIME_LS_TARGET=""
    if [[ "$(uname -s)" == "Linux" ]]; then
        if [[ "$(uname -m)" == "x86_64" ]]; then
            RIME_LS_PACKAGE_NAME=rime-ls-$RIME_LS_TAG-x86_64-unknown-linux-gnu.tar.gz
            RIME_LS_TARGET="rime-ls.tar.gz"
        else
            log_error "Unsupported architecture: $(uname -m). Only x86_64 is supported."
            return 1
        fi
    elif [[ "$(uname -s)" == "Darwin" ]]; then
        RIME_LS_PACKAGE_NAME=rime-ls-$RIME_LS_TAG-universal2-apple-darwin.tar.bz2
        RIME_LS_TARGET="rime-ls.tar.bz2"
    else
        log_error "Unsupported operating system: $(uname -s)."
        return 1
    fi
    local RIME_LS_TARGET_EXTENSION="${RIME_LS_TARGET##*.}"
    local RIME_LS_URL="$RIME_LS_RELEASE_URL/download/$RIME_LS_TAG/$RIME_LS_PACKAGE_NAME"
    log_verbose "Downloading rime_ls from $RIME_LS_URL..."
    wget -O $RIME_LS_PACKAGE_NAME $RIME_LS_URL || {
        log_error "Failed to download rime_ls from $RIME_LS_URL. "\
            "Please check your internet connection or the URL."
        return 1
    }
    log_verbose "Downloaded rime_ls package: $RIME_LS_PACKAGE_NAME"
    log_verbose "Extracting rime_ls package..."
    if [[ "$RIME_LS_TARGET_EXTENSION" == "gz" ]]; then
        tar -xzf $RIME_LS_PACKAGE_NAME || {
            log_error "Failed to extract rime_ls package. "\
                "Please check the package integrity or the extraction command."
            return 1
        }
    elif [[ "$RIME_LS_TARGET_EXTENSION" == "bz2" ]]; then
        tar -xjf $RIME_LS_PACKAGE_NAME || {
            log_error "Failed to extract rime_ls package. "\
                "Please check the package integrity or the extraction command."
            return 1
        }
    else
        log_error "Unknown package format: $RIME_LS_TARGET. "\
            "Please check the RIME_LS_PACKAGE_NAME variable."
        return 1
    fi
    log_verbose "Extracted rime_ls package successfully."
    if ! eval "$SUDO cp rime_ls /usr/local/bin/ && rm -rf $RIME_LS_TARGET rime_ls"; then
        log_error "Failed to install rime_ls. Please check the installation script."
        return 1
    fi
}

install_packages() {
    log "Start to install required packages."
    for executable in "${REQUIRED_EXECUTABLES[@]}"; do
        local cmd=${INSTALLATION_COMMANDS[$executable]}
        if ! check_and_install_package "$executable" "$cmd"; then
            log_error "Failed to run cehck_and_install_package for $executable, with cmd:" \
                "$cmd" \
                "Please check the command and your system configuration."
            return 1
        fi
        if [ "$executable" = "keyd" ]; then
            # Add keyd service commands to COMMANDS_AFTER_INSTALLATION
            COMMANDS_AFTER_INSTALLATION+=(
                "$SUDO systemctl enable --now keyd"
                "$SUDO usermod -aG keyd $USER"
            )
        elif [[ "$executable" == "zsh" ]]; then
            COMMANDS_AFTER_INSTALLATION+=(
                "install_oh_my_zsh"
            )
        fi
        log_verbose "Command executed successfully: $cmd"
    done
    for cmd in "${COMMANDS_AFTER_INSTALLATION[@]}"; do
        log_verbose "Executing command after installation: $cmd"
        if ! eval "$cmd"; then
            log_error "Failed to execute command after installation: $cmd" \
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
    local sudo_cmd
    local dst_dir
    dst_dir=$(dirname "$dst")
    if [[ "$dst" == "/etc"* || "$src" == "/etc"* ]]; then
        sudo_cmd="$SUDO"
    fi
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
        if ! eval "$sudo_cmd mv $dst $dst.bak"; then
            log_error "Failed to back up $dst. Please check the file path."
            return 1
        fi
        log_verbose "Backup of $dst created as $dst.bak."
    elif [ ! -d "$dst_dir" ]; then
        # Create parent directories if they do not exist
        eval "$sudo_cmd mkdir -p $dst_dir" || {
            log_error "Failed to create parent directories for $dst. Please check the path."
            return 1
        }
        log_verbose "No existing file at $dst, no backup needed."
    fi
    # Create a symbolic link: $dst --> $src
    if ! eval "$sudo_cmd ln -s $src $dst"; then
        log_error "Failed to create symbolic link from $src to $dst. Please check the file path."
        return 1
    fi
}

restore_one_file() {
    local src="$1"
    local dst="$2"
    local sudo_cmd
    if [[ "$dst" == "/etc"* || "$src" == "/etc"* ]]; then
        sudo_cmd="$SUDO"
    fi
    if [ "$(readlink -f "$dst")" = "$(realpath "$src")" ]; then
        log_verbose "Removing existing $dst before restoring from backup."
        eval "$sudo_cmd rm -f $dst" || {
            log_error "Failed to remove existing $dst. Please check the file path."
            return 1
        }
        log_verbose "Removed existing $dst."
    elif [ -e "$dst" ]; then
        log_error "Cannot restore $dst because it is not a symbolic link to $src. " \
            "If you create symbolic links with -e, you should use -e when restoring."
        return 1
    fi
    if [ ! -e "$dst.bak" ]; then
        log_verbose "No backup found for $dst."
        return 0
    fi
    log_verbose "Restoring $dst from backup $dst.bak."
    eval "$sudo_cmd mv $dst.bak $dst" || {
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
    for dir_or_file in "${DIRS[@]}"; do
        if [[ -d "$dir_or_file" && "$EXTRACT" = true ]]; then
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
        elif [[ -d "$dir_or_file" && "$EXTRACT" = false ]]; then
            files+=("$dir_or_file")
            log_verbose "Found the directory: $dir_or_file"
        elif [ -f "$dir_or_file" ]; then
            files+=("$dir_or_file")
            log_verbose "Found the file: $dir_or_file"
        else
            log_error "Directory or file $dir_or_file does not exist."
            return 1
        fi
    done
    log_verbose "Total ${#files[@]} files or directories found."
}

restore_or_create() {
    find_files || return $?
    if [ "$1" = "restore" ]; then
        log "Start to restore original files from backup."
    elif [ "$1" = "create" ]; then
        log "Start to creat symbolic links."
    else
        log_error "Invalid operation: $1. Use 'restore' or 'create'."
        return 1
    fi
    for file in "${files[@]}"; do
        if [ -e "$file" ]; then
            local dst
            dst=$(get_destination "$file")
            if [ "$1" = "restore" ]; then
                restore_one_file "$REPO_ROOT/$file" "$dst" || return $?
            elif [ "$1" = "create" ]; then
                back_up_and_link "$REPO_ROOT/$file" "$dst" || return $?
            fi
            if [ "$dst" = "/etc/keyd/default.conf" ]; then
                eval "! command -v keyd &> /dev/null || $SUDO keyd reload"
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

change_shell_to_zsh() {
    log "Start to change default shell to zsh."
    if [[ -z "$SHELL" || "$(basename "$SHELL")" != "zsh" ]]; then
        log_verbose "Changing default shell to zsh."
        if ! command -v zsh &>/dev/null; then
            log_error "zsh is not installed. Please install zsh first."
            return 1
        fi
        if ! grep -q "$(command -v zsh)" /etc/shells; then
            log_verbose "Adding zsh to /etc/shells."
            eval "command -v zsh | $SUDO tee -a /etc/shells > /dev/null" || {
                log_error "Failed to add zsh to /etc/shells. Please check your permissions."
                return 1
            }
            log_verbose "zsh added to /etc/shells successfully."
        else
            log_verbose "zsh is already in /etc/shells."
        fi
        if ! chsh -s "$(command -v zsh)"; then
            log_error "Failed to change default shell to zsh. " \
                "Please check your system configuration."
            return 1
        fi
        log_verbose "Default shell changed to zsh successfully."
    else
        log_verbose "Default shell is already zsh."
    fi
    log "Default shell changed to zsh successfully."
}

create() {
    restore_or_create create || return $?
}

restore() {
    restore_or_create restore || return $?
}

install_fonts() {
    log "Start to install fonts."
    local fonts=()
    local command
    if grep -qi '^ID=arch' /etc/os-release &> /dev/null; then
        command="$SUDO pacman -Sy --noconfirm"
        fonts+=(
            adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
            noto-fonts-cjk
            wqy-microhei wqy-microhei-lite wqy-bitmapfont wqy-zenhei
            ttf-arphic-ukai ttf-arphic-uming ttf-cascadia-mono-nerd
        )
    elif grep -qi '^ID=ubuntu' /etc/os-release &> /dev/null; then
        log_error "Fonts installation for Ubuntu is not implemented yet. "
    elif [[ "$(uname)" == "Darwin" ]]; then
        if ! command -v brew &>/dev/null; then
            log_error "Homebrew is not installed. Please install Homebrew first."
            return 1
        fi
        command='brew install --cask'
        fonts+=(font-caskaydia-mono-nerd-font)
    fi
    for font in "${fonts[@]}"; do
        check_and_install_package "$font" "$command $font" || {
            log_error "Failed to install font: $font. Please check the installation command."
            return 1
        }
    done
    if [[ "$(uname)" == "Linux" ]]; then
        fc-cache -f &> /dev/null || {
            log_error "Failed to update font cache. Please check your fonts installation."
            return 1
        }
    fi
    log "Fonts installed successfully."
}

main() {
    init_options "$@" || return $?
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
    if [ "$INSTALL_FONTS" = true ]; then
        install_fonts || return $?
    else
        log_verbose "Skipping fonts installation."
    fi
    if [ "$INSTALL_PACKAGES" = true ]; then
        install_packages || return $?
    else
        log_verbose "Skipping package installation."
    fi
    if [ "$CHANGE_SHELL" = true ]; then
        change_shell_to_zsh || return $?
    else
        log_verbose "Skipping changing default shell to zsh."
    fi
}

main "$@" || exit $?
