# System utilities
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Note-taking and productivity
    obsidian
    p3x-onenote
    newsflash
    
    # System monitoring
    hardinfo2
    lm_sensors
    
    # Wayland utilities
    wayland-utils
    wl-clipboard
    
    # Launchers and utilities
    ulauncher
    refine
    ocs-url
    
    # Terminal tools
    fastfetch
    rclone
    
    # Android tools
    android-tools
    
    # Terminal emulator
    ghostty
  ];
}
