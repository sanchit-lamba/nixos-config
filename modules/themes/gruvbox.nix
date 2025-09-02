# Gruvbox theme configuration
{pkgs, ...}: {
  # System-wide theme packages
  environment.systemPackages = with pkgs; [
    # GTK themes
    gruvbox-dark-gtk
    gruvbox-plus-icons
    bibata-cursors
    gsettings-desktop-schemas
    gtk-engine-murrine
    gnome-themes-extra
    
    # Qt theming packages
    qt5ct
    qt6ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qt5gtk2
    qt6Packages.qt6gtk2
    
    # Additional theming support
    papirus-icon-theme  # Fallback icons
    adwaita-qt
    adwaita-qt6
  ];

  # Global GTK theme configuration  
  environment.sessionVariables = {
    # GTK theming
    GTK_THEME = "gruvbox-dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
    
    # Qt theming
    QT_QPA_PLATFORMTHEME = "gtk2";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    
    # Additional theming variables
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
  };

  # Qt configuration
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };
}