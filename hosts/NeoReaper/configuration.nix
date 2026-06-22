{ pkgs, inputs, ... }:
{
  networking.hostName = "NeoReaper";

  imports = [
    ./hardware-configuration.nix
    ./../../modules/nixos
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };

    users.xardec = {
      imports = [
        ./../../modules/home
        inputs.dotfiles.homeManagerModules.default
        inputs.spicetify-nix.homeManagerModules.default
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];
      home.stateVersion = "26.05";

      modulos.home = {
        core = {
          dotfiles = {
            localPath = "/home/xardec/Proyectos/GitHub/dotfiles";
            nvim.enable = true;
            kitty.enable = true;
            fastfetch.enable = true;
            zsh.enable = false;
            tmux.enable = true;
            alacritty.enable = true;
            waybar.enable = true;
            wal.enable = true;
            wlogout.enable = true;
            albert.enable = true;
            code.enable = true;
            xdgUserDirs.enable = true;
          };
          packages.enable = true;
          zsh.enable = true;
        };
        desktop = {
          #spicetify.enable = true;
          #obs.enable = true;
        };
        apps = {
          syncthing.enable = true;
          #java.enable = true;
          #lan-mouse.enable = true;
          retroarch.enable = true;
        };
      };
    };
  };

  modulos = {
    nixos = {
      core = {
        boot.enable = true;
        fonts.enable = true;
        general.enable = true;
        impermanence.enable = true;
        locate.enable = true;
        nix = {
          enable = true;
          flakePath = "/home/xardec/Proyectos/GitHub/nixos-config";
        };
        security.enable = true;
        users = {
          enable = true;
          primaryUser = "xardec";
          primaryUserPassword = "$6$6kcVeTMDK6yE6XdY$cgvhSqLBhNShREDb.cdNYV0iJS3GpqM.HTjcJKFt864nsnOviqoL6tZah/oamGZe3REqS8q1MQPcxq/76jYTW.";
        };
      };
      hardware = {
        intel-gpu.enable = true;
        energia.enable = true;
      };
      desktop = {
        pipewire.enable = true;
        steam.enable = true;
        systemPackages.enable = true;
      };
      services = {
        arduino.enable = true;
        networking.enable = true;
        printing.enable = true;
        sshd.enable = true;
        virtualisation.enable = true;
        #waydroid.enable = true;
      };
    };

    compartidos = {
      gnome.enable = true;
      #plasma.enable = true;
      #hyprland.enable = true;
      flatpak.enable = true;
      #windows-vm.enable = true;
    };
  };
}
