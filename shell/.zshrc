# Path to Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

#ZSH_THEME="af-magic"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Load personal aliases
source $HOME/dotfiles/shell/.aliases.sh

# Load personal functions
source $HOME/dotfiles/shell/.functions.sh

# Environment variables
export PATH="/usr/local/opt/ruby/bin:$PATH"
export GEM_HOME="$HOME/.gem/ruby/$(ruby -e 'puts RUBY_VERSION')"
export PATH="$GEM_HOME/bin:$PATH"

# Lazy load NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && export NVM_LAZY=1 && {
    function nvm() {
        unset -f nvm
        . "$NVM_DIR/nvm.sh"
        nvm "$@"
    }
}