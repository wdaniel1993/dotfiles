# Keyboard Shortcut Reference
## WezTerm + tmux + Zsh

---

## At a Glance: Which Layer Handles What

| Layer | When it's active | Prefix | Purpose |
|---|---|---|---|
| **WezTerm** | Always (local terminal) | `Ctrl+Shift+` | Local window/tab/pane management |
| **tmux** | Inside a tmux session (SSH) | `Ctrl+A` then key | Remote session persistence + splits |
| **Zsh** | At the shell prompt | None | Shell navigation + history |

---

## WezTerm (Local Terminal)

Works on both Windows and Ubuntu. These are intercepted by WezTerm before reaching the shell.

### Tabs

| Action | Shortcut |
|---|---|
| New tab | `Ctrl+Shift+T` |
| Close tab | `Ctrl+Shift+W` |
| Next tab | `Ctrl+Tab` |
| Previous tab | `Ctrl+Shift+Tab` |
| Go to tab 1 | `Ctrl+Shift+1` |
| Go to tab 2 | `Ctrl+Shift+2` |
| Go to tab 3 | `Ctrl+Shift+3` |
| Go to tab 4 | `Ctrl+Shift+4` |
| Go to tab 5 | `Ctrl+Shift+5` |

### Panes (Splits)

| Action | Shortcut |
|---|---|
| Split horizontal | `Ctrl+Shift+D` |
| Split vertical | `Ctrl+Shift+E` |
| Close pane | `Ctrl+Shift+X` |
| Navigate panes | `Alt+Arrow keys` |
| Resize panes | `Alt+Shift+Arrow keys` |
| Zoom/unzoom pane | `Ctrl+Shift+Z` |

### General

| Action | Shortcut |
|---|---|
| Copy | `Ctrl+Shift+C` |
| Paste | `Ctrl+Shift+V` |
| Search | `Ctrl+Shift+F` |
| Clear terminal | `Ctrl+Shift+L` |
| Command palette | `Ctrl+Shift+P` |
| Increase font size | `Ctrl+=` |
| Decrease font size | `Ctrl+-` |
| Reset font size | `Ctrl+0` |

### Quick Launch

| Action | Shortcut | Platform |
|---|---|---|
| New WSL tab | `Ctrl+Shift+U` | Windows only |
| New PowerShell tab | `Ctrl+Shift+O` | Windows only |

---

## tmux (Remote Sessions)

Active when you're inside a tmux session (typically over SSH). **Prefix is `Ctrl+A`** — press it, release, then press the action key.

### Panes (Splits)

| Action | Shortcut |
|---|---|
| Split horizontal | `Ctrl+A` → `d` |
| Split vertical | `Ctrl+A` → `e` |
| Navigate panes | `Alt+Arrow keys` *(no prefix)* |
| Resize panes | `Ctrl+A` → `Arrow keys` |
| Zoom/unzoom pane | `Ctrl+A` → `z` |
| Close pane | `Ctrl+A` → `x` |

### Windows (tmux equivalent of tabs)

| Action | Shortcut |
|---|---|
| New window | `Ctrl+A` → `c` |
| Next window | `Ctrl+PageDown` *(no prefix)* |
| Previous window | `Ctrl+PageUp` *(no prefix)* |
| Go to window N | `Ctrl+A` → `1`..`9` |
| Swap window left | `Ctrl+A` → `<` |
| Swap window right | `Ctrl+A` → `>` |

### Sessions

| Action | Shortcut |
|---|---|
| Detach (keep running) | `Ctrl+A` → `d` |
| New session | `Ctrl+A` → `S` |
| Kill session | `Ctrl+A` → `K` |
| List sessions | `Ctrl+A` → `s` *(default)* |

### Copy Mode (Vi-style)

| Action | Shortcut |
|---|---|
| Enter copy mode | `Ctrl+A` → `v` |
| Begin selection | `v` *(in copy mode)* |
| Yank to clipboard | `y` *(in copy mode)* |
| Cancel / exit | `Escape` *(in copy mode)* |

### Utility

| Action | Shortcut |
|---|---|
| Reload config | `Ctrl+A` → `r` |
| Show clock | `Ctrl+A` → `t` |
| Send literal Ctrl+A | `Ctrl+A` → `Ctrl+A` |

---

## Zsh (Shell Prompt)

These work at the command line inside Zsh, in any terminal.

### Navigation

| Action | Shortcut |
|---|---|
| Move cursor left/right | `Left` / `Right` |
| Jump word forward | `Ctrl+Right` |
| Jump word backward | `Ctrl+Left` |
| Go to start of line | `Home` or `Ctrl+A`* |
| Go to end of line | `End` or `Ctrl+E` |
| Delete character | `Delete` |
| Delete word backward | `Ctrl+W` |
| Delete to end of line | `Ctrl+K` |
| Clear screen | `Ctrl+L` |

*\* `Ctrl+A` is intercepted by tmux when inside a tmux session. Use `Home` instead, or press `Ctrl+A` → `Ctrl+A` to send a literal Ctrl+A.*

### History

| Action | Shortcut |
|---|---|
| Previous command (search) | `Up Arrow` |
| Next command (search) | `Down Arrow` |
| Reverse search history | `Ctrl+R` |
| Accept autosuggestion | `Right Arrow` *(end of line)* |

> **Tip:** Up/Down arrows do history *search*, not just previous/next. Type `git` then press `Up` to cycle through commands starting with `git`.

---

## Consistent Patterns Across Layers

The configs are designed so similar actions use similar keys:

| Action | WezTerm | tmux |
|---|---|---|
| Split horizontal | `Ctrl+Shift+D` | `Ctrl+A` → `d` |
| Split vertical | `Ctrl+Shift+E` | `Ctrl+A` → `e` |
| Navigate panes | `Alt+Arrow` | `Alt+Arrow` |
| Zoom pane | `Ctrl+Shift+Z` | `Ctrl+A` → `z` |
| Close pane | `Ctrl+Shift+X` | `Ctrl+A` → `x` |

---

## Quick Decision: WezTerm Splits vs tmux Splits

| Scenario | Use |
|---|---|
| Multiple local terminals side by side | WezTerm splits |
| SSH session that must survive disconnects | tmux splits |
| Quick SSH command, no persistence needed | WezTerm split + SSH |
| Working from phone (Termux) | tmux always |
