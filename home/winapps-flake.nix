# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      winapps,
      ...
    }:
    {
      nixosConfigurations.hostname = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs system;
        };

        modules = [
          ./configuration.nix
          (
            {
              pkgs,
              system ? pkgs.system,
              ...
            }:
            {
              # set up binary cache (optional)
              nix.settings = {
                substituters = [ "https://winapps.cachix.org/" ];
                trusted-public-keys = [ "winapps.cachix.org-1:HI82jWrXZsQRar/PChgIx1unmuEsiQMQq+zt05CD36g=" ];
              };

              environment.systemPackages = [
                winapps.packages."${system}".winapps
                winapps.packages."${system}".winapps-launcher # optional
              ];
            }
          )
        ];
      };
    };
}
