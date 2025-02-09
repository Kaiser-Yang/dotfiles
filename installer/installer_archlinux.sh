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
    tmux less wl-clipboard \
    lazygit git \
    fd fzf ripgrep sshfs \
    fcitx5-im fcitx5-rime \
    fire-fox \
    noto-fonts-cjk \
    unzip \
    github-cli \
    glab \
    zsh \
    nodejs yarn \
    docker \
    ttf-cascadia-mono-nerd

yay -Sy codelldb-bin wordnet-common input-remapper-git

sudo pacman -S starship

sudo pacman -Sy yazi ffmpeg 7zip jq poppler zoxide imagemagick
ya pack -a yazi-rs/plugins:smart-enter || exit 1
ya pack -a yazi-rs/plugins:full-border || exit 1
ya pack -a yazi-rs/plugins:max-preview || exit 1

cargo install tree-sitter-cli

sudo pacman -Sy librime
mkdir -p ~/opt || exit 1
git clone https://github.com/wlh320/rime-ls.git ~/opt/rime-ls || exit 1
cd ~/opt/rime-ls || exit 1
cargo build --release || exit 1
sudo ln -s ~/opt/rime-ls/target/release/rime_ls /usr/bin/rime_ls || exit 1
cd - || exit 1

mkdir -p ~/opt/miniconda3 || exit 1
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -O ~/opt/miniconda3/miniconda.sh || exit 1
bash ~/opt/miniconda3/miniconda.sh -b -u -p ~/opt/miniconda3 || exit 1
rm -rf ~/miniconda3/miniconda.sh || exit 1
~/opt/miniconda3/bin/conda init zsh || exit 1

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
