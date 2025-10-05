# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Architecture

This is a personal dotfiles repository with a modular structure:

- **`shell/`** - Shell configuration files (.zshrc, .aliases.sh, .functions.sh)
- **`git/`** - Git configuration (.gitconfig with custom aliases and delta integration)
- **`vscode/`** - VS Code settings, keybindings, and extensions list

The dotfiles are designed to be loaded from their current location rather than being symlinked to the home directory. The `.zshrc` file sources the other shell configuration files using absolute paths.

### Key Components

**Shell Configuration (`shell/.zshrc`)**
- Uses Oh My Zsh with robbyrussell theme
- Includes git, zsh-autosuggestions, and zsh-syntax-highlighting plugins
- Sets up rbenv for Ruby version management
- Configures lazy-loaded NVM for Node.js
- Sources personal aliases and functions from separate files

**Aliases (`shell/.aliases.sh`)**
- Quick config editing shortcuts
- Project navigation shortcuts (projects, hub, dot, sk)
- Git workflow shortcuts (gac for add + commit)
- Utility shortcuts (dn for weather)

**Functions (`shell/.functions.sh`)**
- `create_day()` and `create_week()` - Branch and file creation for 100-days-of-code project
- `create_post()` - Blog post creation with Astro frontmatter
- `mkcd()` - Create directory and cd into it
- `weather()` - Get weather reports via wttr.in
- Git status functions for custom prompt styling
- `git_check()`, `git_status()`, `git_dot()`, `git_status_color()` - Advanced git status display

**Git Configuration (`git/.gitconfig`)**
- Custom git aliases: `open` (opens GitHub PR comparison), `rup` (rapid commit/push/open)
- Delta integration for better diff viewing
- Configured for GitHub workflow with branch comparisons

**VS Code Configuration (`vscode/`)**
- `settings.json` - Editor preferences, formatting, git integration
- `keybindings.json` - Custom keyboard shortcuts (Cmd+K for quick open)
- `extensions.txt` - List of installed extensions for automatic installation
- `sync.sh` - Script to export/import VS Code configuration

## Common Commands

### Configuration Management
```bash
# Edit main zsh configuration
config

# Navigate to dotfiles directory
dot

# Reload shell configuration
source ~/.zshrc
```

### Project Workflow
```bash
# Quick add, commit, and message
gac "commit message"

# Rapid commit, push, and open PR (git alias)
git rup "commit message"

# Open GitHub PR comparison for current branch
git open
```

### Content Creation
```bash
# Create a new day branch and file for 100-days-of-code
create_day 15

# Create a new week summary
create_week 3

# Create a blog post with frontmatter
create_post "my-new-post" "Post description" 123
```

### Development Utilities
```bash
# Create directory and cd into it
mkcd new-project

# Get weather report
weather london

# Navigate to common project directories
projects  # ~/Developer/Projects
hub      # ~/Developer/Projects/dav-hub
sk       # ~/sportskey
```

### VS Code Configuration
```bash
# Import VS Code settings and extensions from dotfiles
~/dotfiles/vscode/sync.sh import

# Export current VS Code config to dotfiles (for updates)
~/dotfiles/vscode/sync.sh export

# Install all extensions manually
cat ~/dotfiles/vscode/extensions.txt | xargs -L1 code --install-extension
```

## New Machine Setup

### Quick Setup (Recommended)

For fastest setup, use the automated installation script:

```bash
curl -fsSL https://raw.githubusercontent.com/david-mcgurrin/dotfiles/main/install.sh | bash
```

This will automatically install all prerequisites and set up the dotfiles. After running, you'll just need to:
1. Restart your terminal or run `source ~/.zshrc`
2. Update git user info: `git config --global user.name "Your Name"`
3. Update git user email: `git config --global user.email "your.email@example.com"`
4. Install VS Code command line tools (Cmd+Shift+P → "Shell Command: Install 'code' command in PATH")

### Manual Installation

If you prefer to install manually or want more control:

#### Prerequisites Installation

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

### Dotfiles Setup

```bash
# Clone dotfiles repository
cd ~
git clone https://github.com/david-mcgurrin/dotfiles.git

# Backup existing shell config (if it exists)
mv ~/.zshrc ~/.zshrc.backup 2>/dev/null || true

# Source the dotfiles configuration
echo 'source ~/dotfiles/shell/.zshrc' >> ~/.zshrc

# Reload shell
source ~/.zshrc
```

### Git Configuration Setup

```bash
# Link git configuration
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Update git user info for new machine
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Verification

```bash
# Test aliases work
dot  # Should navigate to dotfiles directory
config  # Should open .zshrc in VS Code

# Test functions work
weather london  # Should show weather report
mkcd test-dir  # Should create and enter directory

# Test git integration
git open  # Should work in a git repository
```

### Troubleshooting

**Oh My Zsh plugins not working:**
```bash
# Verify plugins are installed in the right location
ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/
```

**VS Code not opening with `config` command:**
```bash
# Install VS Code command line tools
# Open VS Code, then Cmd+Shift+P -> "Shell Command: Install 'code' command in PATH"
```

**Git delta not working:**
```bash
# Verify delta is installed
which delta

# If not found, install with:
brew install git-delta
```

**rbenv/NVM not found:**
```bash
# Make sure you reload your shell after installation
source ~/.zshrc

# Or start a new terminal session
```

## Environment Dependencies

The dotfiles assume the following tools are installed:
- Oh My Zsh
- zsh-autosuggestions and zsh-syntax-highlighting plugins
- rbenv (Ruby version management)
- NVM (Node version management, lazy-loaded)
- Delta (git diff enhancement)
- Docker Desktop
- VS Code (for the `config` alias)

## Integration Notes

- The shell configuration sources files from `~/dotfiles/shell/` using absolute paths
- Git configuration includes delta for enhanced diff viewing
- Custom functions are designed for GitHub workflow integration
- Weather function uses wttr.in API
- Blog post creation assumes Astro/markdown blog structure
- VS Code configuration is symlinked to maintain sync with dotfiles

## Personal Workflow Context

This dotfiles setup supports:
- Multi-project development workflow
- GitHub-centric git operations with PR automation
- Content creation for coding challenges and blog posts
- Ruby and Node.js development environments
- Enhanced terminal experience with git status visualization