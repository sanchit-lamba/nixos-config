# Gaming Setup

This configuration now includes gaming support through the `@fufexan/nix-gaming` flake.

## What's included:

### Game Launchers
- **Steam**: Full Steam installation with network features enabled
- **Lutris**: Open source gaming platform for Linux
- **Heroic**: Epic Games Store and GOG launcher
- **Bottles**: Wine prefix manager for Windows games

### Gaming Utilities
- **GameMode**: CPU/GPU performance optimizations during gaming
- **MangoHUD**: In-game performance overlay
- **GameScope**: Gaming compositor for better performance

### Compatibility
- **Wine**: Windows compatibility layer
- **Winetricks**: Wine configuration and Windows libraries installer

### Hardware Support
- **Xbox Controller Support**: via xpadneo driver
- **32-bit Graphics**: Already enabled through AMD GPU configuration

### System Optimizations
- **Kernel tuning**: `vm.max_map_count` increased for modern games
- **Platform optimizations**: From nix-gaming for better performance

## How to use:

After rebuilding your system with `sudo nixos-rebuild switch --flake .#BlitzWing`, you'll have:

1. **Steam**: Available in applications menu
2. **Lutris**: For managing non-Steam games
3. **Heroic**: For Epic Games Store and GOG games
4. **GameMode**: Automatically activated by compatible games
5. **MangoHUD**: Use with `mangohud %command%` in Steam launch options

## Network Features:
- Steam Remote Play ports are open
- Steam Local Network Game Transfers enabled
- Steam Dedicated Server ports open