{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
    #xserver.desktopManager.cinnamon.enable = true;
    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      xkb.layout = "latam";
      videoDrivers = [ "intel" ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = [ pkgs.epson-escpr ];
    };

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "daily";
      prunePaths = [
        "/tmp"
        "/var/tmp"
        "/home/.cache"
      ];
    };

    openssh.enable = false;
    pulseaudio.enable = false;
    spice-vdagentd.enable = true;
  };

  security.rtkit.enable = true;
}
