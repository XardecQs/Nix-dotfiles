# Flake configuration for NeoReaper system and xardec user
{
  description = "NeoReaper NixOS configuration with home-manager and Zen Browser";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      zen-browser,
      ...
    }:
    {
      # System configuration for NixOS
      nixosConfigurations.NeoReaper = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.xardec =
              { config, ... }:
              {
                imports = [ ./home.nix ];
                _module.args.dotfilesDir = "/etc/nixos/modules/users/xardec/dotfiles";
                _module.args.zen-browser = zen-browser;
              };
          }
        ];
      };

      # Home-manager configuration for standalone user setup
      homeConfigurations."xardec" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home.nix
          {
            _module.args.dotfilesDir = "/etc/nixos/modules/users/xardec/dotfiles";
            _module.args.zen-browser = zen-browser;
          }
        ];
      };
    };
}
