# Basic configuration for Hyprland migration

This directory contains the Hyprland configuration module that replaces GNOME in your NixOS setup.

## Key Features

- **Window Manager**: Hyprland with tiling window management
- **Display Manager**: SDDM (replacing GDM) 
- **Status Bar**: Waybar with system information
- **Application Launcher**: Rofi (Super+Space)
- **Notifications**: SwayNC
- **Screen Locker**: Hyprlock (can be added later)
- **Screenshot Tool**: Grimblast (can be added later)

## Key Keybindings

- `Super+Return`: Open terminal (ghostty)
- `Super+Space`: Application launcher (rofi)
- `Super+Q`: Close window
- `Super+W`: Toggle floating
- `Super+F`: Toggle fullscreen
- `Super+E`: File manager (nautilus)
- `Super+1-9`: Switch to workspace
- `Super+Shift+1-9`: Move window to workspace
- `Super+Arrow Keys`: Move focus between windows

## System Integration

- Volume and brightness keys work out of the box
- Network manager applet in system tray
- Clipboard history with cliphist
- Proper XDG portal setup for file dialogs
- Wayland environment variables configured

## Theme Compatibility

Your existing gruvbox-dark theme setup is preserved and will work with GTK applications running under Hyprland.