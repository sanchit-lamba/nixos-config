{
  pkgs,
  videoDriver,
  hostname,
  browser,
  editor,
  terminal,
  desktop,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/video/${videoDriver}.nix
    ../../modules/hardware/drives

    ../common.nix
    
    # Desktop environment
    ../../modules/desktop/${desktop}
    
    # Programs - keeping current applications
    ../../modules/programs/browsers
    ../../modules/programs/development
    ../../modules/programs/media
    ../../modules/programs/utilities
  ];

  # Additional packages specific to this system
  environment.systemPackages = with pkgs; [
    # Applications from original config
    vscode
    obsidian
    stremio
    vivaldi
    neovim
    podman
    podman-compose
    docker
    vivaldi-ffmpeg-codecs
    warp-terminal
    
    # GNOME applications
    gnome-calculator
    gnome-characters
    gnome-color-manager
    gnome-disk-utility
    gnome-system-monitor
    file-roller
    gnome-terminal
    gnome-text-editor
    gnome-tweaks
    gnome-shell-extensions
    
    # Utilities
    kdiff3
    hardinfo2
    haruna
    wayland-utils
    wl-clipboard
    code-cursor
  ];

  # Home-manager specific packages for this host
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      # User-specific packages from original home config
      asusctl
      p3x-onenote
      newsflash
      gh
      git
      rclone
      fastfetch
      mpv
      kanata-with-cmd
      neovim
      ghostty
      obs-studio
      android-tools
      thunderbird
      ulauncher
      refine
      ocs-url
      lm_sensors
    ];
  };

  # System services specific to this machine
  services = {
    # Keep existing service configurations
  };
}