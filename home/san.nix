{ lib, pkgs, config, inputs, ... }: # Added 'inputs' to the function arguments

{
  home.username = "san";
  home.homeDirectory = lib.mkForce "/home/san";

  home.stateVersion = "25.05"; # Ensure this matches your NixOS/Home Manager version
  home.file.".mozilla/firefox/default/chrome/firefox-gnome-theme" = {
    source = inputs.firefox-gnome-theme;
    recursive = true; # Important: copies/links the entire directory content
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
  programs.home-manager.enable = true;
}
