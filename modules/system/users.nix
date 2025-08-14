{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.root.shell = pkgs.zsh;

    users.xardec = {
      isNormalUser = true;
      description = "Xavier Del Piero";
      extraGroups = [
        "networkmanager"
        "wheel"
        "xardec"
      ];
    };

    groups = {
      libvirtd.members = [ "xardec" ];
      xardec = {
        name = "xardec";
        gid = 1000;
        members = [ "xardec" ];
      };
    };
  };
}
