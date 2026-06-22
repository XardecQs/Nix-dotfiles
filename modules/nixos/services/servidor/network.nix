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
    networking = {
      interfaces.enp3s0.ipv4.addresses = [
        {
          address = "192.168.1.199";
          prefixLength = 24;
        }
      ];
      defaultGateway = "192.168.1.1";
      nameservers = [
        "192.168.1.1"
        "8.8.8.8"
      ];

      firewall = {
        enable = true;
        allowedTCPPorts = [
          22
          445
          139
          5212
          8096
        ];
        allowedUDPPorts = [
          137
          138
          5353
        ];
      };
    };
  };
}
