{pkgs, ...}: {
  services.xserver = {
    enable = true;
  };

  # Enable KDE Plasma
  services.desktopManager.plasma6.enable = true;

  # Enable SDDM display manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Include full KDE package set
  environment.plasma6.excludePackages = [];

  environment.systemPackages = with pkgs; [
    # KDE Applications - Full set
    kdePackages.ark
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.gwenview
    kdePackages.kate
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kcolorchooser
    kdePackages.kdeconnect-kde
    kdePackages.kdegraphics-thumbnailers
    kdePackages.kdf
    kdePackages.kdialog
    kdePackages.keditbookmarks
    kdePackages.kfind
    kdePackages.khelpcenter
    kdePackages.kio-extras
    kdePackages.kmag
    kdePackages.kmousetool
    kdePackages.kmouth
    kdePackages.konsole
    kdePackages.krdc
    kdePackages.kruler
    kdePackages.ksystemlog
    kdePackages.kwalletmanager
    kdePackages.kweather
    kdePackages.okular
    kdePackages.partitionmanager
    kdePackages.plasma-systemmonitor
    kdePackages.spectacle
    kdePackages.skanpage
    kdePackages.yakuake
    kdePackages.filelight
    kdePackages.elisa
    kdePackages.haruna
    kdePackages.kolourpaint
    kdePackages.kleopatra
    kdePackages.kcron
    kdePackages.isoimagewriter

    # KDE System components
    kdePackages.kde-gtk-config
    kdePackages.breeze-gtk
    kdePackages.plasma-browser-integration
    kdePackages.plasma-pa
    kdePackages.plasma-nm
    kdePackages.plasma-vault
    kdePackages.plasma-disks
    kdePackages.bluedevil
    kdePackages.kgamma
    kdePackages.kscreen
    kdePackages.ksshaskpass
    kdePackages.kwallet-pam
    kdePackages.kwayland-integration
    kdePackages.polkit-kde-agent-1
    kdePackages.powerdevil
    kdePackages.sddm-kcm
  ];

  # XDG portal for KDE
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
  };
}
