{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.driftwm.nixosModules.default];

  programs.driftwm.enable = true;

  services.displayManager = {
    sddm.enable = true;
    defaultSession = "driftwm";
  };

  environment.systemPackages = with pkgs; [
    # Qt/KDE-first basic desktop utilities
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.kio-extras
    kdePackages.ark
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.kdeconnect-kde
    kdePackages.polkit-kde-agent-1
  ];

  xdg.portal.extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
}