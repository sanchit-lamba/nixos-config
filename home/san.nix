{ lib, pkgs, config, inputs, username ? "san", ... }:

{
  home.username = username;
  home.stateVersion = "25.05";
  
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme" = {
    source = inputs.firefox-gnome-theme;
    recursive = true;
  };

  # Create GTK configuration files to ensure proper theming
  home.file.".gtkrc-2.0".text = ''
    gtk-theme-name="gruvbox-dark"
    gtk-icon-theme-name="Gruvbox-Plus-Dark"
    gtk-cursor-theme-name="Bibata-Modern-Classic"
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark-theme=1
  '';

  home.file.".config/gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=gruvbox-dark
    gtk-icon-theme-name=Gruvbox-Plus-Dark
    gtk-cursor-theme-name=Bibata-Modern-Classic
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark-theme=1
  '';

  home.file.".config/gtk-4.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=gruvbox-dark
    gtk-icon-theme-name=Gruvbox-Plus-Dark
    gtk-cursor-theme-name=Bibata-Modern-Classic
    gtk-cursor-theme-size=24
    gtk-application-prefer-dark-theme=1
  '';

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

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=1
      gtk-theme-name="gruvbox-dark"
      gtk-icon-theme-name="Gruvbox-Plus-Dark"
      gtk-cursor-theme-name="Bibata-Modern-Classic"
      gtk-cursor-theme-size=24
    '';

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-theme-name=gruvbox-dark
        gtk-icon-theme-name=Gruvbox-Plus-Dark
        gtk-cursor-theme-name=Bibata-Modern-Classic
        gtk-cursor-theme-size=24
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
        gtk-theme-name=gruvbox-dark
        gtk-icon-theme-name=Gruvbox-Plus-Dark
        gtk-cursor-theme-name=Bibata-Modern-Classic
        gtk-cursor-theme-size=24
      '';
    };
  };

  # GNOME dconf settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "gruvbox-dark";
      icon-theme = "Gruvbox-Plus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      color-scheme = "prefer-dark";
      gtk-application-prefer-dark-theme = true;
      cursor-size = 24;
    };
    
    "org/gnome/desktop/wm/preferences" = {
      theme = "gruvbox-dark";
    };

    # GNOME Shell theming
    "org/gnome/shell" = {
      disable-user-extensions = false;
    };

    # File manager (Nautilus) theming
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "list-view";
      search-filter-time-type = "last_modified";
      show-hidden-files = false;
    };

    # GNOME Terminal theming (if using gnome-terminal)
    "org/gnome/terminal/legacy" = {
      theme-variant = "dark";
    };

    # Text editor theming
    "org/gnome/TextEditor" = {
      style-scheme = "Adwaita-dark";
    };

    # Settings app theming
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = false;
    };

    # Force dark theme for all applications
    "org/gnome/desktop/a11y" = {
      always-show-text-caret = false;
    };
  };

  home.sessionVariables = {
    # GTK theming
    GTK_THEME = "gruvbox-dark";
    GTK2_RC_FILES = "$HOME/.gtkrc-2.0";
    
    # Qt theming
    QT_QPA_PLATFORMTHEME = "gtk2";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    
    # Cursor theming
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    
    # Force applications to use dark theme
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    
    # Wayland-specific variables
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    
    # Additional XDG variables for theming
    XDG_CURRENT_DESKTOP = "GNOME";
    XDG_SESSION_DESKTOP = "gnome";
  };

  home.packages = with pkgs; [
    # Essential packages for theming
    glib
    gsettings-desktop-schemas
    dconf-editor  # For debugging theme issues
    
    # Additional GTK/Qt tools
    lxappearance   # GTK theme switcher (useful for debugging)
    qt5ct          # Qt5 configuration tool
    qt6ct          # Qt6 configuration tool
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
