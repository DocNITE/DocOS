{ pkgs }:

pkgs.writeShellScriptBin "set-wallpaper" ''
  sh $HOME/Scripts/set-wallpaper.sh
''
