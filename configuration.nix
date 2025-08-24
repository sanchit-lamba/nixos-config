# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib,inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.enableRedistributableFirmware = true;
  networking.hostName = "BlitzWing"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  #dconf
  programs.dconf.enable = true;
  #xdg 
  xdg.portal = {
  enable = true;
  wlr.enable = true;
  # extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
};
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

 
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.kanata.enable = true;
  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.san = {
    isNormalUser = true;
    description = "Sanchit";
    group = "users";
    extraGroups = ["adbusers" "uinput" "networkmanager" "wheel" "docker" "networkmanager"];
    packages = with pkgs; [
      
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     gh
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
     lazygit
     git
     firefox
    # GNOME applications and utilities
    gnome-calculator # Calculator
    gnome-characters # Character selector
    gnome-color-manager # Color management
    gnome-disk-utility # Disk management
    gnome-system-monitor # System monitor
    file-roller # Archive manager
    gnome-terminal # Terminal
    gnome-text-editor # Text editor
    gnome-tweaks # GNOME tweaks
    gnome-shell-extensions # GNOME extensions manager
    
    # Keep some useful applications
    kdiff3 # Compares and merges 2 or 3 files or directories
    hardinfo2 # System information and benchmarks for Linux systems
    haruna # Open source video player built with Qt/QML and libmpv
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities ford
    code-cursor
    gsettings-desktop-schemas
    gtk-engine-murrine  # Required by many themes
    gnome-themes-extra
    gruvbox-dark-gtk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPortRanges = [ {from = 1714; to = 1764;} ];
  networking.firewall.allowedUDPPortRanges = [ {from = 1714; to = 1764;} ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  services.xserver = {
    enable = true;
    desktopManager.gnome = {
      enable = true;
      # This is the important part to make fractional scaling appear in the UI
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
      # Ensure Mutter schemas are available for GSettings
      extraGSettingsOverridePackages = [ pkgs.mutter ];
    };
    displayManager.gdm = {
      enable = true;
      wayland = true; # Crucial for modern Gnome HiDPI on Wayland
    };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  home-manager = {
    backupFileExtension = "hm-bak";
    extraSpecialArgs = { inherit inputs; };
    users.san = import ./home/san.nix;}; 
  programs.adb.enable = true;
  services.asusd.enable = true;
  virtualisation.docker.enable = true;
  programs.dconf.enable = true;

# Ensure XDG desktop integration is enabled
xdg.portal = {
  enable = true;
  wlr.enable = true;
};

# IMPORTANT: Add gruvbox-dark-gtk to system packages so it's available system-wide
environment.systemPackages = with pkgs; [
  # ... your existing packages (vscode, obsidian, etc.) ...
  
  # CRITICAL: Add gruvbox theme to system packages
  gruvbox-dark-gtk
  
  # GTK theming support packages:
  gsettings-desktop-schemas
  gtk-engine-murrine
  gnome-themes-extra
];
}
