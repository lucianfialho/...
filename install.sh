#!/bin/bash

# dotdotdot Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/lucianfialho/.../main/install.sh | bash

set -e

BINARY_NAME="dotdotdot"
REPO_URL="https://github.com/lucianfialho/..."
INSTALL_DIR="/usr/local/bin"

echo "🚀 Installing dotdotdot..."

# Check if running as root for system-wide install
if [[ $EUID -eq 0 ]]; then
    INSTALL_DIR="/usr/local/bin"
elif [[ -w "/usr/local/bin" ]]; then
    INSTALL_DIR="/usr/local/bin"
else
    # Fallback to user local bin
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo "📝 Adding $INSTALL_DIR to PATH..."
        
        # Detect shell and add to appropriate config
        if [[ "$SHELL" == *"zsh"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
            SHELL_CONFIG="~/.zshrc"
        elif [[ "$SHELL" == *"bash"* ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            SHELL_CONFIG="~/.bashrc"
        else
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
            SHELL_CONFIG="~/.profile"
        fi
        
        echo "   Added PATH export to $SHELL_CONFIG"
    fi
fi

# Download dotdotdot binary
echo "📥 Downloading dotdotdot..."
TEMP_FILE="/tmp/dotdotdot"

if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_URL/raw/main/dotdotdot" -o "$TEMP_FILE"
elif command -v wget &> /dev/null; then
    wget -q "$REPO_URL/raw/main/dotdotdot" -O "$TEMP_FILE"
else
    echo "❌ Neither curl nor wget found. Please install one of them."
    exit 1
fi

# Make executable and move to install directory
chmod +x "$TEMP_FILE"

# Install the binary
if [[ -w "$INSTALL_DIR" ]]; then
    mv "$TEMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
else
    echo "🔐 Installing to $INSTALL_DIR requires sudo permission..."
    sudo mv "$TEMP_FILE" "$INSTALL_DIR/$BINARY_NAME"
fi

echo "✅ dotdotdot installed to $INSTALL_DIR/$BINARY_NAME"

# Create alias suggestions
echo ""
echo "🎉 dotdotdot installed successfully!"
echo ""
echo "📋 Quick start:"
echo "   dotdotdot                    # 5 second countdown"
echo "   dotdotdot --skiptime 10      # Custom time"
echo "   dotdotdot --help             # Show all options"
echo ""
echo "💡 Pro tip - Add this alias to your shell config:"

if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="~/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="~/.bashrc"  
else
    SHELL_CONFIG="~/.profile"
fi

echo "   echo 'alias ...=dotdotdot' >> $SHELL_CONFIG"
echo "   source $SHELL_CONFIG"
echo ""
echo "   Then use: ... --skiptime 5"
echo ""
echo "🚀 Available commands:"
echo "   • dotdotdot --skiptime 5     # Custom countdown time"
echo "   • dotdotdot --message \"Hi\"   # Custom message"
echo "   • dotdotdot --auto           # Only runs if Claude Code detected"
echo "   • dotdotdot --help           # Show help"
echo ""
echo "📖 For more info: https://github.com/lucianfialho/..."