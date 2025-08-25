# System utilities
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # System monitoring and hardware tools
    hardinfo2
    lm_sensors
    
    # Wayland utilities (system-level)
    wayland-utils
    wl-clipboard
    
    # Terminal tools
    fastfetch
  ];
}
