#!/bin/zsh
set -e

echo "=== Dotfiles Installation Script ==="

DOTFILES="$HOME/.dotfiles"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_step() {
    echo -e "${GREEN}==>${NC} $1"
}

# 1. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_step "Oh My Zsh already installed"
fi

# 2. System dependencies
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

# 3. Kitty Terminal
print_step "Installing Kitty..."
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

cat << 'EOF' >> ~/.zshrc
# Kitty
export PATH="$HOME/.local/kitty.app/bin:$PATH"
EOF

# 4. Neovim (Fixed for both x86_64 and arm64)
print_step "Installing Neovim..."

if [[ "$(uname)" == "Linux" ]]; then
    ARCH=$(uname -m)
    if [[ "$ARCH" == "aarch64" ]]; then
        ARCH="arm64"
    fi
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf "nvim-linux-${ARCH}.tar.gz"
    sudo ln -sf "/opt/nvim-linux-${ARCH}/bin/nvim" /usr/local/bin/nvim
    rm "nvim-linux-${ARCH}.tar.gz"

else
    # macOS (handles both Intel and Apple Silicon automatically)
    brew install neovim
fi

# 5. Lazygit
print_step "Installing Lazygit..."
if [[ "$(uname)" == "Linux" ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
    ARCH=$(uname -m)
    if [[ "$ARCH" == "aarch64" ]]; then
        ARCH="arm64"
    elif [[ "$ARCH" == "x86_64" ]]; then
        ARCH="x86_64"
    fi
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH}.tar.gz"
    tar xf lazygit.tar.gz
    sudo install lazygit -D -t /usr/local/bin/
    rm lazygit.tar.gz lazygit
else
    # Already installed via brew on macOS
    true
fi

# 6. Miniconda (Fixed for x86_64 + ARM64)
print_step "Installing Miniconda..."

if [[ ! -d "$HOME/miniconda3" ]]; then
    ARCH=$(uname -m)
    
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS (Intel or Apple Silicon)
        CONDA_FILE="Miniconda3-latest-MacOSX-${ARCH}.sh"
    else
        # Linux
        if [[ "$ARCH" == "x86_64" ]]; then
            CONDA_FILE="Miniconda3-latest-Linux-x86_64.sh"
        elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
            CONDA_FILE="Miniconda3-latest-Linux-aarch64.sh"
        else
            echo "Unsupported architecture: $ARCH"
            exit 1
        fi
    fi

    print_step "Downloading ${CONDA_FILE}..."
    wget "https://repo.anaconda.com/miniconda/${CONDA_FILE}" -O miniconda.sh

    print_step "Installing Miniconda..."
    bash miniconda.sh -b -p "$HOME/miniconda3"
    rm miniconda.sh
else
    print_step "Miniconda already installed"
fi

# Initialize conda
print_step "Initializing conda for zsh..."
"$HOME/miniconda3/bin/conda" init zsh

# 7. Ranger
print_step "Installing ranger..."
python3 -m pip install --user ranger-fm

print_step "Installation completed!"

echo -e "\n${YELLOW}Next: Create symlinks${NC}"
cat << EOF

cd "$DOTFILES"

ln -sf "\$DOTFILES/tmux/.tmux.conf" "\$HOME/.tmux.conf"
ln -sf "\$DOTFILES/kitty" "\$HOME/.config/kitty"
ln -sf "\$DOTFILES/nvim" "\$HOME/.config/nvim"
ln -sf "\$DOTFILES/ranger" "\$HOME/.config/ranger"

Then run:
    source ~/.zshrc
    p10k configure
EOFOF
