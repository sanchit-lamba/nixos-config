{
  lib,
  pkgs,
  config,
  inputs,
  username ? "san",
  ...
}: {
  home.username = username;
  home.stateVersion = "25.05";

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

  home.sessionVariables = {
    GTK_THEME = "gruvbox-dark";
  };

  home.packages = with pkgs; [
    glib
  ];

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
    };
  };

  programs.home-manager.enable = true;
}
