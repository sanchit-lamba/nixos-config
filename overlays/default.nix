{
  pkgs,
  lib,
  ...
}: {
  wayland-apps = final: prev: let
    waylandAppsMap = {
      "vscode" = "code";
      "obsidian" = "obsidian";
      "stremio" = "stremio";
      "beeper" = "beeper";
    };

    wrapElectronApp = pkg: binName:
      pkg.overrideAttrs (oldAttrs: {
        postFixup =
          (oldAttrs.postFixup or "")
          + ''
            wrapProgram $out/bin/${binName} \
              --add-flags "\
                --enable-features=UseOzonePlatform \
                --ozone-platform=wayland \
              "
          '';
      });
  in
    lib.mapAttrs' (
      pkgName: binName:
        lib.nameValuePair pkgName (wrapElectronApp prev.${pkgName} binName)
    )
    waylandAppsMap;
}
