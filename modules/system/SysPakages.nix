{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    gdu

    zsh

    gcc
    binutils
    gnumake
    cmake

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
}
