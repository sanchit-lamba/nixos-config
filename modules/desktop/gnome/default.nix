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
        
        [org.gnome.desktop.interface]
        gtk-theme='gruvbox-dark'
        icon-theme='Gruvbox-Plus-Dark'
        cursor-theme='Bibata-Modern-Classic'
        color-scheme='prefer-dark'
        
        [org.gnome.desktop.wm.preferences]
        theme='gruvbox-dark'
      '';
      extraGSettingsOverridePackages = [ pkgs.mutter pkgs.gnome-settings-daemon ];
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
    
    # Additional GNOME theming tools
    dconf-editor
    gnome-settings-daemon
  ];
}
