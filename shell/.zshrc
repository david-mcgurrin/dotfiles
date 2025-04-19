export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/dotfiles"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
source $DOTFILES/shell/aliases.sh