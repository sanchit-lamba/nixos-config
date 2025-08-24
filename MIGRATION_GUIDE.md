# GNOME to Hyprland Migration Guide

This document describes the migration from GNOME to Hyprland that has been performed on your NixOS configuration.

## What Was Changed

### 1. Desktop Environment
- **Removed**: GNOME desktop environment and GDM display manager
- **Added**: Hyprland compositor with SDDM display manager
- **Reason**: Modern tiling window manager with better Wayland support

### 2. System Packages Removed
The following GNOME-specific packages were removed:
- `gnome-calculator`, `gnome-characters`, `gnome-color-manager`
- `gnome-disk-utility`, `gnome-system-monitor`, `gnome-terminal`
- `gnome-text-editor`, `gnome-tweaks`, `gnome-shell-extensions`
- `gnome-themes-extra`

### 3. New Hyprland Ecosystem Added
- **Waybar**: Status bar showing workspaces, time, system info
- **Rofi**: Application launcher (Super+Space)
- **SwayNC**: Notification daemon
- **Hyprpaper**: Wallpaper management
- **Grimblast/Grim/Slurp**: Screenshot tools
- **Cliphist**: Clipboard manager

### 4. Home Manager Changes
- Removed GNOME-specific dconf settings
- Removed Firefox GNOME theme dependency
- Kept GTK theming for application compatibility
- Added Hyprland, Waybar, and Rofi configurations

## What Was Preserved

### User Applications
All your existing applications are preserved:
- Development tools (vscode, obsidian, neovim, gh, git)
- Media (haruna, mpv, obs-studio, thunderbird)
- System utilities (asusctl, android-tools, lm_sensors)
- Browsers (firefox, vivaldi)
- Terminal (ghostty)

### System Configuration
- Sound system (PipeWire)
- Network management
- Docker, ADB, ASUSD services
- User account and groups
- Theming (gruvbox-dark preserved)

### Hardware Support
- All existing hardware configurations maintained
- Wayland utilities preserved
- Existing kernel modules and drivers

## Key Differences

### Window Management
- **GNOME**: Traditional desktop with overview and activities
- **Hyprland**: Tiling window manager with workspaces

### Application Launching
- **GNOME**: Activities overview or Alt+F2
- **Hyprland**: Rofi launcher (Super+Space)

### System Settings
- **GNOME**: GNOME Settings and Tweaks
- **Hyprland**: System settings through individual applications (pavucontrol, nm-applet, etc.)

## Getting Started

### Essential Keybindings
- `Super+Return`: Open terminal
- `Super+Space`: Application launcher
- `Super+Q`: Close window
- `Super+W`: Toggle floating mode
- `Super+F`: Toggle fullscreen
- `Super+1-9`: Switch workspaces
- `Super+Shift+1-9`: Move window to workspace

### System Tray
The system tray (right side of waybar) provides access to:
- Network manager
- Sound control (click to open pavucontrol)
- Notifications (SwayNC)

### Clipboard
- Clipboard history: `Super+V`
- Screenshots: Use grim/slurp or add screenshot keybindings

## Potential Issues and Solutions

### Missing Applications
If you had GNOME-specific applications you relied on:
- **Calculator**: Install `gnome-calculator` or use `qalculate-gtk`
- **System Monitor**: Use `btop`, `htop`, or install `gnome-system-monitor`
- **Archive Manager**: `file-roller` is included
- **Text Editor**: Use `neovim`, `vscode`, or install `gnome-text-editor`

### Theming Issues
If some applications don't look right:
- GTK theme is preserved (gruvbox-dark)
- For Qt applications, install `qt6ct` and configure themes
- Some GNOME applications may need `gsettings` adjustments

### Wayland Compatibility
Most applications should work, but if you encounter issues:
- Some older applications may need XWayland
- Check if apps have Wayland-specific flags
- Electron apps should work with the existing wayland.nix overlay

## Building and Applying Changes

To apply this configuration:

```bash
# Build the configuration
sudo nixos-rebuild switch --flake .#BlitzWing

# Or if you're testing first
sudo nixos-rebuild test --flake .#BlitzWing
```

## Customization

The Hyprland configuration is in `modules/desktop/hyprland/default.nix`. You can:
- Modify keybindings in the `bind` section
- Adjust window rules for specific applications
- Change colors, gaps, and animation settings
- Add more startup applications to `exec-once`

The Waybar configuration is included and can be customized for different modules and appearance.