# AstroTrain - Headless homeserver configuration
#
# Barebones laptop running as an isolated headless server with:
#   - Plex Media Server (with Real-Debrid via Zurg)
#   - Media prefetching/caching for next episodes and movies
#   - OpenClaw
#   - Tailscale VPN for remote access
{
  pkgs,
  lib,
  inputs,
  hostname,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix

    # Server services
    ../../modules/services/plex
    ../../modules/services/zurg
    ../../modules/services/media-prefetch
    ../../modules/services/tailscale
    ../../modules/services/openclaw

    # Shell
    ../../modules/programs/shell/bash.nix
  ];

  # Headless overrides - disable desktop-oriented services from common.nix
  services.xserver.enable = lib.mkForce false;
  services.pipewire.enable = lib.mkForce false;
  services.pulseaudio.enable = lib.mkForce false;
  services.blueman.enable = lib.mkForce false;
  hardware.bluetooth.enable = lib.mkForce false;
  xdg.portal.enable = lib.mkForce false;
  xdg.portal.wlr.enable = lib.mkForce false;

  # Disable desktop/hardware-specific services not needed on a headless server
  services.libinput.enable = lib.mkForce false;
  services.asusd.enable = lib.mkForce false;
  services.kanata.enable = lib.mkForce false;
  services.gnome.gnome-keyring.enable = lib.mkForce false;
  services.flatpak.enable = lib.mkForce false;

  # Server-specific packages
  environment.systemPackages = with pkgs; [
    htop
    tmux
    neovim
    iotop
    ncdu
    tree
  ];

  # Enable SSH for remote management
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
    };
  };

  # Server-optimized home-manager config (no GUI applications)
  home-manager.users.${username} = {
    imports = [../../home/san-server.nix];
    _module.args.username = username;
  };
}
