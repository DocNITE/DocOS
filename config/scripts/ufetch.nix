{ pkgs }:

pkgs.writeShellScriptBin "ufetch" ''
  sh $HOME/Scripts/ufetch.sh
''

