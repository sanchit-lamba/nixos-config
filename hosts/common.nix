{
  inputs,
  outputs,
  pkgs,
  username,
  hostname,
  browser,
  terminal,
  locale,
  timezone,
  kbdLayout,
  kbdVariant,
  consoleKeymap,
  config,
  self,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nix-index-database.nixosModules.nix-index
  ];

  programs.nix-index-database.comma.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    description = "Sanchit";
    extraGroups = [
      "adbusers"
      "uinput"
      "networkmanager"
      "wheel"
      "docker"
      "kvm"
      "input"
      "disk"
      "video"
      "audio"
    ];
  };

  # Common home-manager options that are shared between all systems.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-bak";
    extraSpecialArgs = { inherit inputs; } // { inherit username browser terminal; };
    users.${username} = self.san-module;
  };

  # Filesystems support
  boot.supportedFilesystems = ["ntfs" "exfat" "ext4" "fat32" "btrfs"];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Bootloader - keeping systemd-boot for now
  boot = {
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
  };

  # Set hostname
  networking.hostName = hostname;

  # Timezone and locale
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  console.keyMap = consoleKeymap;
  services.xserver = {
    enable = true;
    exportConfiguration = true;
    xkb = {
      layout = kbdLayout;
      variant = kbdVariant;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Enable dconf for home-manager and GNOME
  programs.dconf.enable = true;

  # Enable bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    # Keep existing firewall rules for KDE Connect
    firewall = {
      enable = true;
      allowedTCPPortRanges = [ {from = 1714; to = 1764;} ];
      allowedUDPPortRanges = [ {from = 1714; to = 1764;} ];
    };
  };

  # Setup keyring
  services.gnome.gnome-keyring.enable = true;

  # Enable CUPS to print documents
  # services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
          bluetooth.autoswitch-to-headset-profile = false
        '')
      ];
    };
  };

  # Enable touchpad support
  services.libinput.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # XDG portal setup for modern desktop integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "libsoup-2.74.3"
      ];
    };
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
    EDITOR = "nvim";
    BROWSER = browser;
    TERMINAL = terminal;
  };

  # Hardware support
  hardware.enableRedistributableFirmware = true;

  # Essential system packages
  environment.systemPackages = with pkgs; [
    # System utilities
    killall
    lm_sensors
    jq
    git  # Keep git as it's essential for system operations
    wget
    curl
    unzip
  ];

  # Programs that need special configuration
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    adb.enable = true;
  };

  # Services
  services = {
    asusd.enable = true;
    kanata.enable = true;
  };

  # Virtualization
  virtualisation.docker.enable = true;

  # Nix settings
  nix = {
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
    };
    optimise.automatic = true;
    package = pkgs.nixVersions.latest;
  };

  # This value determines the NixOS release
  system.stateVersion = "25.05";
}
