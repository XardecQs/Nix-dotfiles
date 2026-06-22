{
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.nixos.services.servidor;
in
{
  imports = lib.pipe (builtins.readDir ./.) [
    builtins.attrNames
    (builtins.filter (
      name:
      name != "default.nix"
      && (lib.hasSuffix ".nix" name || builtins.pathExists (./. + "/${name}/default.nix"))
    ))
    (builtins.map (name: ./. + "/${name}"))
  ];

  options.modulos.nixos.services.servidor = {
    enable = lib.mkEnableOption "servidor";
    btrfsScrub = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Limpieza semanal de Btrfs (autoScrub)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.btrfs.autoScrub = lib.mkIf cfg.btrfsScrub {
      enable = true;
      interval = "weekly";
    };
  };
}
