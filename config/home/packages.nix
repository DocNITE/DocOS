{ pkgs, config, username, ... }:

let 
  inherit (import ../../options.nix) 
    browser wallpaperDir wallpaperGit flakeDir;
in {
  # Install Packages For The User
  home.packages = with pkgs; [
    pkgs."${browser}" discord libvirt swww grim slurp gnome.file-roller
    swaynotificationcenter rofi-wayland imv transmission-gtk mpv
    gimp obs-studio rustup audacity pavucontrol tree protonup-qt
    font-awesome spotify swayidle neovide element-desktop swaylock
    bottom vscode krita libreoffice-qt hyprpicker lmms
    dotnet-sdk_8 cmake clang nix-direnv wf-recorder
    qemu wineWowPackages.stable winetricks appimage-run
    whatsapp-for-linux telegram-desktop
    nwg-dock-hyprland whois zfxtop headset vlc nix-search-cli
    hilbish zathura zsh p7zip dorion android-tools
    cataclysm-dda aria yt-dlp ffmpeg fzf flutter
    love session-desktop
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # Import Scripts
    (import ./../scripts/emopicker9000.nix { inherit pkgs; })
    (import ./../scripts/task-waybar.nix { inherit pkgs; })
    (import ./../scripts/squirtle.nix { inherit pkgs; })
    (import ./../scripts/wallsetter.nix { inherit pkgs; inherit wallpaperDir;
      inherit username; inherit wallpaperGit; })
    (import ./../scripts/themechange.nix { inherit pkgs; inherit flakeDir; })
    (import ./../scripts/theme-selector.nix { inherit pkgs; })
    (import ./../scripts/set-wallpaper.nix {inherit pkgs; })
    (import ./../scripts/battery-check.nix { inherit pkgs; })
    (import ./../scripts/nvidia-offload.nix { inherit pkgs; })
    (import ./../scripts/web-search.nix { inherit pkgs; })
    (import ./../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ./../scripts/screen-man.nix { inherit pkgs; })
    (import ./../scripts/screenshootin.nix { inherit pkgs; })
    (import ./../scripts/list-hypr-bindings.nix { inherit pkgs; })
    (import ./../scripts/ufetch.nix { inherit pkgs; })
  ];

  programs.gh.enable = true;
}
