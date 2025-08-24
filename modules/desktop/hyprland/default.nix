# Hyprland wayland compositor (currently disabled, for future use)
{pkgs, inputs, ...}: {
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    # enableNvidiaPatches = true;  # Enable if using NVIDIA
  };

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

  # XDG portal for Hyprland
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}