#!/bin/bash
# ============================================================================
# Zsh Setup Script for Ubuntu (native & WSL)
# Run this on your Ubuntu machine AND inside WSL on Windows
# ============================================================================

set -e

echo "🚀 Setting up Zsh environment..."

# --- Install Zsh ---
echo "📦 Installing Zsh..."
sudo apt update && sudo apt install -y zsh git curl

# --- Set Zsh as default shell ---
echo "🐚 Setting Zsh as default shell..."
chsh -s $(which zsh)

# --- Install Zinit (lightweight plugin manager) ---
echo "📦 Installing Zinit plugin manager..."
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# --- Install Starship prompt ---
echo "🌟 Installing Starship prompt..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

# --- Create .zshrc ---
echo "📝 Writing .zshrc..."
cat > ~/.zshrc << 'ZSHRC_EOF'
# ============================================================================
# Zsh Configuration
# ============================================================================

# --- Zinit Plugin Manager ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharber/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# --- Plugins ---
# Syntax highlighting (like Fish)
zinit light zsh-users/zsh-syntax-highlighting

# Autosuggestions from history (like Fish)
zinit light zsh-users/zsh-autosuggestions

# Better completions
zinit light zsh-users/zsh-completions

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS  # No duplicate entries
setopt HIST_FIND_NO_DUPS     # No dupes in search
setopt SHARE_HISTORY         # Share between sessions
setopt APPEND_HISTORY        # Append, don't overwrite

# --- Navigation ---
setopt AUTO_CD               # cd by typing directory name
setopt AUTO_PUSHD            # Push dirs to stack
setopt PUSHD_SILENT          # Don't print stack

# --- Completion ---
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                    # Arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case insensitive

# --- Key bindings ---
bindkey '^[[A' history-search-backward   # Up arrow: search history
bindkey '^[[B' history-search-forward    # Down arrow: search history
bindkey '^[[1;5C' forward-word           # Ctrl+Right: forward word
bindkey '^[[1;5D' backward-word          # Ctrl+Left: backward word
bindkey '^[[3~' delete-char              # Delete key

# --- Aliases ---
alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias gs='git status'
alias gp='git pull'
alias gc='git commit'
alias gd='git diff'
alias k='kubectl'

# --- Environment ---
export EDITOR='nano'  # or 'vim' / 'code'
export LANG=en_US.UTF-8

# --- Starship Prompt (cross-platform, fast, pretty) ---
eval "$(starship init zsh)"

ZSHRC_EOF

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
