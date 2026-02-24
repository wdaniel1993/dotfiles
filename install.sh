#!/bin/bash
# ============================================================================
# Dotfiles Install Script
# Sets up symlinks and WezTerm loader on a new machine.
# Run from inside the dotfiles repo: ./install.sh
# ============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "📂 Dotfiles directory: $DOTFILES_DIR"
echo ""

# ── Zsh ──
echo "🔗 Linking .zshrc..."
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# ── Starship ──
echo "🔗 Linking starship.toml..."
mkdir -p "$HOME/.config"
ln -sf "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# ── tmux ──
echo "🔗 Linking tmux.conf..."
ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"

# ── WezTerm (loader file, not symlink) ──
echo "📝 Creating WezTerm loader..."
mkdir -p "$HOME/.config/wezterm"
cat > "$HOME/.config/wezterm/wezterm.lua" << EOF
-- Loader: redirect to dotfiles repo
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
return dofile(home .. "/dotfiles/wezterm.lua")
EOF

echo ""
echo "✅ All done! Summary:"
echo "   ~/.zshrc              → $DOTFILES_DIR/.zshrc"
echo "   ~/.config/starship.toml → $DOTFILES_DIR/starship.toml"
echo "   ~/.tmux.conf          → $DOTFILES_DIR/tmux.conf"
echo "   ~/.config/wezterm/wezterm.lua → loader → $DOTFILES_DIR/wezterm.lua"
echo ""
echo "💡 Next steps:"
echo "   1. Run 'exec zsh' or log out/in to activate Zsh"
echo "   2. Run 'setup-zsh.sh' if Zsh/Zinit/Starship aren't installed yet"
echo "   3. On Windows, run 'install.ps1' in PowerShell instead"
echo "   4. On macOS, 'setup-zsh.sh' will auto-install Homebrew if needed"
echo ""
