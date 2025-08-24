# Browser configuration
{pkgs, ...}: {
  programs.firefox.enable = true;
  
  environment.systemPackages = with pkgs; [
    firefox
    vivaldi
    vivaldi-ffmpeg-codecs
  ];
}