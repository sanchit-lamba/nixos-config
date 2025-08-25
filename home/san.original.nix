{ lib, pkgs, config, inputs, ... }:

{
  home.username = "san";
  home.homeDirectory = lib.mkForce "/home/san";
  home.stateVersion = "25.05";
  
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme" = {
    source = inputs.firefox-gnome-theme;
    recursive = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-dark-gtk;
      name = "gruvbox-dark";
    };

    iconTheme = {
      package = pkgs.gruvbox-plus-icons;
      name = "Gruvbox-Plus-Dark";
    };
    
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # CLEANED UP: Single dconf.settings block with all settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "gruvbox-dark";
      icon-theme = "Gruvbox-Plus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      color-scheme = "prefer-dark";
      gtk-application-prefer-dark-theme = true;
    };
    
    # FIXED: Only one theme setting in wm/preferences
    "org/gnome/desktop/wm/preferences" = {
      theme = "gruvbox-dark";
    };
  };

  home.sessionVariables = {
    GTK_THEME = "gruvbox-dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
  };

  home.packages = with pkgs; [
    asusctl
    p3x-onenote
    newsflash
    gh
    git
    rclone
    fastfetch
    mpv
    kanata-with-cmd
    neovim
    ghostty
    obs-studio
    android-tools
    thunderbird
    ulauncher
    refine
    ocs-url
    lm_sensors
    gsettings-desktop-schemas
    glib
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.tridactyl-native ];
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
