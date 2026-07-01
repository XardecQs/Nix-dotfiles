{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.home.desktop.rofi;
in
{
  options.modulos.home.desktop.rofi = {
    enable = lib.mkEnableOption "rofi con tema M3 Expressive adaptado a pywal16";
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
    };

    home.persistence."/persist" = {
      directories = [
        ".config/rofi"
        ".local/share/rofi"
      ];
    };
  };
}
