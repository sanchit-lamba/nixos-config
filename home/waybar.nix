{...}: {
  xdg.configFile."waybar/config".text = ''
    {
      "layer": "top",
      "position": "bottom",
      "height": 32,
      "spacing": 8,
      "modules-left": ["custom/launcher", "wlr/taskbar"],
      "modules-center": ["clock"],
      "modules-right": ["pulseaudio", "network", "cpu", "memory", "battery", "tray"],
      "custom/launcher": {
        "format": "λ",
        "tooltip": false,
        "on-click": "fuzzel"
      },
      "wlr/taskbar": {
        "icon-size": 16,
        "spacing": 6,
        "tooltip-format": "{title}",
        "on-click": "activate"
      },
      "clock": {
        "format": "τ {:%H:%M}",
        "format-alt": "τ {:%Y-%m-%d %H:%M}"
      },
      "cpu": {
        "format": "ψ {usage}%"
      },
      "memory": {
        "format": "ω {percentage}%"
      },
      "battery": {
        "states": {
          "warning": 30,
          "critical": 15
        },
        "format": "β {capacity}%",
        "format-charging": "β⁺ {capacity}%",
        "format-plugged": "β∞ {capacity}%"
      },
      "network": {
        "format-wifi": "φ {essid}",
        "format-ethernet": "η {ipaddr}",
        "format-disconnected": "χ"
      },
      "pulseaudio": {
        "format": "α {volume}%",
        "format-muted": "α∅"
      },
      "tray": {
        "spacing": 10
      }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrains Mono Nerd Font", monospace;
      font-size: 13px;
      min-height: 0;
    }

    window#waybar {
      background-color: #1d2021;
      color: #ebdbb2;
    }

    #custom-launcher,
    #taskbar,
    #clock,
    #cpu,
    #memory,
    #battery,
    #network,
    #pulseaudio,
    #tray {
      padding: 0 10px;
      background-color: #282828;
      color: #ebdbb2;
      margin: 4px 0;
    }

    #custom-launcher {
      background-color: #458588;
      font-size: 16px;
      font-weight: 700;
      padding: 0 12px;
    }

    #custom-launcher:hover {
      background-color: #83a598;
      color: #1d2021;
    }

    #pulseaudio.muted {
      background-color: #3c3836;
      color: #a89984;
    }

    #battery.warning:not(.charging) {
      background-color: #d79921;
      color: #1d2021;
    }

    #battery.critical:not(.charging) {
      background-color: #cc241d;
      color: #fbf1c7;
    }

    #battery.charging {
      background-color: #98971a;
      color: #1d2021;
    }
  '';
}
