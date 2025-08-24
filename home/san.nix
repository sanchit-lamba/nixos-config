{ lib, pkgs, config, inputs, ... }: # Added 'inputs' to the function arguments
{
  home.username = "san";
  home.homeDirectory = lib.mkForce "/home/san";

  home.stateVersion = "25.05"; # Ensure this matches your NixOS/Home Manager version
  
  gtk = {
    enable = true;
    theme = {
      # CHANGED: Using gruvbox-dark-gtk package instead of arc-theme
      package = pkgs.gruvbox-dark-gtk;
      # FIXED: Correct theme name is lowercase "gruvbox-dark" (from debug script)
      name = "gruvbox-dark";
    };

    iconTheme = {
      # This package provides matching icons
      package = pkgs.gruvbox-plus-icons;
      name = "Gruvbox-Plus-Dark";
    };
    
    cursorTheme = {
      # A popular cursor theme that fits the aesthetic
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };

    # ADDED: GTK3 configuration for dark theme preference
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    # ADDED: GTK4 configuration for dark theme preference
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  # GTK and Qt theming settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # Keep GTK theme settings for compatibility with GTK applications
      gtk-theme = "gruvbox-dark";
      icon-theme = "Gruvbox-Plus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      # Modern color scheme preference for GTK4+ applications
      color-scheme = "prefer-dark";
    };
  };

  # Set environment variables for consistent theming across all applications
  home.sessionVariables = {
    GTK_THEME = "gruvbox-dark";
    # For Qt applications to use dark theme
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
    # ADDED: Packages to ensure proper GTK theming support
    gsettings-desktop-schemas  # Provides schemas for GTK settings
    glib  # Provides gsettings command
  ];
  
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [
    	pkgs.tridactyl-native 
	];
    profiles.default = {
      name = "default";
      settings = {
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.tabs.drawInTitlebar" = true;
        "svg.context-properties.content.enabled" = true;
      };
      # Removed GNOME-specific theme
    };
  };
  programs.home-manager.enable = true;
}
