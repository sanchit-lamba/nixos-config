# Terminal applications
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Terminals (system-wide)
    gnome-terminal  # Default GNOME terminal
    warp-terminal   # Modern terminal alternative
  ];
}