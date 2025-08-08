# /etc/nixos/modules/wayland-apps.nix
{ lib, pkgs, ... }:

let
  # --- Configuration ---
  # List of system-level applications to patch for native Wayland support.
  # The key is the package name from nixpkgs, and the value is the name of its executable binary.
  waylandAppsMap = {
    # Package Name = Binary Name
    "vscode"   = "code";
    "obsidian" = "obsidian";
    "stremio"  = "stremio";
    # Add any other system-level electron apps from your configuration.nix here
  };

in
{
  # This overlay applies the Wayland flags to the packages
  nixpkgs.overlays = [
    (final: prev:
      let
        wrapElectronApp = pkg: binName:
          pkg.overrideAttrs (oldAttrs: {
            postFixup = (oldAttrs.postFixup or "") + ''
              wrapProgram $out/bin/${binName} \
                --add-flags "--enable-features=UseOzonePlatform" \
                --add-flags "--ozone-platform-hint=auto"
            '';
          });
      in
      # Use lib.mapAttrs to apply the wrapper to each app in our map
      lib.mapAttrs' (pkgName: binName:
        lib.nameValuePair pkgName (wrapElectronApp prev.${pkgName} binName)
      ) waylandAppsMap
    )
  ];
}

