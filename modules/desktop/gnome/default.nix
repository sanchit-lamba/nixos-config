{pkgs, ...}: {
  imports = [
    ../wayland.nix
  ];
  
  services.xserver = {
    enable = true;
    desktopManager.gnome = {
      enable = true;
      # HiDPI scaling support
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
      extraGSettingsOverridePackages = [ pkgs.mutter ];
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
  ];
}
