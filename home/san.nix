{
  lib,
  pkgs,
  config,
  inputs,
  username ? "san",
  ...
}: {
  imports = [
    ./illogical-impulse.nix
  ];

  home.username = username;
  home.stateVersion = "25.05";

  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme" = {
    source = inputs.firefox-gnome-theme;
    recursive = true;
  };
  qt.enable = true;
  qt.platformTheme.name = lib.mkForce "qtct";
  qt.style.name = lib.mkForce "kvantum";
  # GNOME dconf settings
  home.packages = with pkgs; [
    glib
    fastfetch
    kdePackages.qt6ct 
    libsForQt5.qt5ct
    kdePackages.dolphin
    kdePackages.qtstyleplugin-kvantum # The engine
    libsForQt5.qtstyleplugin-kvantum
    gruvbox-kvantum                   # The actual Theme!
    kdePackages.qtsvg    # Qt6 SVG support
    libsForQt5.qt5.qtsvg # Qt5 SVG support
    adwaita-icon-theme   # Essential fallback icons
  ];

    gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };

    iconTheme = {
      # lib.hiPrio forces this package to "win" the conflict against Breeze
      package = lib.hiPrio pkgs.gruvbox-plus-icons;
      name = "Gruvbox-Plus-Dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
  };
  home.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    QT_STYLE_OVERRIDE = lib.mkForce "kvantum";  
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    GTK_USE_PORTAL = "1";
  };

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [pkgs.tridactyl-native];
    profiles.default = {
      name = "default";
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.drawInTitlebar" = true;
        "svg.context-properties.content.enabled" = true;
      };
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
        @import "firefox-gnome-theme/theme/colors/dark.css";
      '';
    };
  };

  programs.home-manager.enable = true;
}
