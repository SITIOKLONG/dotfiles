#!/bin/zsh
set -e

echo "=== Dotfiles Installation Script for New OS ==="

DOTFILES="$HOME/.dotfiles"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

# 1. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_step "Oh My Zsh already installed"
fi

# 2. Install Powerlevel10k
print_step "Installing Powerlevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 3. System dependencies
print_step "Installing system dependencies..."
if [[ "$(uname)" == "Linux" ]]; then
    sudo apt update
    sudo apt install -y git tmux fzf wget curl build-essential ripgrep fd-find
else
    # macOS
    if ! command -v brew >/dev/null 2>&1; then
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git tmux fzf ripgrep fd lazygit
fi

# 4. Kitty Terminal
print_step "Installing Kitty terminal..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

cat << 'EOF' >> ~/.zshrc

# Kitty Terminal
export PATH="$HOME/.local/kitty.app/bin:$PATH"
EOF

# 5. Neovim as AppImage (works on x86_64 and ARM64)
print_step "Installing Neovim (AppImage)..."
if [[ "$(uname)" == "Linux" ]]; then
    ARCH=$(uname -m)
    [[ "$ARCH" == "aarch64" ]] && ARCH="arm64"

    APPIMAGE="nvim-linux-${ARCH}.appimage"

    print_step "Downloading Neovim AppImage for ${ARCH}..."
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/${APPIMAGE}"

    # Make executable and move to standard location
    chmod u+x "${APPIMAGE}"
    sudo rm -f /usr/local/bin/nvim
    sudo mv "${APPIMAGE}" /usr/local/bin/nvim

    print_step "Neovim AppImage installed as /usr/local/bin/nvim"
else
    # macOS - use Homebrew
    brew install neovim
fi

# 6. Lazygit
print_step "Installing Lazygit..."
if [[ "$(uname)" == "Linux" ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    ARCH=$(uname -m)
    [[ "$ARCH" == "aarch64" ]] && ARCH="arm64"
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
    tar xf lazygit.tar.gz
    sudo install lazygit -D -t /usr/local/bin/
    rm -f lazygit.tar.gz lazygit
fi

# 7. Miniconda
print_step "Installing Miniconda..."
if [[ ! -d "$HOME/miniconda3" ]]; then
    ARCH=$(uname -m)
    if [[ "$(uname)" == "Darwin" ]]; then
        CONDA_FILE="Miniconda3-latest-MacOSX-${ARCH}.sh"
    else
        if [[ "$ARCH" == "x86_64" ]]; then
            CONDA_FILE="Miniconda3-latest-Linux-x86_64.sh"
        else
            CONDA_FILE="Miniconda3-latest-Linux-aarch64.sh"
        fi
    fi

    wget "https://repo.anaconda.com/miniconda/${CONDA_FILE}" -O miniconda.sh
    bash miniconda.sh -b -p "$HOME/miniconda3"
    rm miniconda.sh
fi

"$HOME/miniconda3/bin/conda" init zsh

# 8. Ranger with pip fix
print_step "Installing ranger..."
conda activate base 2>/dev/null || true
conda install -y pip 2>/dev/null || true
pip install --user ranger-fm || python3 -m pip install --user ranger-fm

print_step "Installation completed successfully!"

# Final instructions
echo -e "\n${YELLOW}=== Next Steps ===${NC}"
cat << EOF
1. Create symlinks:

   cd "$DOTFILES"
   ln -sf "\$DOTFILES/tmux/.tmux.conf" "\$HOME/.tmux.conf"
   ln -sf "\$DOTFILES/kitty"          "\$HOME/.config/kitty"
   ln -sf "\$DOTFILES/nvim"           "\$HOME/.config/nvim"
   ln -sf "\$DOTFILES/ranger"         "\$HOME/.config/ranger"

2. Restart your shell:
   exec zsh

3. Configure Powerlevel10k:
   p10k configure

4. Test Neovim:
   nvim --version
EOFOFOFOF
