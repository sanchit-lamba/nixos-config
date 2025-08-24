{ lib, pkgs, config, inputs, ... }:

{
  # Enable Hyprland and basic Wayland support
  programs.hyprland = {
    enable = true;
    # Set the default session
  };

  # Use SDDM as display manager instead of GDM
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    defaultSession = "hyprland";
  };

  # Disable GNOME desktop entirely
  services.xserver.desktopManager.gnome.enable = lib.mkForce false;
  services.xserver.displayManager.gdm.enable = lib.mkForce false;

  # Essential Hyprland ecosystem packages
  environment.systemPackages = with pkgs; [
    # Window manager essentials
    waybar
    rofi-wayland
    swaync # notification daemon
    hyprpaper # wallpaper manager
    hyprlock # screen locker
    hypridle # idle management
    hyprpicker # color picker
    
    # Wayland utilities
    wl-clipboard
    cliphist
    grimblast # screenshot tool
    swappy # screenshot editing
    wf-recorder # screen recording
    
    # System utilities
    brightnessctl
    networkmanagerapplet
    pamixer
    pavucontrol
    playerctl
    
    # Authentication
    polkit-kde-agent
    
    # File managers and utilities
    nautilus # Keep nautilus as it works well with Wayland
    file-roller # Archive manager
    
    # Additional useful tools
    grim # screenshot backend
    slurp # area selection for screenshots
    
    # Keep existing useful packages
    wayland-utils
  ];

  # Configure polkit
  security.polkit.enable = true;

  # XDG portal for Hyprland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = ["gtk" "wlr"];
  };

  # Enable necessary services  
  services = {
    greetd = {
      enable = false; # We're using SDDM instead
    };
  };

  # Fonts for the UI
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    font-awesome
    (nerdfonts.override { fonts = [ "FiraCode" "Meslo" ]; })
  ];

  # Home-manager configuration for Hyprland
  home-manager.sharedModules = [
    ({ config, lib, pkgs, ... }: {
      # Hyprland configuration
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = true;
        settings = {
          # Basic settings adapted from reference config
          "$mainMod" = "SUPER";
          "$term" = "${lib.getExe pkgs.ghostty}"; # Use existing terminal
          "$fileManager" = "nautilus";
          "$browser" = "firefox";

          # Monitor configuration - using auto detection for now
          monitor = [
            ",preferred,auto,1"
          ];

          # Environment variables for Wayland
          env = [
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "GDK_BACKEND,wayland,x11,*"
            "NIXOS_OZONE_WL,1"
            "ELECTRON_OZONE_PLATFORM_HINT,auto"
            "MOZ_ENABLE_WAYLAND,1"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
          ];

          # Auto-start applications
          exec-once = [
            "waybar"
            "swaync"
            "nm-applet --indicator"
            "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type text --watch cliphist store"
            "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --type image --watch cliphist store"
            "polkit-kde-agent"
            "hyprpaper" # wallpaper daemon
          ];

          # Input configuration
          input = {
            kb_layout = "us";
            repeat_delay = 300;
            repeat_rate = 30;
            follow_mouse = 1;
            touchpad.natural_scroll = false;
            sensitivity = 0;
          };

          # General appearance
          general = {
            gaps_in = 4;
            gaps_out = 9;
            border_size = 2;
            "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
            "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
            layout = "dwindle";
          };

          # Decorations
          decoration = {
            rounding = 10;
            shadow.enabled = false;
            blur = {
              enabled = true;
              size = 6;
              passes = 2;
            };
          };

          # Animations
          animations = {
            enabled = true;
            animation = [
              "windows, 1, 3, default, popin 60%"
              "border, 1, 10, default"
              "fade, 1, 2.5, default"
              "workspaces, 1, 3.5, default, slide"
            ];
          };

          # Basic keybindings
          bind = [
            # Window management
            "$mainMod, Q, killactive"
            "$mainMod, W, togglefloating"
            "$mainMod, F, fullscreen"
            "$mainMod, P, pseudo" # dwindle
            "$mainMod, J, togglesplit" # dwindle

            # Applications
            "$mainMod, Return, exec, $term"
            "$mainMod, E, exec, $fileManager"
            "$mainMod, Space, exec, rofi -show drun"
            "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
            
            # System
            "$mainMod SHIFT, Q, exec, swaync-client -t -sw" # toggle notification center
            "$mainMod, L, exec, loginctl lock-session" # lock screen (if hyprlock is installed)

            # Workspaces
            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"

            # Move windows to workspaces
            "$mainMod SHIFT, 1, movetoworkspace, 1"
            "$mainMod SHIFT, 2, movetoworkspace, 2"
            "$mainMod SHIFT, 3, movetoworkspace, 3"
            "$mainMod SHIFT, 4, movetoworkspace, 4"
            "$mainMod SHIFT, 5, movetoworkspace, 5"
            "$mainMod SHIFT, 6, movetoworkspace, 6"
            "$mainMod SHIFT, 7, movetoworkspace, 7"
            "$mainMod SHIFT, 8, movetoworkspace, 8"
            "$mainMod SHIFT, 9, movetoworkspace, 9"
            "$mainMod SHIFT, 0, movetoworkspace, 10"

            # Focus movement
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
            
            # Move windows
            "$mainMod SHIFT, left, movewindow, l"
            "$mainMod SHIFT, right, movewindow, r"
            "$mainMod SHIFT, up, movewindow, u"
            "$mainMod SHIFT, down, movewindow, d"
            
            # Switch workspaces with scroll
            "$mainMod, mouse_down, workspace, e+1"
            "$mainMod, mouse_up, workspace, e-1"
          ];

          # Volume and brightness keys
          binde = [
            ",XF86MonBrightnessDown, exec, brightnessctl set 2%-"
            ",XF86MonBrightnessUp, exec, brightnessctl set +2%"
            ",XF86AudioLowerVolume, exec, pamixer -d 2"
            ",XF86AudioRaiseVolume, exec, pamixer -i 2"
            ",XF86AudioMute, exec, pamixer -t"
          ];

          # Window rules
          windowrule = [
            "float, ^(pavucontrol)$"
            "float, ^(nm-connection-editor)$"
            "float, ^(thunar)$"
            "float, ^(file-roller)$"
            "float, ^(ark)$"
            "float, ^(nautilus)$"
            "center, ^(pavucontrol)$"
            
            # Opacity rules for transparency
            "opacity 0.9 0.9, ^(ghostty)$"
            "opacity 0.9 0.9, ^(code)$"
            "opacity 0.9 0.9, ^(vscode)$"
            "opacity 1.0 1.0, ^(firefox)$"
            "opacity 1.0 1.0, ^(vivaldi)$"
          ];

          # Mouse bindings
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };
      };

      # Waybar configuration
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            modules-left = [ "hyprland/workspaces" ];
            modules-center = [ "clock" ];
            modules-right = [ "pulseaudio" "network" "battery" "tray" ];

            "hyprland/workspaces" = {
              format = "{icon}";
              format-icons = {
                "1" = "󰲠";
                "2" = "󰲢";
                "3" = "󰲤";
                "4" = "󰲦";
                "5" = "󰲨";
                "6" = "󰲪";
                "7" = "󰲬";
                "8" = "󰲮";
                "9" = "󰲰";
                "10" = "󰿬";
              };
            };

            clock = {
              format = "{:%H:%M}";
              tooltip-format = "{:%Y-%m-%d | %H:%M:%S}";
            };

            pulseaudio = {
              format = "{volume}% {icon}";
              format-bluetooth = "{volume}% {icon}";
              format-muted = "";
              format-icons = {
                headphone = "";
                hands-free = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = ["" ""];
              };
              on-click = "pavucontrol";
            };

            network = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
              format-disconnected = "Disconnected ⚠";
              tooltip-format = "{ifname}: {ipaddr}";
            };

            battery = {
              bat = "BAT0";
              states = {
                good = 95;
                warning = 30;
                critical = 15;
              };
              format = "{capacity}% {icon}";
              format-icons = ["" "" "" "" ""];
            };

            tray = {
              icon-size = 21;
              spacing = 10;
            };
          };
        };

        style = ''
          * {
            font-family: "Fira Code Nerd Font";
            font-size: 14px;
            border: none;
            border-radius: 0;
            min-height: 0;
          }

          window#waybar {
            background: rgba(30, 30, 46, 0.8);
            color: #cdd6f4;
          }

          #workspaces button {
            padding: 0 8px;
            background: transparent;
            color: #7f849c;
            border-bottom: 2px solid transparent;
          }

          #workspaces button.active {
            color: #cba6f7;
            border-bottom: 2px solid #cba6f7;
          }

          #clock, #pulseaudio, #network, #battery, #tray {
            padding: 0 10px;
            margin: 0 5px;
            background: rgba(49, 50, 68, 0.8);
            border-radius: 10px;
          }
        '';
      };

      # SwayNC (notification daemon)
      services.swaync.enable = true;

      # Rofi configuration  
      programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        theme = "gruvbox-dark";
      };

      # Hyprpaper configuration for wallpaper
      services.hyprpaper = {
        enable = true;
        settings = {
          preload = [
            # You can set a wallpaper path here or use a solid color
            # "~/Pictures/wallpaper.jpg"
          ];
          wallpaper = [
            # Example: ",~/Pictures/wallpaper.jpg"
            # For now, Hyprland will use a default background
          ];
        };
      };
    })
  ];
}