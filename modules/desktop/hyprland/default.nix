# Hyprland wayland compositor (currently disabled, for future use)
{pkgs, inputs, ...}: {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;  # Enable if using NVIDIA
  };

  # Required services for illogical-impulse / QuickShell
  services.geoclue2.enable = true;  # For QtPositioning
  services.upower.enable = true;
  # Additional packages for Hyprland
  environment.systemPackages = with pkgs; [
    # Wayland utilities
    waybar           # Status bar
    wofi            # Application launcher  
    swaybg          # Wallpaper
    wl-clipboard    # Clipboard manager
    grim            # Screenshot utility
    slurp           # Screen selection utility
    swaylock        # Screen locker
    mako            # Notification daemon
  ];

  # Recommended fonts for illogical-impulse
  fonts.packages = with pkgs; [
    rubik
    nerd-fonts.ubuntu
  ];
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
    ];
    
    # REQUIRED: Tells NixOS to use the KDE portal by default
    config = {
      common = {
        default = [ "kde" ];
      };
    };
  };
}
