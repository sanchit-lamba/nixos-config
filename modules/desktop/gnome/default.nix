{pkgs, ...}: {
  imports = [
    ../wayland.nix
  ];

  services.xserver = {
    enable = true;
    desktopManager.gnome = {
      enable = true;
      # should technically be in the host specific config but realistically i'll always have a hidpi display
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
      extraGSettingsOverridePackages = [pkgs.mutter pkgs.gsettings-desktop-schemas];
    };
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.gnome.gnome-initial-setup.enable = false;
  services.gnome.games.enable = false;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-maps
    gnome-music
  ];

  environment.systemPackages = with pkgs; [
    # GNOME Extensions
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-panel
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnome-tweaks
    gnome-calculator
    gnome-characters
    gnome-disk-utility
    gnome-system-monitor
    file-roller
    gnome-text-editor

    # GNOME only GTK packages
    newsflash
    refine
    ocs-url
    lm_sensors
  ];
}
