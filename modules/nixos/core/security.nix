{ lib, config, ... }:
let
  cfg = config.modulos.nixos.core.security;
  user = config.modulos.nixos.core.users.primaryUser;
in
{
  options.modulos.nixos.core.security = {
    enable = lib.mkEnableOption "security";
  };

  config = lib.mkIf cfg.enable {
    security = {
      rtkit.enable = true;
      polkit.enable = true;
      allowUserNamespaces = true;
      pam.services.login.enableGnomeKeyring = true;
    };

    modulos.persistencia.sistema.directories = [ "/var/db/sudo" ];
    modulos.persistencia.usuarios.${user}.directories = [ ".local/share/keyrings" ];
  };
}
