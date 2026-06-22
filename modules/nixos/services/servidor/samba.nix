{
  lib,
  config,
  ...
}:
let
  cfg = config.modulos.nixos.services.servidor;
in
{
  config = lib.mkIf cfg.enable {
    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          userServices = true;
        };
      };

      samba-wsdd.enable = true;

      samba = {
        enable = true;
        openFirewall = false;
        settings = {
          global = {
            security = "user";
            workgroup = "WORKGROUP";
            "server string" = "Servidor NixOS";
            "map to guest" = "never";
          };
          archivos = {
            path = "/srv/archivos";
            browseable = "yes";
            "read only" = "no";
            "guest ok" = "no";
            "create mask" = "0644";
            "directory mask" = "0755";
            "valid users" = "@users";
          };
        };
      };
    };
  };
}
