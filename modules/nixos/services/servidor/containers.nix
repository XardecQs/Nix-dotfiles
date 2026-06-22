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
    age.secrets.cloudreve-aria2.file = ../../../../secrets/cloudreve-aria2.age;

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
        autoPrune.enable = true;
        autoPrune.dates = "weekly";
      };

      oci-containers.backend = "podman";
      oci-containers.containers = {
        aria2 = {
          image = "p3terx/aria2-pro:latest";
          volumes = [
            "/srv/cloudreve/uploads:/data:rw"
            "/srv/aria2/config:/config:rw"
          ];
          environment = {
            PUID = "0";
            PGID = "0";
            UMASK_SET = "022";
            RPC_SECRET_FILE = config.age.secrets.cloudreve-aria2.path;
          };
          extraOptions = [ "--network=host" ];
          autoStart = true;
        };

        cloudreve = {
          image = "cloudreve/cloudreve:latest";
          volumes = [
            "/srv/cloudreve/uploads:/cloudreve/uploads:rw"
            "/srv/cloudreve/data:/cloudreve/data:rw"
            "/srv/cloudreve/conf:/cloudreve/conf:rw"
          ];
          dependsOn = [ "aria2" ];
          extraOptions = [ "--network=host" ];
          autoStart = true;
        };

        jellyfin = {
          image = "jellyfin/jellyfin:latest";
          volumes = [
            "/srv/jellyfin/config:/config:rw"
            "/srv/jellyfin/cache:/cache:rw"
            "/srv/archivos:/media:ro"
          ];
          extraOptions = [
            "--network=host"
            "--device=/dev/dri/renderD128:/dev/dri/renderD128"
          ];
          autoStart = true;
        };
      };
    };

    systemd.tmpfiles.rules = [
      "d /srv/archivos 0755 root users -"
      "d /srv/config 0755 root users -"
      "d /srv/cloudreve 0755 root users -"
      "d /srv/cloudreve/uploads 0755 root users -"
      "d /srv/cloudreve/conf 0755 root users -"
      "d /srv/cloudreve/data 0755 root users -"
      "d /srv/aria2 0755 root users -"
      "d /srv/aria2/config 0755 root users -"
      "d /srv/jellyfin 0755 root users -"
      "d /srv/jellyfin/config 0755 root users -"
      "d /srv/jellyfin/cache 0755 root users -"
    ];
  };
}
