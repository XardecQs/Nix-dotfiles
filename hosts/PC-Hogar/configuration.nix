{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  networking.hostName = "PC-Hogar";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.xardec = {
      imports = [
        ./../../modules/home
        inputs.dotfiles.homeManagerModules.default
      ];

      home.stateVersion = "26.05";

      home.packages = with pkgs; [
        gcc
        git
        gnumake
        imagemagick
        nodejs
        pciutils
        python3
        pywal16
        ripgrep
        rofi
        usbutils
      ];

      modulos.home.core.dotfiles = {
        nvim.enable = true;
        zsh.enable = true;
        tmux.enable = true;
        xdgUserDirs.enable = true;
      };
    };
  };

  modulos = {
    nixos = {
      core = {
        boot = {
          enable = true;
          kernelPackage = pkgs.linuxPackages;
          plymouth.enable = false;
          efiSysMountPoint = null;
        };
        general.enable = true;
        locate.enable = true;
        nix = {
          enable = true;
          cores = 1;
          flakePath = "/home/xardec/Proyectos/GitHub/nixos-config";
        };
        security.enable = true;
        users = {
          enable = true;
          primaryUser = "xardec";
        };
      };
      hardware = {
        intel-gpu.enable = true;
      };
      desktop = {
        pipewire.enable = true;
        systemPackages.enable = true;
      };
      services = {
        networking.enable = true;
        servidor = {
          enable = true;
          btrfsScrub = false;
        };
      };
    };

    compartidos = { };
  };
}
