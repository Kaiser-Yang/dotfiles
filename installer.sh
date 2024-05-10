#!/usr/bin/env bash

# this only runs on ubuntu
if which lsb_release && ! lsb_release -a | grep -i ubuntu; then
    echo "this now only support ubuntu" | tee installer.log
    exit 1
fi

# change the apt source
# this only works for Ubuntu 22.04 and Ubuntu 20.04
# the original source.list will be renamed with source.list.bak
if which lsb_release && lsb_release -a | grep -i ubuntu; then
    if lsb_release -a | grep '22\.04'; then
        SUDO_COMMAND=$(which sudo)
        ${SUDO_COMMAND} cp /etc/apt/sources.list /etc/apt/sources.list.bak
        ${SUDO_COMMAND} cat ./sources.list.tuna-22.04 | sudo tee /etc/apt/sources.list || exit 1
        ${SUDO_COMMAND} cat ./sources.list.tuna-22.04 | sudo tee /etc/apt/sources.list || exit 1
        ${SUDO_COMMAND} apt update || exit 1
    elif lsb_release -a | grep '20\.04'; then
        ${SUDO_COMMAND} cp /etc/apt/sources.list /etc/apt/sources.list.bak
        ${SUDO_COMMAND} cat ./sources.list.tuna-20.04 | sudo tee /etc/apt/sources.list || exit 1
        ${SUDO_COMMAND} apt update || exit 1
    else
        echo "only support ubuntu-22.04 and ubuntu-20.04, change the source by yourself" | \
            tee installer.log
    fi
else
    echo "have no lsb_release installed, change the source by yourself" | tee installer.log
fi

# install sudo
if ! which sudo; then
    apt-get install sudo
fi

# basic tools
sudo apt install -y curl tar ripgrep || exit 1

# install lazygit
# this now only works for x86_64
if ! which lazygit && [ "$(arch)" = 'x86_64' ]; then
    cd ~ || exit 1
    LAZYGIT_VERSION=$(curl -s \
        "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \
        grep -Po '"tag_name": "v\K[^"]*') || exit 1
    curl -Lo lazygit.tar.gz \
        "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
        || exit 1
    tar -xf lazygit.tar.gz lazygit || exit 1
    sudo install lazygit /usr/local/bin || exit 1
    rm -rf lazygit lazygit.tar.gz || exit 1
    cd - || exit 1
fi

# this is for add-apt-repository
sudo apt install -y software-properties-common || exit 1

# install fish 3
if ! which fish && which add-apt-repository; then
    sudo add-apt-repository ppa:fish-shell/release-3 || exit 1
    sudo apt update || exit 1
    sudo apt install -y fish || exit 1
    FISH_COMMEND=$(which fish)
    if ! grep "^$FISH_COMMEND\$" /etc/shells; then
        echo "$FISH_COMMEND" | sudo tee -a /etc/shells || exit 1
    fi
    # we only set fish as the login shell for non-root users
    if [ $UID != 0 ]; then
        # do not add sudo here, otherwise it will change root's login shell
        chsh -s "$FISH_COMMEND" || exit 1
    fi
fi

# update vim to vim-9
if ! vim --version | grep '9\.0'; then
    sudo add-apt-repository ppa:jonathonf/vim || exit 1
    sudo apt update || exit 1
    sudo apt install -y vim vim-gtk vim-nox || exit 1
fi

# vim-plug coc depends on nodejs
if ! which node; then
    cd ~ || exit 1
    wget https://nodejs.org/dist/v20.13.0/node-v20.13.0-linux-x64.tar.xz \
        -O node-v20.13.0-linux-x64.tar.xz || exit 1
    tar -xf node-v20.13.0-linux-x64.tar.xz || exit 1
    rm -f node-v20.13.0-linux-x64.tar.xz
    cd - || exit 1
fi

# universal-ctags are used for the outlooks of markdown files
sudo apt install universal-ctags 

# install vim plugins
# after installation you may need quit vim manually by using :qa
# this will fail to install LeaaderF and markdown-preview,
# but don't worry, the script will solve this at last
vim +PlugInstall

# some tools for development
sudo apt install -y shellcheck build-essential cmake gdb python3-dev pip pandoc || exit 1

# cmake lsp
# NOTE: if your conda is activated, this will use conda-pip
pip install cmake-language-server || exit 1

# clang family
sudo apt install -y clangd clang-format clang-tidy || exit 1

# sshfs
sudo apt install -y sshfs || exit 1

# sh lsp
# this use snap to install
# you may isntall snap by yourself
if ! which snap || ! sudo snap install bash-language-server --classic; then
    echo "bash-language-server installation failed, don't worry, you can install it manually." | \
        tee installer.log
fi

# install miniconda3
if ! which conda; then
    mkdir -p ~/miniconda3 || exit 1
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
        -O ~/miniconda3/miniconda.sh || exit 1
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 || exit 1
    rm -rf ~/miniconda3/miniconda.sh || exit 1
    ~/miniconda3/bin/conda init bash || exit 1
    ~/miniconda3/bin/conda init fish || exit 1
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

echo "Installation finished, "
echo "but you may need restart your shell and run vim to install the extentsions for coc!!!"
