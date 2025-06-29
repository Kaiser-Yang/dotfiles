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

sudo pacman -Sy \
    less wl-clipboard \
    fd fzf ripgrep sshfs \
    fire-fox \
    noto-fonts-cjk \
    unzip \
    github-cli \
    glab \
    yarn \
    docker \
    ttf-cascadia-mono-nerd

yay -Sy codelldb-bin input-remapper-git

sudo pacman -S starship

sudo pacman -Sy yazi ffmpeg 7zip jq poppler zoxide imagemagick
ya pack -a yazi-rs/plugins:smart-enter || exit 1
ya pack -a yazi-rs/plugins:full-border || exit 1
ya pack -a yazi-rs/plugins:max-preview || exit 1

cargo install tree-sitter-cli

mkdir -p ~/opt/miniconda3 || exit 1
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -O ~/opt/miniconda3/miniconda.sh || exit 1
bash ~/opt/miniconda3/miniconda.sh -b -u -p ~/opt/miniconda3 || exit 1
rm -rf ~/miniconda3/miniconda.sh || exit 1
~/opt/miniconda3/bin/conda init zsh || exit 1
