# 💫 https://github.com/JaKooLit 💫 #
# Users configuration for BlitzWing

{ pkgs, username, ... }:

let
  inherit (import ./variables.nix) keyboardLayout;
in
{
  users.users.${username} = {
    isNormalUser = true;
    description = "Sanchit";
    group = "users";
    extraGroups = [ "adbusers" "uinput" "networkmanager" "wheel" "docker" "video" "audio" "input" ];
    packages = with pkgs; [
      # User-specific packages
    ];
    uid = 1000;
  };
  
  # Ensure the user is configured for auto-login with greetd
  users.defaultUserShell = pkgs.bash;
}