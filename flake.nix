# /etc/nixos/flake.nix
{
  description = "This flake is a patchwork made by github.com/sanchit-lamba";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # Or your desired nixpkgs branch
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensures HM uses the same nixpkgs
    };
    # Added firefox-gnome-theme as an input
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false; # Important: Treat it as a legacy source tree, not a flake itself
    };
    # Added JaKooLit's NixOS-Hyprland configuration
    jakoolit-hyprland = {
      url = "github:JaKooLit/NixOS-Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # QuickShell dependency
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, jakoolit-hyprland, quickshell, ... }@inputs: # @inputs captures all inputs
    let
      system = "x86_64-linux"; # Adjust if your system architecture is different
      host = "BlitzWing";
      username = "san";
    in
    {
      # This is what 'nixos-rebuild switch' will pick up by default
      # if your hostname is "nixos". If it's different, change "nixos" here
      # to match your system's hostname.
      nixosConfigurations.BlitzWing = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { 
          inherit inputs; 
          inherit system;
          inherit username;
          inherit host;
        }; # Makes all flake inputs available

        modules = [
          # Import the Home Manager NixOS module
          home-manager.nixosModules.home-manager

          # Import the host-specific configuration
          ./hosts/${host}/config.nix
	        # You could add other global modules here if necessary
	        ./home/wayland.nix
          # QuickShell module for Hyprland support
          ./modules/quickshell.nix

        ];
      };

      # Optional: For standalone `home-manager switch --flake .#san`
      homeConfigurations.san = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system}; # Note: config.nixpkgs.system is not available here, use system directly
        extraSpecialArgs = { inherit inputs; }; # Pass all flake inputs to home-manager modules
        modules = [ ./home/san.nix ./home/winapps-flake.nix ];
      };
    };
}
