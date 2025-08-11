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
      
      # Entorno de escritorio
      gnome-tweaks       # Fixed package name
      gnome-extension-manager
      gnomeExtensions.gsconnect
      gnomeExtensions.blur-my-shell
      gnomeExtensions.gtk4-desktop-icons-ng-ding
      gnomeExtensions.dash-to-dock
      gnomeExtensions.user-themes
      dconf-editor
      kitty
      github-desktop
      adw-gtk3

      # Multimedia y diseño
      krita
      inkscape
      firefox
      
      # Temas
      jetbrains-mono           # Simplified package name
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
      onlyoffice-desktopeditors
    ];

    file = {
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";
      ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/kitty";
      ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/fastfetch";
      #".config/Code".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/Code";
      ".vscode".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/vscode";
      ".icons".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/icons";
      ".fonts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fonts";
      ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh";
      ".config/user-dirs.dirs".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/user-dirs.dirs";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --color=always $realpath'
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
      bindkey "^[[3~" delete-char
      zstyle ':fzf-tab:*' fzf-flags --height=40% --border
      [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh
    '';
     
    shellAliases = {
      lla = "lsd -la";
      ll = "lsd -l";
      ls = "lsd";
      q = "exit";
      c = "exit";
      ".." = "cd ..";
      "..." = "cd ../..";
      cf = "clear && fastfetch";
      snvim = "sudo nvim";
      ordenar = "~/Proyectos/Scripts/sh/ordenar.sh";
      desordenar = "~/Proyectos/Scripts/sh/desordenar.sh";
    };
    
    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions.outPath;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting.outPath;
      }
    ];
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

  fonts.fontconfig.enable = true;

  services.gnome-keyring.enable = true;

  dconf.settings = {
    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-blue-dark";
    };
    
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "show-desktop-button@amivaleo"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "gsconnect@andyholmes.github.io"
        "blur-my-shell@aunetx"
        "gtk4-ding@smedius.gitlab.com"
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