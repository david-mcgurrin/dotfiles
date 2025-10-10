# Dotfiles Setup Guide

This guide will help you set up your dotfiles on a new machine (tested on macOS).

## Quick Setup (Recommended)

For the fastest setup, use the automated installation script:

```bash
curl -fsSL https://raw.githubusercontent.com/david-mcgurrin/dotfiles/main/install.sh | bash
```

This will automatically install all prerequisites and set up the dotfiles. After running:

1. Restart your terminal or run `source ~/.zshrc`
2. Update git user info: `git config --global user.name "Your Name"`
3. Update git user email: `git config --global user.email "your.email@example.com"`
4. Install VS Code command line tools (Cmd+Shift+P → "Shell Command: Install 'code' command in PATH")

## Manual Setup

If you prefer to install manually or want more control over the process:

### Step 1: Install Prerequisites

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install development tools
brew install rbenv
brew install git-delta
brew install --cask docker

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

### Step 2: Clone Dotfiles Repository

```bash
# Navigate to home directory
cd ~

# Clone the dotfiles repository
git clone https://github.com/david-mcgurrin/dotfiles.git
```

### Step 3: Set Up Shell Configuration

```bash
# Backup existing shell config (if it exists)
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null || true

# Source the dotfiles configuration
echo 'source ~/dotfiles/shell/.zshrc' >> ~/.zshrc

# Reload shell configuration
source ~/.zshrc
```

### Step 4: Set Up Git Configuration

```bash
# Backup existing git config (if it exists)
mv ~/.gitconfig ~/.gitconfig.backup 2>/dev/null || true

# Link git configuration
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Update git user info for new machine
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 5: Configure VS Code (Optional)

```bash
# First, install VS Code command line tools
# Open VS Code, then Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"

# Import VS Code settings and extensions from dotfiles
~/dotfiles/vscode/sync.sh import
```

## Verification

Test that everything is working correctly:

```bash
# Test aliases work
dot       # Should navigate to dotfiles directory
config    # Should open .zshrc in VS Code
projects  # Should navigate to ~/Developer/Projects
hub       # Should navigate to ~/Developer/Projects/dav-hub

# Test functions work
weather london    # Should show weather report
mkcd test-dir     # Should create and enter directory

# Test git integration (in a git repository)
git open  # Should open GitHub PR comparison
gac "test commit"  # Should add, commit with message
```

## Troubleshooting

### Oh My Zsh plugins not working
```bash
# Verify plugins are installed in the right location
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
```

### VS Code not opening with `config` command
```bash
# Install VS Code command line tools
# Open VS Code, then Cmd+Shift+P → "Shell Command: Install 'code' command in PATH"
```

### Git delta not working
```bash
# Verify delta is installed
which delta

# If not found, install with:
brew install git-delta
```

### rbenv/NVM not found
```bash
# Make sure you reload your shell after installation
source ~/.zshrc

# Or start a new terminal session
```

### Permission denied errors
```bash
# If you get permission errors, you may need to fix Homebrew permissions
sudo chown -R $(whoami) $(brew --prefix)/*
```

## What Gets Installed

This setup provides:

- **Shell enhancements**: Oh My Zsh with autosuggestions and syntax highlighting
- **Custom aliases**: Quick navigation (`dot`, `projects`, `hub`) and git shortcuts (`gac`)
- **Custom functions**: Weather reports, directory creation, blog post templates
- **Git integration**: Enhanced diff viewing with delta, custom aliases
- **Development tools**: Ruby (rbenv), Node.js (NVM), Docker
- **VS Code integration**: Synchronized settings, keybindings, and extensions

## Directory Structure After Setup

```
~/
├── .zshrc (sources ~/dotfiles/shell/.zshrc)
├── .gitconfig (symlinked to ~/dotfiles/git/.gitconfig)
└── dotfiles/
    ├── shell/
    │   ├── .zshrc
    │   ├── .aliases.sh
    └── └── .functions.sh
    ├── git/
    │   └── .gitconfig
    └── vscode/
        ├── settings.json
        ├── keybindings.json
        ├── extensions.txt
        └── sync.sh
```

## Architecture Notes

This dotfiles setup uses a **modular sourcing approach** rather than traditional symlinking:

- The main `~/.zshrc` sources `~/dotfiles/shell/.zshrc`
- Shell configuration files remain in the dotfiles directory for easy version control
- Only git configuration is symlinked (single file, no path conflicts)
- VS Code settings can be imported/exported as needed

This approach provides the benefits of centralized dotfiles management while avoiding path conflicts and maintaining clean organization.