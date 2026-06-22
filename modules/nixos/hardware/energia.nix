{ lib, config, ... }:
let
  cfg = config.modulos.nixos.hardware.energia;
in
{
  options.modulos.nixos.hardware.energia = {
    enable = lib.mkEnableOption "gestión de energía";
    autoCpufreq = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Activar auto-cpufreq para gestión de frecuencia del CPU";
      };
      gobernadorCargador = lib.mkOption {
        type = lib.types.str;
        default = "performance";
        description = "Gobernador del CPU con cargador conectado";
      };
      gobernadorBateria = lib.mkOption {
        type = lib.types.str;
        default = "powersave";
        description = "Gobernador del CPU con batería";
      };
      turboCargador = lib.mkOption {
        type = lib.types.str;
        default = "auto";
        description = "Turbo boost con cargador conectado (auto/always/never)";
      };
      turboBateria = lib.mkOption {
        type = lib.types.str;
        default = "never";
        description = "Turbo boost con batería (auto/always/never)";
      };
    };
    termald = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Activar thermald para gestión térmica";
      };
    };
    upower = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Activar upower para monitoreo de batería";
      };
    };
    wifiPowersave = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar ahorro de energía en WiFi";
    };
    usbAutosuspend = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Activar suspensión automática de USB";
    };
  };

  config = lib.mkIf cfg.enable {
    services.auto-cpufreq = lib.mkIf cfg.autoCpufreq.enable {
      enable = true;
      settings = {
        battery = {
          governor = cfg.autoCpufreq.gobernadorBateria;
          turbo = cfg.autoCpufreq.turboBateria;
        };
        charger = {
          governor = cfg.autoCpufreq.gobernadorCargador;
          turbo = cfg.autoCpufreq.turboCargador;
        };
      };
    };

    services.thermald.enable = cfg.termald.enable;
    services.upower.enable = cfg.upower.enable;
    services.power-profiles-daemon.enable = false;

    powerManagement.powertop.enable = cfg.usbAutosuspend;

    services.udev.extraRules = lib.mkIf cfg.usbAutosuspend ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idClass}=="03", ATTR{power/autosuspend}="-1", ATTR{power/control}="on"
    '';

    networking.networkmanager.wifi.powersave = cfg.wifiPowersave;
  };
}
