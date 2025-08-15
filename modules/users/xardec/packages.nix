{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # CLI tools
    bat
    btop
    eza
    fastfetch
    fzf
    lsd
    zoxide
    ripgrep
    fd
    unzip
    wl-clipboard
    unimatrix
    tmux
    dpkg
    tree
    zsh-powerlevel10k

    # Desktop environment tools
    eiciel
    gnome-tweaks
    gnome-extension-manager
    gnomeExtensions.gsconnect
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.rounded-window-corners-reborn
    gnomeExtensions.maximize-to-empty-workspace-2025
    gnomeExtensions.fullscreen-hot-corner
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.caffeine
    gnomeExtensions.tray-icons-reloaded

    dconf-editor
    kitty
    github-desktop
    adw-gtk3
    switcheroo

    # Multimedia and design
    krita
    inkscape
    firefox

    # Themes
    nerd-fonts.jetbrains-mono
    papirus-icon-theme
    marble-shell-theme

    # Development tools
    nodejs
    python3

    # Nix management
    home-manager

    # Gaming
    prismlauncher
    mcaselector

    # Printer drivers
    epson-escpr2

    # Containerization
    podman
    distrobox

    # Development and utilities
    vscode
    gthumb
    nixfmt-rfc-style

    # Gaming and emulation
    wineWowPackages.stagingFull
    steam
    lutris
    mangohud
    protonup

    # Virtualization
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-virtio
    win-spice
    freerdp

    # AI and image processing
    realcugan-ncnn-vulkan
    realesrgan-ncnn-vulkan

    # Media
    youtube-music
    spotify

    # Miscellaneous
    icoextract
    zapzap
    android-tools
    alsa-utils
  ];
}
