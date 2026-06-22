{
  lib,
  config,
  ...
}:
let
  # Módulo exclusivo de sistema:
  #   cfg = config.modulos.nixos.<categoria>.<nombre>;
  #
  # Módulo exclusivo de usuario:
  #   cfg = config.home-manager.users.<usuario>.modulos.home.<categoria>.<nombre>;
  #
  # Módulo unificado (sistema + usuario):
  #   cfg = config.modulos.compartidos.<nombre>;
  cfg = config.modulos.nixos.core.plantilla;
in
{
  options.modulos.nixos.core.plantilla = {
    enable = lib.mkEnableOption "Habilita el módulo plantilla";
  };

  config = lib.mkIf cfg.enable {
  };
}
