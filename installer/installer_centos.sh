#!/usr/bin/env bash

log(){
    echo "$1" | tee -a installer_centos.log
}

# this only runs on centos 
if ! grep -i centos /etc/os-release;then
    log "this now only supports centos"
    exit 1
fi

# change the yum source
# this only works for centos7 and centos8
# the original Centos-Base.repo will be renamed with Centos-Base.repo.bak
sudo_cmd=$(command -v sudo)
if grep 'VERSION="7' /etc/os-release; then
    ${sudo_cmd} sed -e 's|^mirrorlist=|#mirrorlist=|g' \
        -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
        -i.bak \
        /etc/yum.repos.d/CentOS-*.repo || exit 1
    ${sudo_cmd} yum -y makecache || exit 1
    ${sudo_cmd} yum -y update || exit 1
elif grep 'VERSION="8' /etc/os-release;then
        ${sudo_cmd} sed -e 's|^mirrorlist=|#mirrorlist=|g' \
            -e 's|^#baseurl=http://mirror.centos.org/$contentdir|baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos|g' \
            -i.bak \
            /etc/yum.repos.d/CentOS-*.repo || exit 1
        ${sudo_cmd} yum -y makecache || exit 1
        ${sudo_cmd} yum -y update || exit 1
else
    log "only support centos7 and centos8,change the source by yourself"
fi

# install sudo
if ! ${sudo_cmd} --version;then
    ${sudo_cmd} yum install -y sudo
fi

# basic tools
${sudo_cmd} yum install -y curl wget tar ripgrep || exit 1


# this is for add-yum-repository
sudo yum install -y yum-utils || exit 1
sudo yum install -y epel-release || exit 1

# install fish 3
if ! command -v fish; then
    url="https://download.opensuse.org/repositories/shells:fish:release:3/CentOS_"
    if grep 'VERSION="8' /etc/os-release; then
        url="${url}8/shells:fish:release:3.repo"
     # centos6
    elif grep 'VERSION="7' /etc/os-release; then
        url="${url}7/shells:fish:release:3.repo"
    else 
        url=""
    fi
    if [ -z "$url" ]; then
        log "only support CentOS 8 and 7"
    fi

    sudo wget "$url" -O /etc/yum.repos.d/fish.repo || exit 1
    sudo yum install -y fish || exit 1

    # get path of fish command
    fish_cmd=$(command -v fish)

    # check if fish is included in /etc/shells
    if ! grep "^$fish_cmd\$" /etc/shells; then
        echo "$fish_cmd" | sudo tee -a /etc/shells || exit 1
    fi
    # we only set fish as the login shell for non-root users
    if [ $UID != 0 ]; then
        chsh -s "$fish_cmd" || exit 1
    fi
fi

# update vim to vim-9
if ! vim --version | grep '^VIM - Vi IMproved 9'; then
    sudo yum install -y git gcc make ncurses-devel || exit 1
    sudo git clone https://github.com/vim/vim.git /usr/local/src/vim || exit 1

    cd /usr/local/src/vim || exit 1

    sudo ./configure || exit 1
    sudo make || exit 1
    sudo make install || exit 1
    cd - || exit 1
    cd /usr/local/src/vim/src || exit 1
    sudo ./vim
    cd - || exit 1

    # check vim version
    if vim --version | grep '^VIM - Vi IMproved 9'; then
        log "vim install successfully" 
    else
        log "Failed to install Vim 9"
        exit 1
    fi
fi 
# ctags are used for the outlooks of markdown files
sudo yum install -y ctags || exit 1

# install vim plugins
# after installation you may need quit vim manually by using :qa
# this will fail to install LeaaderF and markdown-preview,
# but don't worry, the script will solve this at last
vim +PlugInstall 


# some tool for development 
sudo yum groupinstall -y "Development Tools" || exit 1
sudo yum install -y cmake gdb python3-devel python3-pip pandoc || exit 1

# installation for ShellCheck
sudo yum install -y ShellCheck || exit 1

# clang-family
sudo yum install -y epel-release || exit 1
sudo yum install -y centos-release-scl || exit 1
sudo yum install -y llvm-toolset-7.0 || exit 1
sudo yum install -y llvm-toolset-7-clang-analyzer llvm-toolset-7-clang-tools-extra || exit 1
scl enable llvm-toolset-7 'clang -v' 'lldb -v' || exit 1
scl enable llvm-toolset-7 bash

# sshfs 
sudo yum install -y sshfs || exit 1

# cmake-language-server
sudo yum install -y python3 python3-pip || exit 1
sudo pip3 install --upgrade pip || exit 1
pip3 install --trusted-host pypi.python.org cmake-language-server || exit 1

# snapd
sudo yum install -y snapd || exit 1
sudo systemctl enable --now snapd.socket 
sudo ln -s /var/lib/snapd/snap /snap

# bash-language-server
if ! sudo snap install bash-language-server --classic; then
    log "bash-language-server installation failed, don't worry,you can install it manually."
fi
# reinstall vim plugged 
if [ -d ~/.vim/plugged/LeaderF ]; then
    rm -rf ~/.vim/plugged/LeaderF
fi

if [ -d ~/.vim/plugged/markdown-preview.nvim ]; then
    rm -rf ~/.vim/plugged/markdown-preview.nvim
fi

vim +PlugInstall

# friendly-snippets Coc plugged
vim '+CocInstall https://github.com/rafamadriz/friendly-snippets@main'
log "Installation finished, but you may need restart your shell"
