#!/bin/bash

# VS Code dotfiles sync script
# Usage:
#   ./sync.sh export  - Export current VS Code config to dotfiles
#   ./sync.sh import  - Import dotfiles config to VS Code

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

case "${1:-}" in
  export)
    echo "📤 Exporting VS Code configuration to dotfiles..."
    
    # Copy settings
    if [[ -f "$VSCODE_USER_DIR/settings.json" ]]; then
      cp "$VSCODE_USER_DIR/settings.json" "$SCRIPT_DIR/settings.json"
      echo "✅ Exported settings.json"
    fi
    
    # Copy keybindings
    if [[ -f "$VSCODE_USER_DIR/keybindings.json" ]]; then
      cp "$VSCODE_USER_DIR/keybindings.json" "$SCRIPT_DIR/keybindings.json"
      echo "✅ Exported keybindings.json"
    fi
    
    # Export extensions list
    code --list-extensions > "$SCRIPT_DIR/extensions.txt"
    echo "✅ Exported extensions list ($(wc -l < "$SCRIPT_DIR/extensions.txt" | tr -d ' ') extensions)"
    
    echo "🎉 Export complete! Don't forget to commit the changes."
    ;;
    
  import)
    echo "📥 Importing VS Code configuration from dotfiles..."
    
    # Create VS Code user directory if it doesn't exist
    mkdir -p "$VSCODE_USER_DIR"
    
    # Link settings
    if [[ -f "$SCRIPT_DIR/settings.json" ]]; then
      ln -sf "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
      echo "✅ Linked settings.json"
    fi
    
    # Link keybindings
    if [[ -f "$SCRIPT_DIR/keybindings.json" ]]; then
      ln -sf "$SCRIPT_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
      echo "✅ Linked keybindings.json"
    fi
    
    # Install extensions
    if [[ -f "$SCRIPT_DIR/extensions.txt" ]]; then
      echo "📦 Installing extensions..."
      while read -r extension; do
        if [[ -n "$extension" && ! "$extension" =~ ^[[:space:]]*# ]]; then
          echo "  Installing: $extension"
          code --install-extension "$extension" --force
        fi
      done < "$SCRIPT_DIR/extensions.txt"
      echo "✅ Installed all extensions"
    fi
    
    echo "🎉 Import complete! Restart VS Code to see all changes."
    ;;
    
  *)
    echo "Usage: $0 {export|import}"
    echo ""
    echo "Commands:"
    echo "  export  - Export current VS Code config to dotfiles"
    echo "  import  - Import dotfiles config to VS Code"
    exit 1
    ;;
esac