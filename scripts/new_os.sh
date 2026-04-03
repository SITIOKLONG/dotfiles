#!/bin/zsh
set -e

echo "=== Dotfiles Installation Script ==="

# Configuration
DOTFILES="$HOME/.dotfiles"
OS_TYPE="$(uname -s)"
ARCH="$(uname -m)"

# Colors for nice output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

# 1. Install Oh My Zsh (if not already installed)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_step "Oh My Zsh already installed"
fi

# 2. Install basic dependencies
print_step "Installing system dependencies..."

if [[ "$OS_TYPE" == "Linux" ]]; then
    sudo apt update
    sudo apt install -y git tmux fzf wget curl build-essential ripgrep fd-find

elif [[ "$OS_TYPE" == "Darwin" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git tmux fzf ripgrep fd lazygit
fi

# 3. Install Kitty (cross-platform)
print_step "Installing Kitty terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# Add Kitty to PATH (works for both Linux and macOS)
cat << EOF >> ~/.zshrc
# Kitty
export PATH="\$HOME/.local/kitty.app/bin:\$PATH"
EOF

# 4. Install Neovim (latest stable, universal way)
print_step "Installing Neovim..."
if [[ "$OS_TYPE" == "Linux" ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-"${ARCH}".tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-"${ARCH}".tar.gz
    sudo ln -sf /opt/nvim-linux-"${ARCH}"/bin/nvim /usr/local/bin/nvim
else
    # macOS
    brew install neovim
fi

# 5. Install Lazygit
print_step "Installing Lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
if [[ "$OS_TYPE" == "Linux" ]]; then
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
else
    # macOS - already installed via brew above
    true
fi

if [[ "$OS_TYPE" == "Linux" ]]; then
    tar xf lazygit.tar.gz
    sudo install lazygit -D -t /usr/local/bin/
    rm -f lazygit.tar.gz lazygit
fi

# 6. Install Miniconda (universal)
print_step "Installing Miniconda..."
if [[ ! -d "$HOME/miniconda3" ]]; then
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh || \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-"${ARCH}".sh -O miniconda.sh

    bash miniconda.sh -b -p "$HOME/miniconda3"
    rm miniconda.sh
fi

# Initialize conda for zsh
"$HOME/miniconda3/bin/conda" init zsh

# 7. Install ranger
print_step "Installing ranger file manager..."
pip3 install --user ranger-fm || python3 -m pip install --user ranger-fm

# 8. Symlink dotfiles (moved to README recommendation)
print_step "Creating symlinks..."

mkdir -p "$HOME/.config"

echo -e "\n${YELLOW}Symlinking completed. Please run these commands manually:${NC}\n"

cat << EOF
cd "$DOTFILES"

ln -sf "\$DOTFILES/tmux/.tmux.conf" "\$HOME/.tmux.conf"
ln -sf "\$DOTFILES/kitty" "\$HOME/.config/kitty"
ln -sf "\$DOTFILES/nvim" "\$HOME/.config/nvim"
ln -sf "\$DOTFILES/ranger" "\$HOME/.config/ranger"     # Note: usually ~/.config/ranger, not ~/.ranger
EOF

echo -e "\n${GREEN}Installation finished!${NC}"
echo -e "Now run: ${YELLOW}source ~/.zshrc${NC}"
echo -e "Then configure Powerlevel10k with: ${YELLOW}p10k configure${NC}"

# Final message
cat << EOF

=== Next Steps ===
1. Clone your dotfiles repo (if not already done):
   git clone <your-dotfiles-repo> ~/.dotfiles

2. Run the symlinks shown above

3. Restart your terminal or run: source ~/.zshrc

4. (Optional) Run 'p10k configure' to customize Powerlevel10k
EOF
