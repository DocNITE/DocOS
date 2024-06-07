{ pkgs }:

pkgs.writeShellScriptBin "battery-check" ''
  sh $HOME/Scripts/battery-level.sh
''

