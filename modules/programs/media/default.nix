# Media applications
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Video players
    mpv
    haruna
    
    # Streaming
    stremio
    obs-studio
    
    # Other media
    thunderbird
  ];
}