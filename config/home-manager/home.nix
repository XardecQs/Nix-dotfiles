{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "25.05";
    username = "xardec";
    homeDirectory = "/home/xardec";

    packages = with pkgs; [
      # Herramientas CLI
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

      # Entorno de escritorio
      eiciel
      gnome-tweaks # Fixed package name
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

      dconf-editor
      kitty
      github-desktop
      adw-gtk3

      # Multimedia y diseño
      krita
      inkscape
      firefox

      # Temas
      nerd-fonts.jetbrains-mono
      papirus-icon-theme
      marble-shell-theme

      # Herramientas para desarrollo
      nodejs
      python3

      # Gestión Nix
      home-manager

      prismlauncher
      mcaselector

      epson-escpr2

      podman
      distrobox

      vscode
      github-desktop
      gthumb
      nixfmt-rfc-style

      wineWowPackages.stagingFull
      steam
      lutris

      #texliveFull
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
      freerdp

      realcugan-ncnn-vulkan
      realesrgan-ncnn-vulkan

      youtube-music
      spotify

      icoextract
      zapzap
      android-tools
      alsa-utils
    ];

    file = {
      ".config/nvim".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";
      ".config/kitty".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/kitty";
      ".config/fastfetch".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/fastfetch";
      ".vscode".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode";
      ".icons".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/icons";
      ".local/share/fonts".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fonts";
      ".config/zsh".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh";
      ".config/user-dirs.dirs".source = "${config.home.homeDirectory}/.dotfiles/config/user-dirs.dirs";
    };
  };

  programs.zsh = {
    enable = true;

    initContent = ''
      source ${config.home.homeDirectory}/.dotfiles/zshrc
    '';

    shellAliases = {
      lla = "lsd -la";
      la = "lsd -a";
      ll = "lsd -l";
      ls = "lsd";
      q = "exit";
      c = "clear";
      ".." = "cd ..";
      "..." = "cd ../..";
      cf = "clear && fastfetch";
      cff = "clear && fastfetch --config examples/13.jsonc";
      snvim = "sudo nvim";
      ordenar = "~/Proyectos/Scripts/sh/ordenar.sh";
      desordenar = "~/Proyectos/Scripts/sh/desordenar.sh";
      cp = "cp --reflink=auto";
      umatrix = "unimatrix -s 95 -f";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      syu = "yay -Syu";
      codepwd = ''code "$(pwd)"'';
      napwd = ''nautilus "$(pwd)" &> /dev/null & disown'';
      dots = "cd ~/.dotfiles && codepwd && q";
      dotsn = "cd ~/.dotfiles && nvim";
    };

    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Definitivo";
    };
    cursorTheme = {
      name = "MacOS-Tahoe-Cursor";
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  services.gnome-keyring.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface".show-battery-percentage = true;
    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-blue-dark";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };

    "org/gnome/shell" = {
      enabled-extensions = with pkgs.gnomeExtensions; [
        "MaximizeToEmptyWorkspace-extension@kovari.cc"
        "dash-to-dock@micxgx.gmail.com"
        "show-desktop-button@amivaleo"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "blur-my-shell@aunetx"
        "gtk4-ding@smedius.gitlab.com"
        "rounded-window-corners@fxgn"
        "clipboard-indicator@tudmotu.com"
        "fullscreen-hot-corner@sorrow.about.alice.pm.me"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Open Kitty";
      command = "kitty";
      binding = "<Super>q";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Open Nautilus";
      command = "nautilus";
      binding = "<Super>e";
    };

    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>c" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
    };
  };
}
