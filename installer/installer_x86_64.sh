#!/usr/bin/env bash

log() {
    echo "$1" | tee -a installer_x86_64.log
}

# only support x86_64
if ! arch | grep 'x86_64'; then
    log "this now only supports x86_64"
    exit 1
fi

if ! command -v node; then
    cd ~ || exit 1
    wget https://nodejs.org/dist/v20.13.0/node-v20.13.0-linux-x64.tar.xz \
        -O node-v20.13.0-linux-x64.tar.xz || exit 1
    tar -xf node-v20.13.0-linux-x64.tar.xz || exit 1
    rm -f node-v20.13.0-linux-x64.tar.xz
    node-v20.13.0-linux-x64/bin/npm install -g yarn
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

if ! command -v codelldb; then
    cd ~ || exit 1
    rm -rf codelldb.vsix
    wget https://github.com/vadimcn/codelldb/releases/download/v1.10.0/codelldb-x86_64-linux.vsix -O codelldb.vsix
    unzip codelldb.vsix -d codelldb
    rm -rf codelldb.vsix
    cd - || exit 1
    sudo ln -s ~/codelldb/codelldb /usr/local/bin/codelldb
fi
