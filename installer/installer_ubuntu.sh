#!/usr/bin/env bash

log() {
    echo "$1" | tee -a installer_ubuntu.log
}

# this only runs on ubuntu
if ! grep -i ubuntu /etc/os-release; then
    log "this now only supports ubuntu"
    exit 1
fi

# change the apt source
# this only works for Ubuntu 22.04 and Ubuntu 20.04
# the original source.list will be renamed with source.list.bak
sudo_cmd=$(command -v sudo)
if grep 'VERSION="22.04' /etc/os-release; then
    ${sudo_cmd} cp /etc/apt/sources.list /etc/apt/sources.list.bak
    ${sudo_cmd} cat ./sources/ubuntu/tuna_22.04 | ${sudo_cmd} tee /etc/apt/sources.list || exit 1
    ${sudo_cmd} apt update || exit 1
elif grep 'VERSION="20.04' /etc/os-release; then
    ${sudo_cmd} cp /etc/apt/sources.list /etc/apt/sources.list.bak
    ${sudo_cmd} cat ./sources/ubuntu/tuna_20.04 | ${sudo_cmd} tee /etc/apt/sources.list || exit 1
    ${sudo_cmd} apt update || exit 1
else
    log "only support ubuntu-22.04 and ubuntu-20.04, change the source by yourself"
fi

# install sudo
if ! command -v sudo; then
    apt-get install -y sudo
fi

# basic tools
sudo apt install -y curl wget tar ripgrep || exit 1

# formater for python3
sudo apt install -y python3-autopep8

# lcov
sudo apt install -y lcov

# this is for add-apt-repository
sudo apt install -y software-properties-common || exit 1

# install fish 3
if ! command -v fish; then
    sudo add-apt-repository ppa:fish-shell/release-3 || exit 1
    sudo apt update || exit 1
    sudo apt install -y fish || exit 1
    fish_cmd=$(command -v fish)
    if ! grep "^$fish_cmd\$" /etc/shells; then
        echo "$fish_cmd" | sudo tee -a /etc/shells || exit 1
    fi
    # we only set fish as the login shell for non-root users
    if [ $UID != 0 ]; then
        # do not add sudo here, otherwise it will change root's login shell
        chsh -s "$fish_cmd" || exit 1
    fi
fi

# update vim to vim-9
if ! vim --version | grep '9\.0'; then
    sudo add-apt-repository ppa:jonathonf/vim || exit 1
    sudo apt update || exit 1
    sudo apt install -y vim vim-gtk vim-nox || exit 1
fi

# universal-ctags are used for the outlooks of markdown files
sudo apt install -y universal-ctags 

# install vim plugins
# after installation you may need quit vim manually by using :qa
# this will fail to install LeaaderF and markdown-preview,
# but don't worry, the script will solve this at last
vim +PlugInstall

# some tools for development
sudo apt install -y shellcheck build-essential net-tools cmake gdb python3-dev pip pandoc || exit 1

# cmake lsp
# NOTE: if your conda is activated, this will use conda-pip
pip install cmake-language-server || exit 1

# clang family
sudo apt install -y clangd clang-format clang-tidy || exit 1

# sshfs
sudo apt install -y sshfs || exit 1

# shell lsp
# this use snap to install
# you may install snap by yourself
# because installing snap may easily failed
if ! snap --version || ! sudo snap install bash-language-server --classic; then
    log "bash-language-server installation failed, don't worry, you can install it manually."
fi

# the first time to install markdownpreview and LeaderF will fail
# the simple way to solve this is to remove the LeaderF and markdownpreview, then reinstall them
if [ -d  ~/.vim/plugged/LeaderF ]; then
    rm -rf ~/.vim/plugged/LeaderF 
fi
if [ -d ~/.vim/plugged/markdown-preview.nvim ]; then
    rm -rf ~/.vim/plugged/markdown-preview.nvim
fi
vim +PlugInstall
vim '+CocInstall https://github.com/rafamadriz/friendly-snippets@main'

# tldr for manual docs
pip install tldr

#install docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
    docker-compose-plugin || exit 1

# change source for docker
sudo apt-get install -y ca-certificates gnupg-agent software-properties-common lsb-release || exit 1
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo \
    gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg || exit 1
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || exit 1

# restart docker
sudo systemctl restart docker || exit 1

log "Installation finished, but you may need restart your shell"
