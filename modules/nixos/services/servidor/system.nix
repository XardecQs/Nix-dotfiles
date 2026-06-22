{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modulos.nixos.services.servidor;
in
{
  config = lib.mkIf cfg.enable {
    modulos.nixos.hardware.energia = {
      enable = true;
      autoCpufreq = {
        gobernadorCargador = "powersave";
        turboCargador = "never";
      };
    };

    environment.systemPackages = with pkgs; [
      htop
      powertop
      git
      vim
      pciutils
    ];

    security.wrappers.beep = {
      owner = "root";
      group = "wheel";
      source = "${pkgs.beep}/bin/beep";
      permissions = "u+rs,g+rs,o+rx";
    };

    systemd.services.boot-beep = {
      description = "Beep when system is ready";
      after = [
        "multi-user.target"
        "network-online.target"
        "sshd.service"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        RemainAfterExit = false;
      };
      script = ''
        sleep 3
        ${pkgs.beep}/bin/beep -f 1000 -l 200 -r 3 -D 100 2>/dev/null || true
      '';
    };

    services.logind.settings = {
      Login = {
        HandlePowerKey = "poweroff";
        PowerKeyIgnoreInhibited = "yes";
      };
    };
  };
}
