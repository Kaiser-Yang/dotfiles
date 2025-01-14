#!/sur/bin/env bash

# python3-autopep8 lcov
# openjdk-17-source openjdk-17-jdk shellcheck build-essential net-tools cmake gdb
# python3-dev pip pandoc
# clang clangd clang-format clang-tidy
# tldr
# debugpy
# latex
# neovide
# ruby jekyll
# unzip

sudo pacman -S less lazygit git fd fzf ripgrep sshfs \
    github-cli \
    zsh \
    nodejs yarn \
    docker

yay -S dict-wn anaconda codelldb

sudo pacman -S yazi ffmpeg p7zip jq poppler zoxide imagemagick
ya pack -a yazi-rs/plugins:smart-enter || exit 1
ya pack -a yazi-rs/plugins:full-border || exit 1
ya pack -a yazi-rs/plugins:max-preview || exit 1

sudo pacman -S librime
mkdir -p ~/opt || exit 1
git clone https://github.com/wlh320/rime-ls.git ~/opt/rime-ls || exit 1
cd ~/opt/rime-ls || exit 1
cargo build --release || exit 1
cd - || exit 1
