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

    # Theme
    ../../modules/themes/gruvbox.nix

    # Programs - keeping current applications
    ../../modules/programs/browsers
    ../../modules/programs/development
    ../../modules/programs/media
    ../../modules/programs/utilities
    ../../modules/programs/terminal
    ../../modules/programs/shell/bash.nix
    # ../../modules/programs/virtualization/winapps.nix  # Uncomment if needed
  ];

  # Additional packages specific to this system
  environment.systemPackages = with pkgs; [
    asusctl
  ];

  home-manager.users.${username} = {
    imports = [../../home/san.nix];
    _module.args.username = username;
  };
}
