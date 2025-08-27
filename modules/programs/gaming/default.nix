# Gaming configuration with nix-gaming optimizations
{pkgs, inputs, ...}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  # Enable Steam and gaming packages
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Enable GameMode for gaming performance optimizations
  programs.gamemode.enable = true;

  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    # Game launchers and stores
    lutris         # Gaming launcher for various platforms
    heroic         # Epic Games and GOG launcher
    bottles        # Wine prefix manager
    
    # Gaming utilities
    mangohud       # Gaming overlay for monitoring
    gamemode       # Gaming performance optimization
    gamescope      # Gaming compositor
    
    # Wine and compatibility
    wine           # Windows compatibility layer
    winetricks     # Wine configuration utility
  ];

  # Enable controllers support
  hardware.xpadneo.enable = true; # Xbox One controller support
  
  # Optimize kernel for gaming
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642; # Required for some games
  };
}