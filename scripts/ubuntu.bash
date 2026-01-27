#!/bin/bash

set -e

DOTFILES="$HOME/.dotfiles"

# kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
echo 'export PATH="$HOME/.local/kitty.app/bin:$PATH"' >>~/.bashrc
source ~/.bashrc

sudo apt install -y git tmux fzf wget curl build-essential

# neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >>~/.bashrc

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ./Miniconda3-latest-Linux-x86_64.sh
~/miniconda3/bin/conda init zsh
conda init
conda deactivate
pip3 install --user ranger-fm

source ~/.bashrc

cd "$DOTFILES"

mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/kitty" "$HOME/.config/kitty"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/ranger" "$HOME/.ranger"
