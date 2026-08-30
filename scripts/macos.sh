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

# yazi
brew update
brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full font-symbols-only-nerd-font
brew link ffmpeg-full imagemagick-full -f --overwrite

# yabai
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

yabai --start-service
skhd --start-service

# simple-bar
git clone --depth 1 https://github.com/Jean-Tinland/simple-bar $HOME/Library/Application\ Support/Übersicht/widgets/simple-bar

# jankyborder
brew tap FelixKratz/formulae
brew install borders

# btop
brew install btop

FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_DIR/JetBrainsMono.zip" ]; then
    log "Downloading and installing JetBrains Mono Nerd Font..."
    wget -O "$FONT_DIR/JetBrainsMono.zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
    unzip -o "$FONT_DIR/JetBrainsMono.zip" -d "$FONT_DIR"
    # Optional: remove the zip after extraction
    # rm "$FONT_DIR/JetBrainsMono.zip"
else
    log "JetBrains Mono font already exists, skipping installation"
fi

# lazyvim
NVIM_CONFIG="$HOME/.config/nvim"
git clone https://github.com/LazyVim/starter.git "$NVIM_CONFIG"


DOTFILES="$HOME/.dotfiles"
cd "$DOTFILES"

mkdir -p "$HOME/.config"
ln -sf "$HOME/.dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/kitty" "$HOME/.config/kitty"
