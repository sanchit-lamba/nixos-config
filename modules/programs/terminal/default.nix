# Terminal applications
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ghostty
  ];
}
