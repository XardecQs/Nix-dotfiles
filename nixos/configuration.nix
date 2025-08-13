{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Configuración básica del sistema
  system.stateVersion = "25.05";
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  console.keyMap = "la-latin1";
  #system.autoUpgrade.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_testing;
  # Bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Red
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Usuarios - Zsh como shell global
  users = {
    defaultUserShell = pkgs.zsh;

    users.root.shell = pkgs.zsh;

    users.xardec = {
      isNormalUser = true;
      description = "Xavier Del Piero";
      extraGroups = [
        "networkmanager"
        "wheel"
        "xardec"
      ];
    };
    groups = {
      libvirtd.members = [ "xardec" ];
      xardec = {
        name = "xardec";
        gid = 1000;
      };
    };
  };

  # Servicios esenciales
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      desktopManager.xterm.enable = false;
      xkb.layout = "latam";
      videoDrivers = [ "intel" ];
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Otros servicios
    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr ];
    };
    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "daily";
      prunePaths = [
        "/tmp"
        "/var/tmp"
        "/nix/store"
        "/home/.cache"
      ];
    };
    openssh.enable = false;
    pulseaudio.enable = false;
    spice-vdagentd.enable = true;
  };

  security.rtkit.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

  # Paquetes de sistema esenciales
  environment.systemPackages = with pkgs; [
    # Herramientas de administración
    fzf
    zoxide
    lsd
    git
    wget
    neovim
    btrfs-progs
    gparted
    openssh
    fastfetch
    kitty
    firefox
    cups
    epson-escpr2
    tree

    # Zsh (sin plugins)
    zsh

    # Compilación básica
    gcc
    binutils
    gnumake
    cmake
    home-manager

    gamemode

    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    freerdp
  ];

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Configuración global de Zsh (sin personalizaciones)
  programs.zsh.enable = true;

  system.activationScripts.copy-dotfiles = {
    text = ''
      echo "Copiando configuraciones a dotfiles..."
      mkdir -p /home/xardec/.dotfiles/nixos
      cp -f /etc/nixos/{configuration.nix,hardware-configuration.nix} /home/xardec/.dotfiles/nixos/
      chown -R xardec:users /home/xardec/.dotfiles/nixos
    '';
    deps = [ ]; # No depende de otros scripts
  };

  nixpkgs.config.allowUnfree = true;
}
