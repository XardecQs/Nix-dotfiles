{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.compartidos.plasma;
  user = config.modulos.nixos.core.users.primaryUser;
in
{
  options.modulos.compartidos.plasma = {
    enable = lib.mkEnableOption "plasma";
    sistema = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar Plasma 6 a nivel sistema";
    };
    usuario = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar paquetes y configuración de usuario para KDE";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.sistema {
        services.desktopManager.plasma6.enable = true;
        services.xserver.xkb.layout = "latam";

        environment.persistence."/persist" = lib.mkIf config.modulos.nixos.core.impermanence.enable {
          users.${user}.directories = [
            ".config/KDE"
            ".local/share/kglobalaccel"
            ".local/share/kscreen"
            ".local/share/ksysguard"
            ".local/share/kwin"
            ".local/share/plasma"
          ];
        };
      })

      (lib.mkIf cfg.usuario {
        home-manager.users.${user} = {
          home.packages = with pkgs; [
            kdePackages.dolphin
            kdePackages.konsole
          ];
        };
      })
    ]
  );
}
