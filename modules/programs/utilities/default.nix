# System utilities
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    rclone
    mpv
    kanata-with-cmd
    fastfetch
    android-tools
  ];
}
