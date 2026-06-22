{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.compartidos.hyprland;
  user = config.modulos.nixos.core.users.primaryUser;
in
{
  options.modulos.compartidos.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    sistema = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar configuración de sistema (Hyprland compositor, portal xdg, ly DM)";
    };
    usuario = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar paquetes de usuario (waybar, swww, swaync, wlogout, etc.)";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.sistema {
        programs.hyprland.enable = true;

        services.displayManager.ly.enable = !config.modulos.compartidos.gnome.sistema;

        services.xserver.xkb.layout = "latam";

        xdg.portal = {
          enable = true;
          extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
        };

        environment.systemPackages = with pkgs; [
          nwg-displays
          blueman
          networkmanagerapplet
        ];
      })

      (lib.mkIf cfg.usuario {
        home-manager.users.${user}.home.packages = with pkgs; [
          waybar
          swww
          swaynotificationcenter
          wlogout
          hyprshot
          cliphist
          brightnessctl
          mpvpaper
          xfce.xfce4-appfinder
          nautilus
          pywal16
        ];
      })
    ]
  );
}
