{ lib, config, ... }:
let
  cfg = config.modulos.nixos.core.general;
in
{
  options.modulos.nixos.core.general = {
    enable = lib.mkEnableOption "general";
  };

  config = lib.mkIf cfg.enable {
    system.stateVersion = "26.05";
    time.timeZone = "America/Lima";
    i18n.defaultLocale = "es_PE.UTF-8";
    console.keyMap = "la-latin1";

    modulos.persistencia.sistema.directories = [
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
    ];
  };
}
