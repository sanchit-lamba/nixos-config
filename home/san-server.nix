{
  lib,
  pkgs,
  config,
  inputs,
  username ? "san",
  ...
}: {
  home.username = username;
  home.stateVersion = "25.05";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    htop
    tmux
  ];

  programs.home-manager.enable = true;
}
