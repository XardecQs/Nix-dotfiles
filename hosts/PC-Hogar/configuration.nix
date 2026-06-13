{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  networking.hostName = "PC-Hogar";

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
        nix.enable = true;
        security.enable = true;
        users.enable = true;
      };
      hardware = {
        intel-gpu.enable = true;
        laptop.enable = false;
      };
      desktop = {
        gnome.enable = false;
        sway.enable = false;
        pipewire.enable = true;
        steam.enable = false;
        systemPackages.enable = true;
      };
      services = {
        networking.enable = true;
        servidor = {
          enable = true;
          btrfsScrub = false;
        };
        virtualisation.enable = false;
        waydroid.enable = false;
      };
    };
  };
}
