{ pkgs }:

pkgs.writeShellScriptBin "battery-check" ''
  bash -c "sh $HOME/Scripts/battery-level.sh"
''

