{
  config,
  pkgs,
  dotfilesDir,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/users/xardec/packages.nix
    ./modules/users/xardec/zsh.nix
    ./modules/users/xardec/gnome.nix
    ./modules/users/xardec/files.nix
  ];

  home = {
    stateVersion = "25.05";
    username = "xardec";
    homeDirectory = "/home/xardec";
  };
}
