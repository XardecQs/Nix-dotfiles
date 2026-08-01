{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.modulos.home.apps.gta-mo;
in
{
  imports = [ inputs.gta-mo.homeManagerModules.default ];

  options.modulos.home.apps.gta-mo = {
    enable = lib.mkEnableOption "gta-mo";

    gameRoot = lib.mkOption {
      type = lib.types.str;
      default = "/home/xardec/Juegos/Windows/GTA_SA_Limpio";
      description = "Directorio raíz de GTA SA (game_root).";
    };

    protonPath = lib.mkOption {
      type = lib.types.str;
      default = "/home/xardec/.steam/root/compatibilitytools.d/GE-Proton11-1";
      description = "Directorio de la tool de Proton/GE (proton_path).";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gta-mo = {
      enable = true;
      gui = {
        enable = true;
        package = inputs.gta-mo.packages.${pkgs.stdenv.hostPlatform.system}.gta-mod-organizer-gui;
      };
      package = inputs.gta-mo.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        game_root = cfg.gameRoot;
        proton_path = cfg.protonPath;
      };
    };
  };
}
