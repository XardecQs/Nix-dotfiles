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
    cups
    epson-escpr2
    tree
    gdu
    yazi
    syncthing

    nautilus-python
    nautilus-open-any-terminal

    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-fzf-tab

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

  programs = {
    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };
}
