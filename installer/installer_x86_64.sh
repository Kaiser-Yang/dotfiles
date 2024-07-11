#!/usr/bin/env bash

log() {
    echo "$1" | tee -a installer_x86_64.log
}

# only support x86_64
if ! arch | grep 'x86_64'; then
    log "this now only supports x86_64"
    exit 1
fi

# lazygit
if ! command -v lazygit; then
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

if ! command -v node; then
    cd ~ || exit 1
    wget https://nodejs.org/dist/v20.13.0/node-v20.13.0-linux-x64.tar.xz \
        -O node-v20.13.0-linux-x64.tar.xz || exit 1
    tar -xf node-v20.13.0-linux-x64.tar.xz || exit 1
    rm -f node-v20.13.0-linux-x64.tar.xz
    cd - || exit 1
fi

# install miniconda3
if ! command -v conda; then
    mkdir -p ~/miniconda3 || exit 1
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
        -O ~/miniconda3/miniconda.sh || exit 1
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3 || exit 1
    rm -rf ~/miniconda3/miniconda.sh || exit 1
    ~/miniconda3/bin/conda init bash || exit 1
    ~/miniconda3/bin/conda init fish || exit 1
fi

# neovim latest
if ! command -v neovim; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    rm nvim-linux64.tar.gz
fi

cd ~ || exit 1
rm -rf codelldb.vsix
wget https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-linux.vsix -O codelldb.vsix
unzip codelldb.vsix -d codelldb
rm -rf codelldb.vsix
cd - || exit 1

