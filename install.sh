#!/bin/bash

# Dotfiles installation script
# Run with: curl -fsSL https://raw.githubusercontent.com/david-mcgurrin/dotfiles/main/install.sh | bash

set -e

echo "🏠 Setting up dotfiles..."

# Check if on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is designed for macOS only"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo "📦 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Oh My Zsh if not present
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "🐚 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh plugins
echo "🔌 Installing zsh plugins..."
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# Install development tools
echo "🛠️  Installing development tools..."
brew install rbenv git-delta

# Optionally install Docker (commented out as it's large)
# echo "🐳 Installing Docker Desktop..."
# brew install --cask docker

# Install NVM
if [[ ! -d "$HOME/.nvm" ]]; then
    echo "📦 Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
fi

# Clone dotfiles repository
if [[ ! -d "$HOME/dotfiles" ]]; then
    echo "📥 Cloning dotfiles repository..."
    cd ~
    git clone https://github.com/david-mcgurrin/dotfiles.git
fi

# Backup existing .zshrc
if [[ -f "$HOME/.zshrc" ]]; then
    echo "💾 Backing up existing .zshrc..."
    mv ~/.zshrc ~/.zshrc.backup
fi

# Set up dotfiles
echo "🔗 Setting up dotfiles..."
echo 'source ~/dotfiles/shell/.zshrc' >> ~/.zshrc

# Link git configuration
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Set up VS Code configuration (if VS Code is installed)
if command -v code &> /dev/null; then
    echo "⚙️  Setting up VS Code configuration..."
    ~/dotfiles/vscode/sync.sh import
else
    echo "ℹ️  VS Code not found - skipping VS Code setup"
fi

echo "✅ Dotfiles installation complete!"
echo ""
echo "🔄 Please restart your terminal or run 'source ~/.zshrc' to activate the configuration."
echo ""
echo "⚙️  Don't forget to:"
echo "   1. Update git user info: git config --global user.name 'Your Name'"
echo "   2. Update git user email: git config --global user.email 'your.email@example.com'"
if ! command -v code &> /dev/null; then
    echo "   3. Install VS Code and run: Cmd+Shift+P -> 'Shell Command: Install code command in PATH'"
    echo "   4. After installing VS Code CLI, run: ~/dotfiles/vscode/sync.sh import"
else
    echo "   3. Restart VS Code to see all configuration changes"
fi
echo ""
echo "🧪 Test your setup with:"
echo "   • dot (navigate to dotfiles)"
echo "   • config (edit .zshrc)"
echo "   • weather london (test weather function)"