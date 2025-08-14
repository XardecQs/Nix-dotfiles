{
  config,
  pkgs,
  dotfilesDir,
  ...
}:

{
  home.file = {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/nvim";
    ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/kitty";
    ".config/fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/fastfetch";
    ".vscode".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/vscode";
    ".icons".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/icons";
    ".local/share/fonts".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/fonts";
    ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/zsh";
    ".config/user-dirs.dirs".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/user-dirs.dirs";
  };
}
