# Illogical Impulse - end-4's Hyprland dotfiles with QuickShell
# This module enables the illogical-impulse configuration from soymou/illogical-flake
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  programs.illogical-impulse = {
    enable = true;

    # Customize shell tools (all enabled by default)
    dotfiles = {
      fish.enable = true;     # Fish shell with custom config
      kitty.enable = true;    # Kitty terminal emulator
      starship.enable = true; # Starship prompt
    };
  };
}
