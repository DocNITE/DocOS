{ pkgs, config, ... }:

let
  palette = config.colorScheme.palette;
in {
  home.packages = with pkgs; [
    eww
  ];
}
