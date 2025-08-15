{
  description = "NeoReaper NixOS configuration with home-manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
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
              };
          }
        ];
      };

      homeConfigurations."xardec" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        modules = [
          ./home.nix
          {
            _module.args.dotfilesDir = "/etc/nixos/modules/users/xardec/dotfiles";
          }
        ];
      };
    };
}
