# System utilities
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rclone
    mpv
    kanata-with-cmd
    fastfetch
    libreoffice
    android-tools
    obsidian
  ];
}
