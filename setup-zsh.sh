#!/bin/bash
# ============================================================================
# Zsh Setup Script for Ubuntu (native & WSL), CachyOS/Arch, and macOS
# Run this on your machine to install Zsh, Zinit, and Starship.
# ============================================================================

set -e

echo "🚀 Setting up Zsh environment..."

# --- Detect OS ---
OS="$(uname -s)"

# --- Install Zsh ---
echo "📦 Installing Zsh..."
if [ "$OS" = "Darwin" ]; then
    # macOS: use Homebrew (install brew if missing)
    if ! command -v brew &>/dev/null; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install zsh git curl
elif command -v pacman &>/dev/null; then
    # Arch-based Linux (CachyOS, Arch, Manjaro, etc.)
    sudo pacman -S --noconfirm zsh git curl
else
    # Debian/Ubuntu / WSL
    sudo apt update && sudo apt install -y zsh git curl
fi

# --- Set Zsh as default shell ---
echo "🐚 Setting Zsh as default shell..."
chsh -s "$(which zsh)"

# --- Install Zinit (lightweight plugin manager) ---
echo "📦 Installing Zinit plugin manager..."
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# --- Install Starship prompt ---
echo "🌟 Installing Starship prompt..."
if [ "$OS" = "Darwin" ]; then
    brew install starship
elif command -v pacman &>/dev/null; then
    # Arch-based Linux (CachyOS, Arch, Manjaro, etc.)
    sudo pacman -S --noconfirm starship
else
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# --- Symlink .zshrc from dotfiles repo ---
echo "🔗 Linking .zshrc..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

# --- Create Starship config ---
echo "🌟 Writing Starship config..."
mkdir -p ~/.config
cat > ~/.config/starship.toml << 'STARSHIP_EOF'
# Starship Prompt Configuration
# Docs: https://starship.rs/config/

# General
format = """
$directory\
$git_branch\
$git_status\
$python\
$nodejs\
$dotnet\
$docker_context\
$kubernetes\
$cmd_duration\
$line_break\
$character"""

# Prompt character
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[directory]
truncation_length = 4
truncate_to_repo = true
style = "bold lavender"

[git_branch]
symbol = " "
style = "bold mauve"

[git_status]
style = "bold red"

[cmd_duration]
min_time = 2000
format = "took [$duration](bold yellow) "

[python]
symbol = " "

[nodejs]
symbol = " "

[dotnet]
symbol = "󰪮 "

[docker_context]
symbol = " "

[kubernetes]
disabled = false
symbol = "☸ "

STARSHIP_EOF

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Log out and back in (or run: exec zsh)"
echo "  2. Zinit will auto-install plugins on first launch"
echo "  3. Customize ~/.zshrc and ~/.config/starship.toml as needed"
echo ""
