#!/usr/bin/env bash

# chage sources
# this only works for Ubuntu 22.04 and Ubuntu 20.04
if which lsb_release && lsb_release -a | grep -i ubuntu; then
    UBUNTU_VERSION_NUMBER=$(lsb_release -a | sed -n 3p | awk '{print $2}')
    if [ "$UBUNTU_VERSION_NUMBER" = "22.04" ]; then
        sudo cat ./sources.list.tuna-22.04 | sudo tee /etc/apt/sources.list || exit 1
        sudo apt update || exit 1
    elif [ "$UBUNTU_VERSION_NUMBER" = "20.04" ]; then
        sudo cat ./sources.list.tuna-20.04 | sudo tee /etc/apt/sources.list || exit 1
        sudo apt update || exit 1
    else
        echo "source by yourself..."
    fi
fi

# basic tools
sudo apt install curl || exit 1
sudo apt-get install software-properties-common || exit

# install lazygit
if ! which lazygit; then
    cd ~ || exit 1
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') || exit 1
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" || exit 1
    tar xf lazygit.tar.gz lazygit || exit 1
    sudo install lazygit /usr/local/bin || exit 1
    rm -rf lazygit lazygit.tar.gz || exit 1
    cd - || exit 1
fi

# install fish3
if ! which fish; then
    sudo add-apt-repository ppa:fish-shell/release-3 || exit 1
    sudo apt update || exit 1
    sudo apt install fish || exit 1
    echo /usr/bin/fish | sudo tee -a /etc/shells || exit 1
    chsh -s /usr/bin/fish || exit 1
fi

# update vim to vim-9
VIM_VERSION=$(vim --version | sed -n 1p | awk '{print $5}')
if [ "$VIM_VERSION" != "9.0" ]; then
    sudo add-apt-repository ppa:jonathonf/vim || exit 1
    sudo apt update || exit 1
    sudo apt install vim vim-gtk universal-ctags ripgrep vim-nox || exit 1
fi

# vim-plug coc depends on nodejs
if ! which node; then
    cd ~ || exit 1
    wget https://nodejs.org/dist/v20.13.0/node-v20.13.0-linux-x64.tar.xz || exit 1
    tar -xf node-v20.13.0-linux-x64.tar.xz || exit 1
    rm -f node-v20.13.0-linux-x64.tar.xz
    cd - || exit 1
fi

# install vim plugins
vim +PlugInstall

# some tools for development
sudo apt install shellcheck build-essential cmake python3-dev pip pandoc || exit 1

# NOTE: this will use conda-pip, if your conda is activated
pip install cmake-language-server || exit 1

# now we do not ues ycm anymore
# cd ~/.vim/plugged/YouCompleteMe || exit 1
# python3 install.py --clangd-completer --force-sudo || exit 1

# clang family
sudo apt install clangd clang-format clang-tidy || exit 1

# sshfs
sudo apt install sshfs || exit 1

# sh language server
if ! sudo snap install bash-language-server --classic; then
    echo "bash-language-server installation failed, don't worry, you can install it manually."
fi

# install miniconda3
if ! which conda; then
    mkdir -p ~/miniconda3 || exit 1
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh || exit 1
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 || exit 1
    rm -rf ~/miniconda3/miniconda.sh || exit 1
    ~/miniconda3/bin/conda init bash || exit 1
    ~/miniconda3/bin/conda init fish || exit 1
fi

echo "Installation finished, but you may need restart your shell and run vim to install the extentsions for coc!!!"
