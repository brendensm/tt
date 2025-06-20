#!/bin/bash
# install.sh

set -e

INSTALL_DIR="$HOME/.local/bin"
SCRIPT_NAME="tt"
REPO_URL="https://raw.githubusercontent.com/brendensm/tt/refs/heads/master/tt.sh"

echo "🔍 Checking dependencies..."

# Function to install packages based on OS
install_dependencies() {
    if command -v apt >/dev/null 2>&1; then
        # Ubuntu/Debian
        echo "📦 Installing dependencies with apt..."
        sudo apt update && sudo apt install -y curl jq fzf
    elif command -v yum >/dev/null 2>&1; then
        # RHEL/CentOS/Fedora
        echo "📦 Installing dependencies with yum..."
        sudo yum install -y curl jq fzf
    elif command -v dnf >/dev/null 2>&1; then
        # Newer Fedora
        echo "📦 Installing dependencies with dnf..."
        sudo dnf install -y curl jq fzf
    elif command -v pacman >/dev/null 2>&1; then
        # Arch Linux
        echo "📦 Installing dependencies with pacman..."
        sudo pacman -S --noconfirm curl jq fzf
    elif command -v brew >/dev/null 2>&1; then
        # macOS with Homebrew
        echo "📦 Installing dependencies with brew..."
        brew install curl jq fzf
    else
        echo "❌ Could not detect package manager. Please install manually:"
        echo "   - curl"
        echo "   - jq"
        echo "   - fzf"
        exit 1
    fi
}

# Check each dependency
missing_deps=()

command -v curl >/dev/null 2>&1 || missing_deps+=("curl")
command -v jq >/dev/null 2>&1 || missing_deps+=("jq")
command -v fzf >/dev/null 2>&1 || missing_deps+=("fzf")

if [ ${#missing_deps[@]} -gt 0 ]; then
    echo "❌ Missing dependencies: ${missing_deps[*]}"
    read -p "Install automatically? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_dependencies
    else
        echo "Please install manually and run this script again."
        exit 1
    fi
else
    echo "✅ All dependencies found!"
fi

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download and install
echo "📥 Downloading tt..."
curl -sSL "$REPO_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
chmod +x "$INSTALL_DIR/$SCRIPT_NAME"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "📝 Adding $HOME/.local/bin to PATH..."
    
    if [ $(uname) = "Darwin" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
        echo "Please run: source ~/.zshrc (or restart your terminal)"
    else
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
      echo "Please run: source ~/.bashrc (or restart your terminal)"
    fi
fi

echo "✅ tt installed successfully!"
echo "Run with: tt"