# ============================================================================
# Dotfiles Install Script (Windows)
# Creates the WezTerm loader file.
# Run from inside the dotfiles repo: .\install.ps1
# ============================================================================

$dotfilesDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Dotfiles directory: $dotfilesDir" -ForegroundColor Cyan
Write-Host ""

# ── WezTerm loader ──
Write-Host "Creating WezTerm loader..." -ForegroundColor Yellow
$weztermDir = "$env:USERPROFILE\.config\wezterm"
New-Item -ItemType Directory -Force -Path $weztermDir | Out-Null

$loaderContent = @'
-- Loader: redirect to dotfiles repo
local home = os.getenv("HOME") or os.getenv("USERPROFILE")
return dofile(home .. "/dotfiles/wezterm.lua")
'@

Set-Content -Path "$weztermDir\wezterm.lua" -Value $loaderContent -Encoding UTF8

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host "  $weztermDir\wezterm.lua -> loader -> $dotfilesDir\wezterm.lua" -ForegroundColor Gray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Open WezTerm - it should load the config from dotfiles"
Write-Host "  2. Zsh/tmux/Starship configs are used inside WSL"
Write-Host "     Run './install.sh' inside WSL to set up symlinks there"
Write-Host ""
