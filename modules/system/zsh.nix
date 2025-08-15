{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    interactiveShellInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
      source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

      HISTSIZE=10000
      HISTFILE=~/.local/share/zsh/history
      SAVEHIST=$HISTSIZE

      autoload -U select-word-style
      select-word-style bash

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.lsd}/bin/lsd --color=always $realpath'
      zstyle ':fzf-tab:*' fzf-flags --height=55% --border

      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word
      bindkey "^[[3~" delete-char

      [[ ! -f ~/.config/zsh/p10k.zsh ]] || source ~/.config/zsh/p10k.zsh
    '';

    shellAliases = {
      lla = "lsd -la";
      la = "lsd -a";
      ll = "lsd -l";
      ls = "lsd";
      q = "exit";
      c = "clear";
      ".." = "cd ..";
      "..." = "cd ../..";
      cf = "clear && fastfetch";
      cff = "clear && fastfetch --config examples/13.jsonc";
      snvim = "sudo nvim";
      ordenar = "~/Proyectos/Scripts/sh/ordenar.sh";
      desordenar = "~/Proyectos/Scripts/sh/desordenar.sh";
      cp = "cp --reflink=auto";
      umatrix = "unimatrix -s 95 -f";
      grep = "grep --color=auto";
      diff = "diff --color=auto";
      syu = "yay -Syu";
      codepwd = ''code "$(pwd)"'';
      napwd = ''nautilus "$(pwd)" &> /dev/null & disown'';
      dots = "cd ~/.dotfiles && codepwd && q";
      dotsn = "cd ~/.dotfiles && nvim";
    };
  };
}
