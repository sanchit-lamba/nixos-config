{
  description = "Sanchit's NixOS Configuration - Merged and Restructured";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Original inputs
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
    
    # Optional advanced inputs for future use
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nur.url = "github:nix-community/NUR";
    
    # Windows application support
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    
    # System settings
    settings = {
      # User configuration
      username = "san";
      hostname = "BlitzWing";
      
      # Desktop preferences  
      desktop = "gnome"; # gnome, hyprland (future)
      browser = "firefox";
      terminal = "gnome-terminal"; # Will be modular later
      editor = "vscode";
      
      # System configuration
      videoDriver = "amdgpu"; # Based on current hardware (AMD)
      locale = "en_IN";
      timezone = "Asia/Kolkata";
      kbdLayout = "us";
      kbdVariant = "";
      consoleKeymap = "us";
    };

    systems = [
      "x86_64-linux"
    ];
    
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    overlays = import ./overlays {inherit inputs settings;};
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    
    nixosConfigurations = {
      BlitzWing = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit self inputs outputs;} // settings;
        modules = [
          ./hosts/BlitzWing/configuration.nix
        ];
      };
    };
    
    # Keep standalone home-manager configuration
    homeConfigurations.san = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs;} // settings;
      modules = [
        ./home/san.nix
      ];
    };
  };
}