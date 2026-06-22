{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.nixos.core.users;
in
{
  options.modulos.nixos.core.users = {
    enable = lib.mkEnableOption "users";
    primaryUser = lib.mkOption {
      type = lib.types.str;
      description = "Usuario primario del sistema";
    };
    primaryUserPassword = lib.mkOption {
      type = lib.types.str;
      description = "Hash de contraseña del usuario primario";
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;
      defaultUserShell = pkgs.zsh;
      users.root = {
        shell = pkgs.zsh;
        hashedPassword = "$6$xQm6HutX3PwIE0TQ$yTRaUx5z2K7V3Qhfqnf976QwYr5hZYR2uuJsUPkCRiCrEOkZomyUraJ5fJb1LC2j.GCvvzYpRabrVyfjkRIn/1";
      };
      users.${cfg.primaryUser} = {
        isNormalUser = true;
        description = "Xavier Del Piero";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        hashedPassword = cfg.primaryUserPassword;
      };
    };
    programs = {
      zsh.enable = true;
    };
  };
}
