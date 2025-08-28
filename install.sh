#!/bin/bash

# AutoSkipp Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/yourusername/autoskipp/main/install.sh | bash

set -e

PLUGIN_NAME="autoskipp"
REPO_URL="https://github.com/lucianfialho/..."

echo "🚀 Installing AutoSkipp plugin..."

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "❌ Oh My Zsh not found. Please install it first:"
    echo "   sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    exit 1
fi

# Set custom plugins directory
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
PLUGIN_DIR="$ZSH_CUSTOM/plugins/$PLUGIN_NAME"

# Remove existing installation
if [ -d "$PLUGIN_DIR" ]; then
    echo "🔄 Removing existing installation..."
    rm -rf "$PLUGIN_DIR"
fi

# Clone repository
echo "📥 Downloading AutoSkipp..."
git clone "$REPO_URL.git" "$PLUGIN_DIR" || {
    echo "❌ Failed to clone repository. Check your internet connection."
    exit 1
}

# Check if plugin is already in .zshrc
ZSHRC="$HOME/.zshrc"
if ! grep -q "plugins=.*$PLUGIN_NAME" "$ZSHRC"; then
    echo "⚙️  Adding AutoSkipp to plugins list..."
    
    # Backup .zshrc
    cp "$ZSHRC" "$ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Add plugin to plugins array
    if grep -q "plugins=(" "$ZSHRC"; then
        # Replace existing plugins line
        sed -i.tmp "s/plugins=(\(.*\))/plugins=(\1 $PLUGIN_NAME)/" "$ZSHRC"
        rm "$ZSHRC.tmp" 2>/dev/null || true
    else
        # Add plugins line if it doesn't exist
        echo "plugins=($PLUGIN_NAME)" >> "$ZSHRC"
    fi
    
    echo "✅ Added '$PLUGIN_NAME' to your .zshrc plugins"
else
    echo "✅ Plugin already configured in .zshrc"
fi

echo ""
echo "🎉 AutoSkipp installed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Reload your shell: source ~/.zshrc"
echo "   2. Try it out: autoskipp"
echo ""
echo "🚀 Available commands:"
echo "   • autoskipp      - 5-second countdown"
echo "   • skip           - 3-second countdown" 
echo "   • quick          - 1-second countdown"
echo "   • autoskipp_auto - Only runs if Claude Code detected"
echo ""
echo "📖 For more info: https://github.com/yourusername/autoskipp"