# Modular NixOS Configuration

A modular NixOS configuration based on [Sly-Harvey/NixOS](https://github.com/Sly-Harvey/NixOS) structure, completely restructured for maintainability and modularity.

## Structure

```
├── flake.nix                 # Main flake configuration with inputs and settings
├── hosts/                    # Host-specific configurations
│   ├── BlitzWing/           # Current system configuration
│   │   ├── configuration.nix # Host-specific settings
│   │   └── hardware-configuration.nix # Hardware scan results
│   └── common.nix           # Shared configuration across all hosts
├── modules/                 # Modular system configurations
│   ├── desktop/            # Desktop environments
│   │   ├── gnome/          # GNOME desktop configuration
│   │   ├── hyprland/       # Hyprland wayland compositor (optional)
│   │   └── wayland.nix     # Wayland application patches
│   ├── hardware/           # Hardware-specific modules
│   │   ├── drives/         # Drive and filesystem support
│   │   └── video/          # GPU driver configurations (AMD/NVIDIA/Intel)
│   ├── programs/           # Application modules
│   │   ├── browsers/       # Web browsers
│   │   ├── development/    # Development tools
│   │   ├── media/          # Media applications
│   │   ├── shell/          # Shell configurations
│   │   ├── terminal/       # Terminal applications
│   │   ├── utilities/      # System utilities
│   │   └── virtualization/ # Virtualization tools (winapps, etc.)
│   └── themes/             # Theme configurations (gruvbox)
├── home/                   # Home Manager configurations
│   └── san.nix            # User-specific configuration
├── overlays/               # Custom package overlays
└── pkgs/                   # Custom packages
```

## Key Features

- **Modular Design**: Each component is separated into its own module for easy management
- **Configurable Settings**: System settings defined in `flake.nix` for easy customization
- **Hardware Abstraction**: GPU drivers (AMD/NVIDIA/Intel) and hardware configurations are modularized
- **Desktop Environment Support**: Currently GNOME, with Hyprland ready for future use
- **Enhanced Theming**: Gruvbox dark theme with proper GTK/Qt integration
- **Modern NixOS Practices**: Uses flakes, home-manager, and latest NixOS features
- **Easy Deployment**: Automated scripts for system and home-manager deployment

## Configuration

**IMPORTANT**: Before using this configuration, you must customize it for your system:

### Required Changes
1. **Hardware Configuration**: Replace placeholder UUIDs in `hosts/BlitzWing/hardware-configuration.nix`
   - Run `sudo blkid` to find your actual UUIDs
   - Replace `REPLACE-WITH-YOUR-ROOT-UUID` with your root filesystem UUID
   - Replace `REPLACE-WITH-YOUR-BOOT-UUID` with your boot partition UUID
   - Replace `REPLACE-WITH-YOUR-SWAP-UUID` with your swap device UUID

2. **User Configuration**: Update user settings in `flake.nix`:
   - Change `username = "san"` to your desired username
   - Change `hostname = "BlitzWing"` to your desired hostname
   - Update timezone and locale settings as needed

3. **System Settings**: Verify hardware-specific settings:
   - GPU driver (`videoDriver = "amdgpu"`) - change to "nvidia" or "intel" as needed
   - Review hardware modules in your host configuration

### Current Configuration
The system is currently configured for:
- **User**: san (change this!)
- **Hostname**: BlitzWing (change this!)
- **Desktop**: GNOME with Wayland
- **GPU**: AMD (amdgpu driver)
- **Theme**: Gruvbox Dark
- **Locale**: en_IN (India)
- **Timezone**: Asia/Kolkata

## Usage

### Quick deployment
```bash
./install.sh          # Full system deployment with confirmation
./home-manager.sh      # Home Manager only deployment
```

### Manual deployment
#### Rebuilding the system
```bash
sudo nixos-rebuild switch --flake .#BlitzWing
```

#### Updating flake inputs
```bash
nix flake update
```

#### Testing configuration
```bash
sudo nixos-rebuild test --flake .#BlitzWing
```

#### Home Manager (standalone)
```bash
home-manager switch --flake .#san
```

## Adding New Modules

1. Create module in appropriate directory under `modules/`
2. Add import to host configuration in `hosts/BlitzWing/configuration.nix`
3. Configure module-specific settings

## Migration from Original

All original functionality has been preserved while gaining:
- Better organization and maintainability
- Easier hardware configuration management
- Modular application management
- Enhanced theming capabilities
- Future extensibility for multiple hosts/users

## Credits

- Structure inspired by [Sly-Harvey/NixOS](https://github.com/Sly-Harvey/NixOS)
- Merged and restructured for optimal modularity and public use