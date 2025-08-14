{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/system/boot.nix
    ./modules/system/SysPakages.nix
    ./modules/system/users.nix
    ./modules/system/services.nix
  ];

  # Configuración básica del sistema
  system.stateVersion = "25.05";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";
  nixpkgs.config.allowUnfree = true;
  #system.autoUpgrade.enable = true;

  # Red
  networking = {
    hostName = "NeoReaper";
    networkmanager.enable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];

      };
    };
  };

  system.activationScripts.copy-dotfiles = {
    text = ''
      echo "Copiando configuraciones a dotfiles..."
      mkdir -p /home/xardec/.dotfiles/nixos
      cp -f /etc/nixos/{configuration.nix,hardware-configuration.nix} /home/xardec/.dotfiles/nixos/
      chown -R xardec:users /home/xardec/.dotfiles/nixos
    '';
    deps = [ ]; # No depende de otros scripts
  };
}
