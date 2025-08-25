# Setup Instructions

This configuration has been sanitized for public use. Before deploying, you must customize it for your system.

## Required Steps

### 1. Hardware Configuration
Replace the placeholder UUIDs in `hosts/BlitzWing/hardware-configuration.nix`:

```bash
# Find your actual UUIDs
sudo blkid

# Edit the hardware configuration
nano hosts/BlitzWing/hardware-configuration.nix
```

Replace these placeholders with your actual UUIDs:
- `REPLACE-WITH-YOUR-ROOT-UUID` → Your root filesystem UUID
- `REPLACE-WITH-YOUR-BOOT-UUID` → Your boot partition UUID  
- `REPLACE-WITH-YOUR-SWAP-UUID` → Your swap device UUID

### 2. User and System Settings
Edit `flake.nix` and update the settings section:

```nix
settings = {
  # User configuration
  username = "your-username";        # Change from "san"
  hostname = "your-hostname";        # Change from "BlitzWing"
  
  # Desktop preferences  
  desktop = "gnome";                 # or "hyprland"
  browser = "firefox";
  terminal = "gnome-terminal";
  editor = "vscode";
  
  # System configuration
  videoDriver = "amdgpu";            # "amdgpu", "nvidia", or "intel"
  locale = "en_US";                  # Your locale
  timezone = "America/New_York";     # Your timezone
  kbdLayout = "us";                  # Your keyboard layout
};
```

### 3. Update Scripts
If you changed the username, update these files:
- `home-manager.sh` → Update the user reference
- `install.sh` → Update hostname references if needed

### 4. Optional: Rename Host Directory
If you changed the hostname, consider renaming:
```bash
mv hosts/BlitzWing hosts/YourHostname
```

And update the import in `flake.nix`:
```nix
nixosConfigurations = {
  YourHostname = nixpkgs.lib.nixosSystem {
    # ...
    modules = [
      ./hosts/YourHostname/configuration.nix
    ];
  };
};
```

## Verification

After making changes:

1. Check flake syntax:
   ```bash
   nix flake check
   ```

2. Test build (don't switch yet):
   ```bash
   sudo nixos-rebuild build --flake .#YourHostname
   ```

3. If successful, switch:
   ```bash
   sudo nixos-rebuild switch --flake .#YourHostname
   ```

## Privacy Notes

The following items have been sanitized for public use:
- ✅ Hardware UUIDs replaced with placeholders
- ✅ Personal name replaced with generic "User"
- ✅ Repository descriptions made generic
- ✅ Setup documentation added

Safe to keep as-is:
- Username "san" (generic, change as needed)
- Hostname "BlitzWing" (not personally identifying)
- Timezone/locale (broad geographic info)
- Hardware driver configurations
- Application preferences