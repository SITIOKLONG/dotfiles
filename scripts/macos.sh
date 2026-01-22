#!/bin/zsh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
  echo -e "${GREEN}[INFO]${NC} $1"
}
error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

[[ "$(uname)" != "Darwin"]] && error "This scripts only for MacOS"

if ! command -v brew &>/dev/null; then
  log "installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  log "Homebrew is installed"
fi

brew install neovim git tmux lazygit fzf wget

# tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
set -g @plugin 'tmux-plugins/tpm'
run '~/.tmux/plugins/tpm/tpm'

conda init
conda deactivate

pip3 install --user ranger-fm

FONT_DIR="$HOEM/Library/Fonts"
mkdir -p "$FONT_DIR"
if [ ! -f "$FONT_DIR/0xProto.zip" ]; then
    log "下載並安裝 0xProto Nerd Font..."
    wget -O "$FONT_DIR/0xProto.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/0xProto.zip
    unzip -o "$FONT_DIR/0xProto.zip" -d "$FONT_DIR"
    # 清理 zip（可選）
    # rm "$FONT_DIR/0xProto.zip"
else
    log "0xProto 字體已存在，跳過安裝"
fi

NVIM_CONFIG="$HOME/.config/nvim"

git clone https://github.com/LazyVim/starter.git "$NVIM_CONFIG"


DOTFILES="$HOME/dotfiles"
cd "$DOTFILES"

mkdir -p "$HOME/.config"
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/iterm2" "$HOME/.config/iterm2"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
