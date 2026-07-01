{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.compartidos.niri;
  user = config.modulos.nixos.core.users.primaryUser;
in
{
  options.modulos.compartidos.niri = {
    enable = lib.mkEnableOption "niri";
    sistema = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar configuración de sistema (compositor Niri, portal xdg, sesión en display manager)";
    };
    usuario = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar paquetes de usuario (waybar, fuzzel, swaybg, playerctl), systemd user units y configuración";
    };
    configPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Ruta al directorio de configuración de niri en el repositorio. Si se define, ~/.config/niri será un symlink editable a esta ruta. Temporal mientras se configura.";
    };
    quickshellPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Ruta al directorio de configuracion de quickshell en el repositorio. Si se define, ~/.config/quickshell sera un symlink editable a esta ruta.";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.sistema {
        services.displayManager.sessionPackages = [ pkgs.niri ];

        environment.systemPackages = with pkgs; [
          niri
          xdg-desktop-portal-gtk
          nwg-displays
          blueman
          networkmanagerapplet
        ];

        xdg.portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
          config.niri = {
            default = [
              "gnome"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Access" = [ "gtk" ];
            "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
          };
        };
      })

      (lib.mkIf cfg.usuario {
        home-manager.users.${user} = {
          home.packages = with pkgs; [
            waybar
            swaybg
            playerctl
            brightnessctl
            pulsemixer
            quickshell
            awww
            pywal16
          ];

          systemd.user.services.niri = {
            Unit = {
              Description = "A scrollable-tiling Wayland compositor";
              BindsTo = [ "graphical-session.target" ];
              Before = [ "graphical-session.target" ];
              Wants = [ "graphical-session-pre.target" ];
              After = [ "graphical-session-pre.target" ];
            };
            Service = {
              Type = "notify";
              ExecStart = "${pkgs.niri}/bin/niri --session";
              Slice = "session.slice";
            };
          };

          systemd.user.targets.niri-shutdown = {
            Unit = {
              Description = "Shutdown running niri session";
              DefaultDependencies = false;
              StopWhenUnneeded = true;
              Conflicts = [
                "graphical-session.target"
                "graphical-session-pre.target"
              ];
              After = [
                "graphical-session.target"
                "graphical-session-pre.target"
              ];
            };
          };

          imports =
            lib.optionals (cfg.configPath != null) [
              (
                { config, ... }:
                {
                  home.file.".config/niri" = {
                    source = config.lib.file.mkOutOfStoreSymlink cfg.configPath;
                    recursive = true;
                  };
                }
              )
            ]
            ++ lib.optionals (cfg.quickshellPath != null) [
              (
                { config, ... }:
                {
                  home.file.".config/quickshell" = {
                    source = config.lib.file.mkOutOfStoreSymlink cfg.quickshellPath;
                    recursive = true;
                  };
                }
              )
            ];

          home.persistence."/persist" = {
            directories = [
              ".cache/wal"
              ".cache/awww"
            ];
          };
        };
      })
    ]
  );
}
