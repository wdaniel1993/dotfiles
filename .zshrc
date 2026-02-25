# ============================================================================
# Zsh Configuration
# ============================================================================

# --- macOS: Homebrew PATH (required on Apple Silicon for /opt/homebrew/bin) ---
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- Zinit Plugin Manager ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname $ZINIT_HOME)" && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
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
if ls --color=auto &>/dev/null; then
    # GNU ls (Linux)
    alias ll='ls -lah --color=auto'
    alias la='ls -A --color=auto'
else
    # BSD ls (macOS)
    alias ll='ls -lahG'
    alias la='ls -AG'
fi
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
