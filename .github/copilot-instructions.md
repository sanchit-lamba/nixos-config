# NixOS Configuration with Home Manager

This repository contains a NixOS system configuration using Nix flakes and Home Manager for a complete GNOME desktop environment with Gruvbox theming. The system is configured for hostname "BlitzWing" with user "san".

**CRITICAL: Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

## Working Effectively

### Prerequisites and Setup
- **REQUIRED**: This configuration ONLY works on a NixOS system with Nix flakes enabled
- **REQUIRED**: You must have sudo privileges to run `nixos-rebuild`
- **REQUIRED**: Ensure experimental features are enabled: `nix.settings.experimental-features = [ "nix-command" "flakes" ]`
- **NOTE**: This configuration is specifically for hostname "BlitzWing" and user "san" (NixOS 25.05)
- **REQUIRED**: Home Manager must be available in your system or installed via `nix profile install nixpkgs#home-manager`

### Core Build and Deployment Commands
**NEVER CANCEL these commands - they can take 15-45 minutes depending on network and system**:

```bash
# Validate flake configuration (takes 2-5 minutes)
nix flake check --timeout 300

# Build and apply system configuration (takes 15-45 minutes) 
# NEVER CANCEL: Set timeout to 60+ minutes
sudo nixos-rebuild switch --flake .#BlitzWing --timeout 3600

# Apply user configuration with Home Manager (takes 5-15 minutes)
# NEVER CANCEL: Set timeout to 30+ minutes  
home-manager switch --flake .#san --timeout 1800
```

### Development Workflow
```bash
# Test configuration without applying (dry-run, takes 5-10 minutes)
sudo nixos-rebuild dry-run --flake .#BlitzWing --timeout 600

# Test Home Manager configuration (dry-run, takes 2-5 minutes)
home-manager switch --flake .#san --dry-run --timeout 300

# Update flake inputs (takes 5-10 minutes depending on network)
nix flake update --timeout 600

# Clean old generations to free space (quick operation)
sudo nix-collect-garbage -d
home-manager expire-generations "-30 days"
```

## Validation and Testing

### System Validation Steps
After making any changes, ALWAYS run these validation steps:

1. **Syntax Check**: `nix flake check` - Must pass without errors
2. **Build Test**: `sudo nixos-rebuild dry-run --flake .#BlitzWing` - Must complete successfully  
3. **Apply Changes**: `sudo nixos-rebuild switch --flake .#BlitzWing` - NEVER CANCEL, wait for completion
4. **User Config**: `home-manager switch --flake .#san` - Apply user settings
5. **System Restart**: Reboot to ensure all services start correctly
6. **Manual Testing**: Log into GNOME desktop and verify theme/applications work

### Expected Timing and Timeouts
- **CRITICAL**: NEVER CANCEL builds or long-running operations
- **Flake check**: 2-5 minutes (timeout: 300 seconds)
- **System rebuild (dry-run)**: 5-10 minutes (timeout: 600 seconds)
- **System rebuild (switch)**: 15-45 minutes (timeout: 3600 seconds)
- **Home Manager switch**: 5-15 minutes (timeout: 1800 seconds)
- **Flake update**: 5-10 minutes (timeout: 600 seconds)

### Manual Validation Scenarios
**ALWAYS test these scenarios after making changes**:

1. **Desktop Environment**: Log into GNOME, verify Gruvbox theme is applied
2. **Applications**: Launch VS Code, Firefox, Obsidian - verify Wayland support works
3. **Firefox Theme**: Check Firefox has GNOME theme integration working
4. **Development Tools**: Test `git`, `gh`, `neovim`, `docker` commands work
5. **System Services**: Verify audio (PipeWire), networking, and display manager work

## Repository Structure

### Key Configuration Files
```
.
├── flake.nix                    # Main flake definition and system config
├── flake.lock                   # Locked dependency versions  
├── configuration.nix            # System-level NixOS configuration
├── hardware-configuration.nix   # Hardware-specific settings (auto-generated)
└── home/
    ├── san.nix                  # Home Manager user configuration
    ├── wayland.nix              # Wayland support for Electron apps
    ├── winapps-flake.nix        # Windows app integration
    └── tridactylrc              # Firefox Tridactyl configuration
```

### What Each File Controls
- **flake.nix**: System architecture, NixOS version (25.05), Home Manager integration
- **configuration.nix**: GNOME desktop, system packages, services, users, networking
- **home/san.nix**: User packages, GTK/GNOME theming, Firefox configuration, dconf settings
- **home/wayland.nix**: Electron app Wayland support (VS Code, Obsidian, Stremio)
- **hardware-configuration.nix**: Auto-generated hardware settings - DO NOT MODIFY

### Key Applications and Features Configured
- **Desktop**: GNOME with Wayland, GDM display manager
- **Development**: VS Code, Neovim, Git, GitHub CLI, Docker, Podman
- **Browsers**: Firefox (with GNOME theme), Vivaldi  
- **Media**: Stremio, Haruna video player, OBS Studio
- **Productivity**: Obsidian, Thunderbird, P3X OneNote
- **Terminal**: GNOME Terminal, Warp Terminal, Ghostty
- **Theme**: Gruvbox Dark throughout (GTK, Firefox, applications)
- **Hardware**: ASUS laptop support (asusctl, asusd service)

## Common Development Tasks

### Adding System Packages
Edit `environment.systemPackages` in `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # Add your package here
  your-new-package
];
```
Then run: `sudo nixos-rebuild switch --flake .#BlitzWing`

**Search for packages**: `nix search nixpkgs package-name`
**Check if package exists**: `nix-env -qaP | grep package-name`

### Adding User Packages  
Edit `home.packages` in `home/san.nix`:
```nix
home.packages = with pkgs; [
  # Add your package here  
  your-new-package
];
```
Then run: `home-manager switch --flake .#san`

**Search for packages**: `nix search nixpkgs package-name`
**Preview changes**: `home-manager switch --flake .#san --dry-run`

### Modifying Themes or Desktop Settings
- GTK/GNOME theming: Edit `gtk` and `dconf.settings` sections in `home/san.nix`
- System-wide GNOME settings: Edit `services.xserver.desktopManager.gnome` in `configuration.nix`
- Apply with: `home-manager switch --flake .#san`

### Adding Wayland Support for Electron Apps
Edit `waylandAppsMap` in `home/wayland.nix`:
```nix
waylandAppsMap = {
  "your-electron-app" = "binary-name";
};
```

## Troubleshooting

### Build Failures
```bash
# Check flake syntax first
nix flake check

# View detailed build logs
sudo nixos-rebuild switch --flake .#BlitzWing --show-trace

# Check for dependency conflicts
nix-store --verify --check-contents
```

### Home Manager Issues
```bash
# Check Home Manager syntax
home-manager build --flake .#san

# View detailed logs  
home-manager switch --flake .#san --show-trace

# Reset Home Manager state (last resort)
home-manager expire-generations "-0 days"
```

### System Recovery
```bash
# List previous generations
sudo nixos-rebuild list-generations

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Boot into previous generation (from GRUB menu)
# Select "NixOS - Configuration X" where X is a previous generation number
```

## Critical Notes

### System-Specific Warnings
- **Hostname Dependency**: This flake is configured for hostname "BlitzWing" - commands will fail on other hostnames
- **User Dependency**: Home Manager config is specifically for user "san" 
- **Architecture**: Configured for x86_64-linux only
- **NixOS Version**: Built for NixOS 25.05 - may not work on other versions

### DO NOT Commands
- **DO NOT** modify `hardware-configuration.nix` manually
- **DO NOT** cancel long-running build operations  
- **DO NOT** run builds without adequate timeout values
- **DO NOT** skip the validation steps after making changes
- **DO NOT** run this configuration on non-NixOS systems
- **DO NOT** apply this config if your hostname is not "BlitzWing" without editing flake.nix first

### ALWAYS Commands  
- **ALWAYS** run `nix flake check` before applying changes
- **ALWAYS** test with dry-run before applying to production systems
- **ALWAYS** reboot after significant system configuration changes
- **ALWAYS** backup important data before major configuration changes

### Performance Notes
- Initial builds take longer due to package downloads
- Subsequent builds are faster due to Nix store caching
- Network speed significantly affects build times
- SSD storage recommended for optimal performance

## Common Command Reference

```bash
# Check system status
systemctl status
journalctl -xe

# Package management
nix search nixpkgs package-name
nix-store --query --requisites /run/current-system

# System information
nixos-version
nix-shell -p nix-info --run nix-info

# Home Manager status
home-manager generations
home-manager packages
```

## Quick Reference for Common Scenarios

### New Package Installation
1. **System package**: Edit `configuration.nix` → `environment.systemPackages`
2. **User package**: Edit `home/san.nix` → `home.packages`  
3. **Apply**: `sudo nixos-rebuild switch --flake .#BlitzWing` (system) or `home-manager switch --flake .#san` (user)

### After Configuration Changes
1. `nix flake check` (validate syntax)
2. `sudo nixos-rebuild dry-run --flake .#BlitzWing` (test system)
3. `sudo nixos-rebuild switch --flake .#BlitzWing` (apply system)
4. `home-manager switch --flake .#san` (apply user)
5. Reboot and test desktop environment

### Emergency Recovery
1. List generations: `sudo nixos-rebuild list-generations`
2. Rollback: `sudo nixos-rebuild switch --rollback`
3. Boot menu: Select previous generation in GRUB
4. Home Manager rollback: `home-manager expire-generations "-0 days"`

This configuration provides a complete GNOME desktop environment with development tools, theming, and modern Wayland support. Always follow the validation steps and respect the timeout requirements for reliable operation.