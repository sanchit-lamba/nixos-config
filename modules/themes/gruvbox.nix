{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gruvbox-dark-gtk
    gruvbox-gtk-theme
    gruvbox-plus-icons
    bibata-cursors
    gsettings-desktop-schemas
    gnome-themes-extra
  ];
}
