# Drive and filesystem support
{pkgs, ...}: {
  # Already included in common.nix, but can add specific drive configs here
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
}