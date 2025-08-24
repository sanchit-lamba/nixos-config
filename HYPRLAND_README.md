# Hyprland Trail Branch

This branch migrates from GNOME to Hyprland window manager using configuration inspired by @JaKooLit/NixOS-Hyprland.

## Changes Made

### 1. Repository Structure
- Created `hosts/BlitzWing/` directory with host-specific configuration
- Added `modules/` directory for reusable modules
- Moved from monolithic `configuration.nix` to modular structure

### 2. Desktop Environment Migration
- **Removed**: GNOME desktop environment and GDM display manager
- **Added**: Hyprland window manager with greetd login manager
- **Replaced**: X11 with Wayland-native setup

### 3. Key Files Changes
- `flake.nix`: Added JaKooLit's Hyprland config and QuickShell inputs
- `hosts/BlitzWing/config.nix`: Main system configuration with Hyprland
- `hosts/BlitzWing/packages-fonts.nix`: Hyprland-specific packages and fonts
- `home/san.nix`: Updated home-manager with Hyprland configuration

### 4. Package Updates
- Added Hyprland ecosystem packages (waybar, hyprlock, hypridle, etc.)
- Added Wayland utilities (grim, slurp, swappy, cliphist, etc.)
- Added terminal and application launcher (kitty, rofi-wayland)

### 5. Configuration Features
- Basic Hyprland window manager configuration
- Greetd with tuigreet for login
- Maintained existing GTK theming
- Preserved existing applications and user packages

## Hyprland Keybinds

### Basic Controls
- `SUPER + T`: Open terminal (kitty)
- `SUPER + Q`: Close active window
- `SUPER + M`: Exit Hyprland
- `SUPER + E`: Open file manager (thunar)
- `SUPER + V`: Toggle floating mode
- `SUPER + R`: Open application launcher (rofi)
- `SUPER + P`: Toggle pseudo-tiling
- `SUPER + J`: Toggle window split

### Window Navigation
- `SUPER + Arrow Keys`: Move focus between windows
- `SUPER + [1-9,0]`: Switch to workspace 1-10
- `SUPER + SHIFT + [1-9,0]`: Move window to workspace 1-10

### Mouse Controls
- `SUPER + Left Click`: Move window
- `SUPER + Right Click`: Resize window

## How to Use

1. Switch to this branch:
   ```bash
   git checkout hyprland-trail
   ```

2. Build and switch to the new configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#BlitzWing
   ```

3. Reboot to start using Hyprland

## Reverting

To revert back to GNOME, switch back to the master branch and rebuild:
```bash
git checkout master
sudo nixos-rebuild switch --flake .#BlitzWing
```

## Customization

- Edit `hosts/BlitzWing/config.nix` for system-level changes
- Edit `home/san.nix` for user-specific Hyprland configuration
- Add packages to `hosts/BlitzWing/packages-fonts.nix`

## Post-Installation Steps

After switching to Hyprland, you may want to:

1. **Install JaKooLit's Hyprland Dots** for a complete desktop experience:
   ```bash
   # This will download and install the complete Hyprland configuration
   git clone https://github.com/JaKooLit/Hyprland-Dots.git ~/Hyprland-Dots
   cd ~/Hyprland-Dots
   ./install.sh
   ```

2. **Configure GTK themes** using nwg-look:
   ```bash
   nwg-look
   ```

3. **Set up wallpapers** using swww:
   ```bash
   # Example: Set a wallpaper
   swww img /path/to/your/wallpaper.jpg
   ```

4. **Customize Waybar** by editing `~/.config/waybar/config`

5. **Configure additional applications** as needed

## Notes

- The original GNOME configuration is backed up as `configuration-gnome-backup.nix`
- Hyprland configuration can be further customized based on JaKooLit's dots
- Font packages have been adjusted for stable channel compatibility