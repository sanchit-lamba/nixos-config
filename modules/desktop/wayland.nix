{
  lib,
  pkgs,
  ...
}: let
  waylandAppsMap = {
    # Package Name = Binary Name
    "vscode" = "code";
    "obsidian" = "obsidian";
    "stremio" = "stremio";
    "beeper" = "beeper";
  };
in {
  nixpkgs.overlays = [
    (
      final: prev: let
        wrapElectronApp = pkg: binName:
          pkg.overrideAttrs (oldAttrs: {
            postFixup =
              (oldAttrs.postFixup or "")
              + ''
                wrapProgram $out/bin/${binName} \
                  --add-flags ""
              '';
          });
      in
        # Use lib.mapAttrs to apply the wrapper to each app in our map
        lib.mapAttrs' (
          pkgName: binName:
            lib.nameValuePair pkgName (wrapElectronApp prev.${pkgName} binName)
        )
        waylandAppsMap
    )
  ];
}
