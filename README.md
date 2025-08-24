# Sanchit's NixOS Configuration

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
│   │   └── wayland.nix     # Wayland application patches
│   ├── hardware/           # Hardware-specific modules
│   │   ├── drives/         # Drive and filesystem support
│   │   └── video/          # GPU driver configurations
│   ├── programs/           # Application modules
│   │   ├── browsers/       # Web browsers
│   │   ├── development/    # Development tools
│   │   ├── media/          # Media applications
│   │   ├── shell/          # Shell configurations
│   │   ├── terminal/       # Terminal applications
│   │   ├── utilities/      # System utilities
│   │   └── virtualization/ # Virtualization tools
│   └── themes/             # Theme configurations
├── home/                   # Home Manager configurations
│   └── san.nix            # User-specific configuration
├── overlays/               # Custom package overlays
└── pkgs/                   # Custom packages
```

## Key Features

- **Modular Design**: Each component is separated into its own module for easy management
- **Configurable Settings**: System settings defined in `flake.nix` for easy customization
- **Hardware Abstraction**: GPU drivers and hardware configurations are modularized
- **Desktop Environment Support**: Currently GNOME, easily extensible to other DEs
- **Enhanced Theming**: Gruvbox dark theme with proper GTK/Qt integration
- **Modern NixOS Practices**: Uses flakes, home-manager, and latest NixOS features

## Configuration

The system is configured for:
- **User**: san
- **Hostname**: BlitzWing
- **Desktop**: GNOME with Wayland
- **GPU**: AMD (amdgpu driver)
- **Theme**: Gruvbox Dark
- **Locale**: en_IN (India)
- **Timezone**: Asia/Kolkata

## Usage

### Rebuilding the system
```bash
sudo nixos-rebuild switch --flake .#BlitzWing
```

### Updating flake inputs
```bash
nix flake update
```

### Testing configuration
```bash
sudo nixos-rebuild test --flake .#BlitzWing
```

### Home Manager (standalone)
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
- Original configuration by sanchit-lamba
- Merged and restructured for optimal modularity