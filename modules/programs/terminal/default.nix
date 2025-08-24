# Terminal applications
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Terminals
    gnome-terminal  # Default GNOME terminal
    warp-terminal   # Modern terminal
    ghostty         # GPU-accelerated terminal
  ];
}