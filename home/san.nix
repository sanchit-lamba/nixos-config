{ lib, pkgs, config, inputs, ... }: # Added 'inputs' to the function arguments
{
  home.username = "san";
  home.homeDirectory = lib.mkForce "/home/san";

  home.stateVersion = "25.05"; # Ensure this matches your NixOS/Home Manager version
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme" = {
    source = inputs.firefox-gnome-theme;
    recursive = true; # Important: copies/links the entire directory content
  };
  
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

  # This helps ensure GTK4 applications respect the theme settings
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      # FIXED: Using correct lowercase theme name "gruvbox-dark"
      gtk-theme = "gruvbox-dark";
      icon-theme = "Gruvbox-Plus-Dark";
      cursor-theme = "Bibata-Modern-Classic";
      # ADDED: Modern color scheme preference for GTK4+ applications
      color-scheme = "prefer-dark";
    };
  };

  # ADDED: Set environment variables for consistent theming across all applications
  home.sessionVariables = {
    # FIXED: Using correct lowercase theme name "gruvbox-dark"
    GTK_THEME = "gruvbox-dark";
    # ADDED: For Qt applications to use dark theme
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
    
    # Hyprland-specific packages
    waybar
    hyprlock
    hypridle
    hyprpicker
    wlogout
    swaynotificationcenter
    grim
    slurp
    swappy
    cliphist
    wl-clipboard
    rofi-wayland
    kitty
    wofi
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
      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
        @import "firefox-gnome-theme/theme/colors/dark.css"; /* Or your preferred color variant */
      '';
      # If the theme also provides userContent.css:
      # userContent = ''
      #   @import "firefox-gnome-theme/userContent.css";
      # '';
    };
  };

  # Hyprland configuration with home-manager  
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = {
      # Basic configuration - can be expanded later
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };
      
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };
      
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
        };
        sensitivity = 0;
      };
      
      # Basic keybinds
      bind = [
        "SUPER, T, exec, kitty"
        "SUPER, Q, killactive"
        "SUPER, M, exit"
        "SUPER, E, exec, thunar"
        "SUPER, V, togglefloating"
        "SUPER, R, exec, rofi -show drun"
        "SUPER, P, pseudo"
        "SUPER, J, togglesplit"
        
        # Move focus with SUPER + arrow keys
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        
        # Switch workspaces with SUPER + [0-9]
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"
        
        # Move active window to a workspace with SUPER + SHIFT + [0-9]
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
      ];
      
      # Mouse binds
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
  
  programs.home-manager.enable = true;
}
