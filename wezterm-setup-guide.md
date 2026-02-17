# WezTerm + Zsh Setup Guide
## Cross-Platform Terminal for Windows & Ubuntu

---

## Quick Reference: Keybindings

| Action | Shortcut |
|---|---|
| New tab | `Ctrl+Shift+T` |
| Close tab | `Ctrl+Shift+W` |
| Next/Prev tab | `Ctrl+Tab` / `Ctrl+Shift+Tab` |
| Tab 1-5 | `Ctrl+Shift+1..5` |
| Split horizontal | `Ctrl+Shift+D` |
| Split vertical | `Ctrl+Shift+E` |
| Close pane | `Ctrl+Shift+X` |
| Navigate panes | `Alt+Arrow keys` |
| Resize panes | `Alt+Shift+Arrow keys` |
| Zoom pane | `Ctrl+Shift+Z` |
| Copy / Paste | `Ctrl+Shift+C` / `Ctrl+Shift+V` |
| Search | `Ctrl+Shift+F` |
| Clear terminal | `Ctrl+Shift+L` |
| Command palette | `Ctrl+Shift+P` |
| New WSL tab | `Ctrl+Shift+U` |
| New PowerShell tab | `Ctrl+Shift+O` (Windows only) |

---

## Part 1: Install the Font

### JetBrains Mono Nerd Font

A monospaced coding font with ligatures and thousands of icons baked in. It's clean, readable, and widely loved.

**Download:** https://www.nerdfonts.com/font-downloads → search "JetBrainsMono"

**Windows:**
1. Download and extract the ZIP
2. Select all `.ttf` files → Right-click → **Install for all users**
3. Restart any open terminals

**Ubuntu:**
```bash
# Quick install
mkdir -p ~/.local/share/fonts
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
tar -xf JetBrainsMono.tar.xz -C ~/.local/share/fonts/
fc-cache -fv
```

**WSL:** Fonts are inherited from Windows — no separate install needed inside WSL.

---

## Part 2: Windows Setup

### 2.1 Install WSL + Ubuntu

If you don't have WSL yet:

```powershell
# Run in PowerShell as Administrator
wsl --install -d Ubuntu
```

Restart, then set up your Ubuntu username/password when prompted.

### 2.2 Install WezTerm

**Option A — Winget (recommended):**
```powershell
winget install wez.wezterm
```

**Option B — Download:** https://wezfurlong.org/wezterm/install/windows.html

### 2.3 Install PowerShell 7 (optional but recommended)

The modern `pwsh.exe` is much nicer than the built-in Windows PowerShell 5:

```powershell
winget install Microsoft.PowerShell
```

### 2.4 Place the Config File

Copy `wezterm.lua` to your WezTerm config directory:

```powershell
# Create config directory if needed
mkdir "$env:USERPROFILE\.config\wezterm" -Force

# Copy the config file
Copy-Item wezterm.lua "$env:USERPROFILE\.config\wezterm\wezterm.lua"
```

> **Note:** WezTerm looks for config in `~/.wezterm.lua` OR `~/.config/wezterm/wezterm.lua`. Either works.

### 2.5 Set up Zsh inside WSL

Open WSL (either from WezTerm or `wsl` in PowerShell), then:

```bash
# Make the script executable and run it
chmod +x setup-zsh.sh
./setup-zsh.sh
```

Log out and back into WSL. Zinit will auto-download plugins on first launch.

---

## Part 3: Ubuntu (Native) Setup

### 3.1 Install WezTerm

```bash
# Add the WezTerm repo
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update
sudo apt install wezterm
```

**Or via Flatpak:**
```bash
flatpak install flathub org.wezfurlong.wezterm
```

### 3.2 Place the Config File

```bash
mkdir -p ~/.config/wezterm
cp wezterm.lua ~/.config/wezterm/wezterm.lua
```

### 3.3 Set up Zsh

```bash
chmod +x setup-zsh.sh
./setup-zsh.sh
```

Log out and back in, then open WezTerm.

---

## Part 4: Syncing Config Across Machines

Use a **dotfiles Git repo** with a tiny loader file. This avoids symlinks, which are problematic on Windows (they require Developer Mode or admin privileges, and Git on Windows creates copies instead of real symlinks).

### 4.1 Create your dotfiles repo

```bash
mkdir ~/dotfiles && cd ~/dotfiles
git init

# Move your configs into the repo
cp ~/.config/wezterm/wezterm.lua ~/dotfiles/wezterm.lua
cp ~/.zshrc ~/dotfiles/.zshrc
cp ~/.config/starship.toml ~/dotfiles/starship.toml
cp ~/.tmux.conf ~/dotfiles/tmux.conf

git add -A && git commit -m "initial dotfiles"
git remote add origin git@github.com:youruser/dotfiles.git
git push -u origin main
```

### 4.2 Create a WezTerm loader file

Instead of symlinking, place a small loader file in WezTerm's default config location. It just redirects to your dotfiles repo:

**Ubuntu:**
```bash
mkdir -p ~/.config/wezterm
cat > ~/.config/wezterm/wezterm.lua << 'EOF'
-- Loader: redirect to dotfiles repo
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
return dofile(home .. "/dotfiles/wezterm.lua")
EOF
```

**Windows (PowerShell):**
```powershell
mkdir "$env:USERPROFILE\.config\wezterm" -Force
Set-Content "$env:USERPROFILE\.config\wezterm\wezterm.lua" @'
-- Loader: redirect to dotfiles repo
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
return dofile(home .. "/dotfiles/wezterm.lua")
'@
```

> **How it works:** WezTerm finds the loader in the default config path, which uses `dofile()` to load and execute your real config from `~/dotfiles/wezterm.lua`. Lua's `dofile()` works with forward slashes on Windows, so the same path format works on both OSes.

### 4.3 Zsh and Starship configs (Linux/WSL only)

For `.zshrc`, `starship.toml`, and `tmux.conf`, symlinks work fine since these are only used on Linux/WSL:

```bash
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
```

### 4.4 Setting up a new machine

```bash
# 1. Clone the repo
git clone git@github.com:youruser/dotfiles.git ~/dotfiles

# 2. Create the WezTerm loader (see 4.2 above)

# 3. Symlink Zsh/Starship/tmux (Linux/WSL only)
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
```

That's it — edit the real config in `~/dotfiles/`, commit, push, and pull on your other machines.

---

## Part 5: tmux (Session Persistence for SSH)

tmux keeps your remote sessions alive when you disconnect — essential for SSH from Termux on your phone or when switching between devices.

### How tmux and WezTerm coexist

| Layer | What it does | Keybinding prefix |
|---|---|---|
| **WezTerm** | Local tabs, splits, window management | `Ctrl+Shift+*` |
| **tmux** | Remote session persistence + splits inside SSH | `Ctrl+A` then key |

Rule of thumb: use **WezTerm splits** for local multitasking, **tmux splits** when you're inside an SSH session that needs to survive disconnects.

### 5.1 Install tmux

**Ubuntu (native & WSL):**
```bash
sudo apt install -y tmux
```

**Termux (Android):**
```bash
pkg install tmux
```

### 5.2 Place the config

```bash
cp tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf   # reload if tmux is already running
```

### 5.3 Key bindings cheat sheet

The prefix is `Ctrl+A` (not the default `Ctrl+B`, which conflicts with shell backward-char).

| Action | Shortcut |
|---|---|
| Split horizontal | `Ctrl+A` then `d` |
| Split vertical | `Ctrl+A` then `e` |
| Navigate panes | `Alt+Arrow keys` (no prefix!) |
| Resize panes | `Ctrl+A` then `Arrow keys` |
| Zoom/unzoom pane | `Ctrl+A` then `z` |
| New window | `Ctrl+A` then `c` |
| Next/prev window | `Ctrl+PageDown` / `Ctrl+PageUp` |
| Close pane | `Ctrl+A` then `x` |
| Detach session | `Ctrl+A` then `d` |
| Copy mode (Vi) | `Ctrl+A` then `v` |
| Reload config | `Ctrl+A` then `r` |
| New session | `Ctrl+A` then `S` |
| Kill session | `Ctrl+A` then `K` |

### 5.4 Typical workflow

```
# From phone (Termux) or desktop (WezTerm)
ssh daniel@your-server

# First time: create a named session
tmux new -s work

# ... do stuff, then detach or just close the connection ...

# Later, from any device: reattach
ssh daniel@your-server
tmux attach -t work
```

---

## Part 6: SSH into Your Headless Ubuntu

### Quick Connect via Launch Menu

Edit the `ssh_domains` section in `wezterm.lua` (currently commented out):

```lua
config.ssh_domains = {
    {
        name = "ubuntu-server",
        remote_address = "192.168.x.x:22",
        username = "daniel",
    },
}
```

This gives you an SSH tab option in the launch menu with full WezTerm features (splits, etc.) working over the connection.

### Or via Launch Menu Entry

Uncomment the SSH entry in the `launch_menu` section of the config.

---

## Part 7: Customization Tips

### Change Theme
WezTerm has hundreds of built-in themes. Switch by changing:
```lua
config.color_scheme = "Tokyo Night"  -- or any built-in theme
```

Browse all themes: https://wezfurlong.org/wezterm/colorschemes/index.html

### Opacity & Blur
Adjust window transparency:
```lua
config.window_background_opacity = 0.85  -- 0.0 to 1.0
```

### Background Image (optional)
```lua
config.background = {
    {
        source = { File = "/path/to/image.png" },
        hsb = { brightness = 0.03 },
    },
}
```

### Toggle Between Catppuccin Mocha and Tokyo Night Based on Time
```lua
local time = tonumber(os.date("%H"))
if time >= 8 and time < 18 then
    config.color_scheme = "Catppuccin Latte"  -- light during day
else
    config.color_scheme = "Catppuccin Mocha"  -- dark at night
end
```

---

## Troubleshooting

**"JetBrainsMono Nerd Font not found"** — Make sure you installed for *all users* on Windows. WezTerm runs in a different context than your user profile sometimes. Restart WezTerm after installing fonts.

**WSL doesn't appear as default domain** — Ensure WSL is installed (`wsl --list` in PowerShell). The config uses `WSL:Ubuntu` — if your distro has a different name, adjust accordingly.

**Slow startup on Windows** — The `WebGpu` frontend can be slow on some GPUs. Try changing to:
```lua
config.front_end = "OpenGL"
```

**Zsh plugins not loading** — Run `exec zsh` after the setup script, or log out and back in. Zinit downloads plugins on first run.
