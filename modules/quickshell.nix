# QuickShell module for Hyprland support
{ lib, pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Install QuickShell if available
    (if inputs ? quickshell && inputs.quickshell ? packages && inputs.quickshell.packages ? ${pkgs.system} && inputs.quickshell.packages.${pkgs.system} ? quickshell
     then inputs.quickshell.packages.${pkgs.system}.quickshell
     else pkgs.hello) # fallback placeholder
  ];

  # Enable required services for QuickShell
  services.dbus.enable = true;
  programs.dconf.enable = true;
  
  # Ensure we have proper graphics support
  hardware.graphics.enable = true;
}