{
  description = "Configuración NixOS modular para NeoReaper y PC-Hogar";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    preservation.url = "github:nix-community/preservation";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    font-collection = {
      url = "github:XardecQs/font-collection";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    iconos = {
      url = "github:XardecQs/iconos";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    dotfiles = {
      url = "github:XardecQs/dotfiles";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    elyprismlauncher = {
      url = "github:ElyPrismLauncher/ElyPrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    gta-mo = {
      url = "github:XardecQs/samt-nix";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs =
    {
      self,
      nixpkgs-stable,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      unstableOverlay = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      mkHost =
        hostname: extraModules:
        nixpkgs-stable.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs self; };

          modules = [
            ./hosts/${hostname}/configuration.nix
            inputs.font-collection.nixosModules.default
            inputs.iconos.nixosModules.default
            inputs.preservation.nixosModules.default
            inputs.agenix.nixosModules.default
            home-manager.nixosModules.home-manager
            inputs.nix-index-database.nixosModules.default
            {
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = [ unstableOverlay ];
            }
          ]
          ++ extraModules;
        };

    in
    {
      formatter.x86_64-linux = nixpkgs-stable.legacyPackages.x86_64-linux.nixfmt;

      nixosConfigurations = {
        NeoReaper = mkHost "NeoReaper" [ ];
        PC-Hogar = mkHost "PC-Hogar" [ ];
      };
    };
}
