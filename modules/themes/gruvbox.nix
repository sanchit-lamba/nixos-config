# Gruvbox theme configuration
{pkgs, ...}: {
  # System-wide theme packages
  environment.systemPackages = with pkgs; [
    gruvbox-dark-gtk
    gruvbox-plus-icons
    bibata-cursors
    gsettings-desktop-schemas
    gtk-engine-murrine
    gnome-themes-extra
  ];

  # Global GTK theme configuration  
  environment.sessionVariables = {
    GTK_THEME = "gruvbox-dark";
    XCURSOR_THEME = "Bibata-Modern-Classic";
  };
}