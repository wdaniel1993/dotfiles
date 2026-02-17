# Dotfiles

Cross-platform terminal configuration for **WezTerm + Zsh + tmux**.

Works on Windows (via WSL) and Ubuntu with consistent keybindings and Catppuccin Mocha theming.

## What's Included

| File | Purpose |
|---|---|
| `wezterm.lua` | WezTerm config (auto-detects OS, consistent keybindings) |
| `.zshrc` | Zsh config with Zinit plugins (syntax highlighting, autosuggestions) |
| `starship.toml` | Starship prompt config |
| `tmux.conf` | tmux config (Ctrl+A prefix, matches WezTerm patterns) |
| `setup-zsh.sh` | One-time Zsh/Zinit/Starship installer for Ubuntu |
| `install.sh` | Linux/WSL: creates symlinks + WezTerm loader |
| `install.ps1` | Windows: creates WezTerm loader |

## Quick Start

### Prerequisites

- **Font:** [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads)
- **WezTerm:** [wezfurlong.org/wezterm](https://wezfurlong.org/wezterm/install/)

### Linux / WSL

```bash
git clone git@github.com:youruser/dotfiles.git ~/dotfiles
cd ~/dotfiles

# First time only: install Zsh, Zinit, Starship
chmod +x setup-zsh.sh && ./setup-zsh.sh

# Create symlinks + WezTerm loader
chmod +x install.sh && ./install.sh
```

### Windows

```powershell
git clone git@github.com:youruser/dotfiles.git $env:USERPROFILE\dotfiles
cd $env:USERPROFILE\dotfiles

# Create WezTerm loader
.\install.ps1

# Then open WSL and run install.sh for Zsh/tmux
```

## Keybindings

See `keybinding-reference.md` for the full reference, or print `keybinding-cheatsheet.pdf` for a one-page A4 cheat sheet.

### Quick Reference

| Layer | Prefix | Use for |
|---|---|---|
| WezTerm | `Ctrl+Shift+` | Local tabs, splits, window management |
| tmux | `Ctrl+A →` | Remote session persistence (SSH) |
| Zsh | Direct keys | Shell navigation + history |

## Background Image (Optional)

Drop a `bg.png` into this repo and uncomment the background section in `wezterm.lua`. Keep images under 2-3MB.

## License

MIT
