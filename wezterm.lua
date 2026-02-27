-- WezTerm Configuration
-- Cross-platform setup: Windows (PowerShell + WSL) & Ubuntu
-- https://wezfurlong.org/wezterm/config/files.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action

-- ============================================================================
-- APPEARANCE
-- ============================================================================

-- Theme: Catppuccin Mocha (built-in)
config.color_scheme = "Catppuccin Mocha"

-- Font: JetBrains Mono Nerd Font
-- Install from: https://www.nerdfonts.com/font-downloads
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" })
config.font_size = 12.0

-- Font rendering
config.freetype_load_flags = "NO_HINTING"
config.cell_width = 1.0
config.line_height = 1.15

-- Window appearance
config.window_background_opacity = 0.92
config.macos_window_background_blur = 30
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 12,
	right = 12,
	top = 12,
	bottom = 6,
}

-- Tab bar
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false

config.window_frame = {
	font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
	font_size = 10.0,
}

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ============================================================================
-- BACKGROUND IMAGE (optional)
-- ============================================================================
-- Place a background image (e.g. bg.png) in your dotfiles repo.
-- Uncomment below to enable. Keep images < 2-3MB for performance.

local home = os.getenv("HOME") or os.getenv("USERPROFILE")
local dotfiles_dir = home .. "/dotfiles"

config.background = {
	{
		source = { File = dotfiles_dir .. "/bg.png" },
		hsb = { brightness = 0.03 },
		width = "Cover",
		height = "Cover",
	},
}

-- ============================================================================
-- SHELL / DEFAULT PROGRAM
-- ============================================================================

-- Platform-specific default shell
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- Windows: default to PowerShell
	config.default_prog = { "pwsh.exe", "-NoLogo" }
elseif wezterm.target_triple:find("apple") then
	-- macOS: use Zsh (built-in since Catalina)
	config.default_prog = { "/bin/zsh" }
else
	-- Linux: use Zsh
	config.default_prog = { "/usr/bin/zsh" }
end

-- ============================================================================
-- KEYBINDINGS — Consistent across platforms
-- ============================================================================
-- Philosophy: Ctrl+Shift for terminal actions, Alt for pane navigation
-- These work the same on Windows and Linux

config.keys = {
	-- ── Tabs ──────────────────────────────────────────────
	{ key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
	{ key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

	-- Direct tab access: Ctrl+Shift+1..9
	{ key = "1", mods = "CTRL|SHIFT", action = act.ActivateTab(0) },
	{ key = "2", mods = "CTRL|SHIFT", action = act.ActivateTab(1) },
	{ key = "3", mods = "CTRL|SHIFT", action = act.ActivateTab(2) },
	{ key = "4", mods = "CTRL|SHIFT", action = act.ActivateTab(3) },
	{ key = "5", mods = "CTRL|SHIFT", action = act.ActivateTab(4) },

	-- ── Splits / Panes ───────────────────────────────────
	{ key = "d", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "e", mods = "CTRL|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "x", mods = "CTRL|SHIFT", action = act.CloseCurrentPane({ confirm = true }) },

	-- Navigate panes: Alt + Arrow keys
	{ key = "LeftArrow", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "ALT", action = act.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "ALT", action = act.ActivatePaneDirection("Down") },

	-- Resize panes: Alt+Shift + Arrow keys
	{ key = "LeftArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Left", 3 }) },
	{ key = "RightArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Right", 3 }) },
	{ key = "UpArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Up", 3 }) },
	{ key = "DownArrow", mods = "ALT|SHIFT", action = act.AdjustPaneSize({ "Down", 3 }) },

	-- ── General ──────────────────────────────────────────
	{ key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
	{ key = "f", mods = "CTRL|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ClearScrollback("ScrollbackAndViewport") },
	{ key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
	{ key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },

	-- Font size
	{ key = "=", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = act.ResetFontSize },

	-- ── Quick launch (Windows): Switch between WSL and PowerShell ──
	-- Ctrl+Shift+U → new WSL tab
	-- Ctrl+Shift+P → new PowerShell tab (Windows only, no-op on Linux)
	{
		key = "u",
		mods = "CTRL|SHIFT",
		action = act.SpawnTab({ DomainName = "WSL:Ubuntu" }),
	},
}

-- Windows-only: PowerShell quick-launch
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(config.keys, {
		key = "o",
		mods = "CTRL|SHIFT",
		action = act.SpawnCommandInNewTab({ args = { "pwsh.exe", "-NoLogo" } }),
	})
end

-- ============================================================================
-- LAUNCH MENU (right-click on + or use Ctrl+Shift+P)
-- ============================================================================

config.launch_menu = {}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	table.insert(config.launch_menu, { label = " WSL: Zsh", args = { "wsl.exe", "--distribution", "Ubuntu", "--exec", "/usr/bin/zsh" } })
	table.insert(config.launch_menu, { label = " PowerShell", args = { "pwsh.exe", "-NoLogo" } })
	table.insert(config.launch_menu, { label = " CMD", args = { "cmd.exe" } })
elseif wezterm.target_triple:find("apple") then
	table.insert(config.launch_menu, { label = " Zsh", args = { "/bin/zsh" } })
	table.insert(config.launch_menu, { label = " Bash", args = { "/bin/bash" } })
else
	table.insert(config.launch_menu, { label = " Zsh", args = { "/usr/bin/zsh" } })
	table.insert(config.launch_menu, { label = " Bash", args = { "/usr/bin/bash" } })
end

-- Add SSH quick-connect to your headless Ubuntu server
table.insert(config.launch_menu, {
	label = "🖥 SSH: Ubuntu Server",
	args = { "ssh", "daniel@192.168.0.187" },
})

-- ============================================================================
-- SCROLLBACK & PERFORMANCE
-- ============================================================================

config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = "Disabled"

-- GPU settings
-- Use OpenGL on Linux to avoid Vulkan/wgpu crashes (e.g. on CachyOS)
if wezterm.target_triple:find("linux") then
	config.front_end = "OpenGL"
else
	config.front_end = "WebGpu"
	config.webgpu_power_preference = "HighPerformance"
end
config.max_fps = 120
config.animation_fps = 60

-- ============================================================================
-- WSL DOMAINS (Windows only — for WSL integration)
-- ============================================================================
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.wsl_domains = {
		{
			name = "WSL:Ubuntu",
			distribution = "Ubuntu",
			default_cwd = "~",
		},
	}
end

-- ============================================================================
-- SSH DOMAINS (optional — for direct SSH tabs)
-- ============================================================================
config.ssh_domains = {
	{
		name = "ubuntu-server",
		remote_address = "192.168.0.187:22",
		username = "daniel",
	},
}

return config
