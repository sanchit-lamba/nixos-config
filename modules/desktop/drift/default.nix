{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.programs.driftwm = {
    enable = lib.mkEnableOption "driftwm, a trackpad-first infinite canvas Wayland compositor";
    package = lib.mkPackageOption pkgs "driftwm" {};
  };

  config = {
    programs.driftwm.enable = true;
    programs.driftwm.package = lib.mkDefault inputs.driftwm.packages.${pkgs.stdenv.hostPlatform.system}.default;

    environment.systemPackages =
      [
        config.programs.driftwm.package
      ]
      ++ lib.optional config.programs.xwayland.enable pkgs.xwayland-satellite
      ++ (with pkgs; [
        # DriftWM session tools
        waybar
        fuzzel
        mako
        libnotify

        # Qt/KDE-first basic desktop utilities
        kdePackages.dolphin
        kdePackages.dolphin-plugins
        kdePackages.kio-extras
        kdePackages.ark
        kdePackages.gwenview
        kdePackages.kate
        kdePackages.kdeconnect-kde
        kdePackages.polkit-kde-agent-1
      ]);

    services.displayManager.sessionPackages = [config.programs.driftwm.package];

    services.graphical-desktop.enable = lib.mkDefault true;
    security.polkit.enable = lib.mkDefault true;
    security.pam.services.swaylock = lib.mkDefault {};
    programs.xwayland.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;
    systemd.packages = [config.programs.driftwm.package];

    services.displayManager = {
      sddm.enable = true;
      defaultSession = "driftwm";
    };

    xdg.portal = {
      enable = lib.mkDefault true;
      configPackages = lib.mkDefault [config.programs.driftwm.package];
      extraPortals = lib.mkDefault [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];
    };
  };
}
