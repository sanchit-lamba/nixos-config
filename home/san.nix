{ lib, pkgs, config, inputs, username ? "san", ... }:

{
  home.username = username;
  home.stateVersion = "25.05";
  
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme" = {
    source = inputs.firefox-gnome-theme;
    recursive = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gruvbox-gtk-theme;
      name = "Gruvbox-Dark-BL-LB";
    };

    iconTheme = {
      package = pkgs.gruvbox-plus-icons;
      name = "Gruvbox-Plus-Dark";
    };
    
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    };


  # GNOME dconf settings
   dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Gruvbox-Dark-BL-LB"; # Change this to the new theme name
      icon-theme = "Gruvbox-Plus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      color-scheme = "prefer-dark";
      gtk-application-prefer-dark-theme = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      theme = "Gruvbox-Dark-BL-LB"; # Also update this for consistency
    };
  };


  home.sessionVariables = {
    GTK_THEME = "gruvbox-dark";
    QT_STYLE_OVERRIDE = "gnome";
  };

  home.packages = with pkgs; [
  glib
  qgnomeplatform ];

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
