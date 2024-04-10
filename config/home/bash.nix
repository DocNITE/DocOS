{ config, lib, pkgs, ... }:

let inherit (import ../../options.nix) flakeDir flakePrev 
	     hostname flakeBackup theShell; in
lib.mkIf (theShell == "bash") {
  # Configure Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    initExtra = ''
      uwufetch

      #neofetch
      #if [ -f $HOME/.bashrc-personal ]; then
      #  source $HOME/.bashrc-personal
      #fi
    '';
    sessionVariables = {
      DOCOS = true;
      FLAKEBACKUP = "${flakeBackup}";
      FLAKEPREV = "${flakePrev}";
    };
    shellAliases = {
      sv="sudo nvim";
      flake-rebuild="nh os switch --hostname ${hostname}";
      flake-update="nh os switch --hostname ${hostname} --update";
      gcCleanup="nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v="nvim";
      ls="lsd";
      ll="lsd -l";
      la="lsd -a";
      lal="lsd -al";
      ".."="cd ..";
      neofetch="neofetch --ascii ~/.config/ascii-neofetch --ascii_colors 1 2 3 4 5 6";
      uwufetch="uwufetch -i $HOME/.face";
    };
  };
}
