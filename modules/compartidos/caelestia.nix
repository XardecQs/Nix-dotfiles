{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modulos.compartidos.caelestia;
  user = config.modulos.nixos.core.users.primaryUser;
  shellPackage =
    inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.overrideAttrs
      (_old: {
        version = "2.1.0";
      });
in
{
  options.modulos.compartidos.caelestia = {
    enable = lib.mkEnableOption "caelestia shell (shell de escritorio M3 para Hyprland)";
    sistema = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar configuración de sistema (requiere hyprland activo)";
    };
    usuario = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar shell de usuario (caelestia-shell, systemd service, CLI)";
    };
    cli = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Activar CLI de caelestia para control y configuración en caliente";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.sistema {
        # Hyprland es requisito — se asume que modulos.compartidos.hyprland.enable = true
        # No hay configuración de sistema específica de caelestia
      })
      (lib.mkIf cfg.usuario {
        home-manager.users.${user} = {
          programs.caelestia = {
            enable = true;
            package = shellPackage;
            cli.enable = cfg.cli.enable;
          };
        };
      })
    ]
  );
}
