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
# we must install ca-certificates first in docker
${sudo_cmd} apt update || exit 1
${sudo_cmd} apt install -y ca-certificates || exit 1
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
sudo apt install -y curl unzip wget tar ripgrep fzf wordnet || exit 1

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

if ! command -v yarn; then
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - || exit 1
    sudo sh -c 'echo "deb https://dl.yarnpkg.com/debian/ stable main" >> /etc/apt/sources.list.d/yarn.list' || exit 1
    sudo apt update || exit 1
    sudo apt install -y yarn || exit 1
fi

if ! command -v fdfind; then
    sudo apt install -y fd-find || exit 1
    sudo ln -s "$(command -v fdfind)" /usr/bin/fdfind || exit 1
fi

# some tools for development
sudo apt install -y openjdk-17-source openjdk-17-jdk shellcheck build-essential net-tools cmake gdb \
    python3-dev pip pandoc || exit 1

# clang family
sudo apt install -y clangd clang-format clang-tidy || exit 1

# sshfs
sudo apt install -y sshfs || exit 1

# tldr for manual docs
pip install tldr

# debugpy
cd ~ || exit 1
mkdir -p .virtualenvs || exit 1
cd - || exit 1
cd ~/.virtualenvs || exit 1
python -m venv debugpy || exit 1
debugpy/bin/python -m pip install debugpy || exit 1
cd - || exit 1

#install docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt-get remove $pkg;
done
sudo apt-get install -y curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
    docker-compose-plugin || exit 1

# restart docker
sudo systemctl restart docker || exit 1

# latex
# installation of these is time-consuming, uncomment this if you need this one
# sudo apt install -y zathura texlive-full || exit 1

# rust
curl --proto '=https' --tlsv1.2 -sSf "https://sh.rustup.rs" | sh

# neovide
sudo apt install -y curl \
    gnupg ca-certificates git \
    gcc-multilib g++-multilib cmake libssl-dev pkg-config \
    libfreetype6-dev libasound2-dev libexpat1-dev libxcb-composite0-dev \
    libbz2-dev libsndio-dev freeglut3-dev libxmu-dev libxi-dev libfontconfig1-dev \
    libxcursor-dev
cargo install --git https://github.com/neovide/neovide

# yazi
sudo apt install -y ffmpeg 7zip jq poppler-utils zoxide imagemagick || exit 1
git clone https://github.com/sxyazi/yazi.git ~/yazi || exit 1
cd ~/yazi || exit 1
cargo build --release --locked || exit 1
sudo mv target/release/yazi target/release/ya /usr/local/bin/ || exit 1
ya pack -a yazi-rs/plugins:smart-enter || exit 1
ya pack -a yazi-rs/plugins:full-border || exit 1
ya pack -a yazi-rs/plugins:max-preview || exit 1

# rime
sudo apt-get install -y ibus-rime clang librime-dev
cd || exit 1
git clone https://github.com/wlh320/rime-ls.git
cd - || exit 1
cd ~/rime-ls || exit 1
cargo build --release || exit 1
cd - || exit 1
ibus-daemon -drx

# ruby and jekyll
sudo apt install -y ruby-full
sudo gem install jekyll bundler

# gh
sudo apt install -y gh

log "Installation finished, but you may need restart your shell"
