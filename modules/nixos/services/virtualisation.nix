{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modulos.nixos.services.virtualisation;
  user = config.modulos.nixos.core.users.primaryUser;
in
{
  options.modulos.nixos.services.virtualisation = {
    enable = lib.mkEnableOption "virtualisation";
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;

    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = with pkgs; [
      distrobox
    ];
    users.users.${user}.extraGroups = [
      "podman"
    ];
    services.spice-vdagentd.enable = true;

    environment.persistence."/persist" = lib.mkIf config.modulos.nixos.core.impermanence.enable {
      directories = [
        "/var/lib/containerd"
      ];
      users.${user}.directories = [
        ".local/share/containers"
        ".config/containers"
      ];
    };
  };
}
