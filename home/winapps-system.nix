# System-level winapps configuration module
{ lib, pkgs, config, inputs, ... }:

{
  # System-level winapps configuration
  # This should be imported in the nixosConfiguration modules
  
  # Set up binary cache for winapps (optional but recommended for faster builds)
  nix.settings = {
    substituters = [ "https://winapps.cachix.org/" ];
    trusted-public-keys = [ "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g=" ];
  };

  # Add winapps packages to system packages
  environment.systemPackages = with inputs.winapps.packages.${pkgs.system}; [
    winapps
    winapps-launcher # optional launcher
  ];
}