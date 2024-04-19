{ pkgs, config, lib, inputs, ... }:

let
  theme = config.colorScheme.palette;
  hyprplugins = inputs.hyprland-plugins.packages.${pkgs.system};
  inherit (import ../../options.nix) 
    browser cpuType gpuType
    wallpaperDir borderAnim
    colorfulBorder
    dockPanel hyprbars
    theKBDLayout terminal
    theSecondKBDLayout
    theKBDVariant sdl-videodriver;
in with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      # TODO: Add support for options.nix
      # hyprplugins.hyprtrails
      # hyprplugins.hyprbars
    ];
    extraConfig = let
      modifier = "SUPER";
    in concatStrings [ ''
      monitor=eDP-1,preferred,0x0,1.666667
      monitor=HDMI-A-1,preferred,-160x-1080,1
      windowrule = fullscreen, ^(wlogout)$
      windowrule = animation fade, ^(wlogout)$
      # windowrule= opacity 0.92 0.85, ^(discord)$
      general {
        gaps_in = 6
        gaps_out = 8
        border_size = 2
        ${if colorfulBorder == true then ''
        col.active_border = rgba(${theme.base0C}ff) rgba(${theme.base0D}ff) rgba(${theme.base0B}ff) rgba(${theme.base0E}ff) 45deg
        '' else ''
        col.active_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
        ''}
        col.inactive_border = rgba(${theme.base00}cc) rgba(${theme.base01}cc) 45deg
        layout = dwindle
        resize_on_border = true
      }

      input {
        kb_layout = ${theKBDLayout}, ${theSecondKBDLayout}
	kb_options = grp:alt_shift_toggle
        follow_mouse = 1
        touchpad {
          natural_scroll = false
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
        accel_profile = flat
      }
      env = NIXOS_OZONE_WL, 1
      env = NIXPKGS_ALLOW_UNFREE, 1
      env = NIXPKGS_ALLOW_INSECURE, 1
      env = XDG_CURRENT_DESKTOP, Hyprland
      env = XDG_SESSION_TYPE, wayland
      env = XDG_SESSION_DESKTOP, Hyprland
      env = GDK_BACKEND, wayland
      env = CLUTTER_BACKEND, wayland
      env = SDL_VIDEODRIVER, ${sdl-videodriver}
      env = QT_QPA_PLATFORM, wayland
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
      env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
      env = MOZ_ENABLE_WAYLAND, 1
      ${if cpuType == "vm" then ''
        env = WLR_NO_HARDWARE_CURSORS,1
        env = WLR_RENDERER_ALLOW_SOFTWARE,1
      '' else ''
      ''}
      ${if gpuType == "nvidia" then ''
        env = WLR_NO_HARDWARE_CURSORS,1
      '' else ''
      ''}
      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 3
      }
      misc {
        mouse_move_enables_dpms = true
        key_press_enables_dpms = false
      }
      animations {
        enabled = yes
        first_launch_animation = true

        # RandomDots Animations

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05
        bezier = liner, 1, 1, 1, 1
        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default

        # ZaneyOS Animations
        #bezier = wind, 0.05, 0.9, 0.1, 1.05
        #bezier = winIn, 0.1, 1.1, 0.1, 1.1
        #bezier = winOut, 0.3, -0.3, 0, 1
        #bezier = liner, 1, 1, 1, 1
        #animation = windows, 1, 6, wind, slide
        #animation = windowsIn, 1, 6, winIn, slide
        #animation = windowsOut, 1, 5, winOut, slide
        #animation = windowsMove, 1, 5, wind, slide
        #animation = border, 1, 1, liner
        ${if borderAnim == true then ''
          animation = borderangle, 1, 30, liner, loop
        '' else ''
        ''}
        #animation = fade, 1, 10, default
        #animation = workspaces, 1, 5, wind
      }
      decoration {
        rounding = 10
        drop_shadow = false
        blur {
            enabled = true
            size = 5
            passes = 3
            new_optimizations = on
            ignore_opacity = on
            # blurls = waybar
            # layerrule = blur,waybar
        }
      }
      plugin {
        hyprtrails {
          color = rgba(${theme.base0A}ff)
        }
        hyprbars {
          # config
          bar_color = rgba(${theme.base00}cc)
          bar_height = 24
          bar_buttons_alignment = left
          bar_part_of_window = false
          bar_precedence_over_border = true
          bar_text_font = JetBrainsMono Nerd Font Bold
          bar_text_size = 12
          col.text = rgba(${theme.base05}ff)

          # buttons (R -> L) 󰖭 
          # hyprbars-button = color, size, on-click
          hyprbars-button = rgb(ff4040), 14,  , hyprctl dispatch killactive
          hyprbars-button = rgb(eeee11), 14,  , hyprctl dispatch fullscreen 1
          hyprbars-button = rgb(2aca40), 14,  , hyprctl dispatch togglefloating
        }
      }
      exec-once = $POLKIT_BIN
      exec-once = dbus-update-activation-environment --systemd --all
      exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = swww init
      exec-once = waybar
      ${if dockPanel == true then ''
        exec-once = nwg-dock-hyprland -x -mb 6 -o eDP-1
      '' else ''
      ''}
      exec-once = swaync
      exec-once = wallsetter
      exec-once = nm-applet --indicator
      exec-once = swayidle -w timeout 720 'swaylock -f' timeout 800 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f -c 000000'
      dwindle {
        pseudotile = true
        preserve_split = true
      }
      master {
        new_is_master = true
      }
      bind = ${modifier},Return,exec,${terminal}
      bind = ${modifier}SHIFT,Return,exec,rofi-launcher
      bind = ${modifier}SHIFT,W,exec,set-wallpaper
      bind = ${modifier}SHIFT,N,exec,swaync-client -rs
      ${if browser == "google-chrome" then ''
	bind = ${modifier},W,exec,google-chrome-stable
      '' else ''
	bind = ${modifier},W,exec,${browser}
      ''}
      bind = ${modifier},E,exec,emopicker9000
      bind = ${modifier},S,exec,screenshootin
      bind = ${modifier},D,exec,discord
      bind = ${modifier},O,exec,obs
      bind = ${modifier},G,exec,gimp
      bind = ${modifier}SHIFT,G,exec,godot4
      bind = ${modifier},T,exec,thunar
      bind = ${modifier},M,exec,spotify
      bind = ${modifier},Q,killactive,
      bind = ${modifier},P,pseudo,
      bind = ${modifier}SHIFT,I,togglesplit,
      bind = ${modifier},F,fullscreen,
      bind = ${modifier}SHIFT,F,togglefloating,
      bind = ${modifier}SHIFT,C,exit,
      bind = ${modifier}SHIFT,left,movewindow,l
      bind = ${modifier}SHIFT,right,movewindow,r
      bind = ${modifier}SHIFT,up,movewindow,u
      bind = ${modifier}SHIFT,down,movewindow,d
      bind = ${modifier}SHIFT,h,movewindow,l
      bind = ${modifier}SHIFT,l,movewindow,r
      bind = ${modifier}SHIFT,k,movewindow,u
      bind = ${modifier}SHIFT,j,movewindow,d
      bind = ${modifier},left,movefocus,l
      bind = ${modifier},right,movefocus,r
      bind = ${modifier},up,movefocus,u
      bind = ${modifier},down,movefocus,d
      bind = ${modifier},h,movefocus,l
      bind = ${modifier},l,movefocus,r
      bind = ${modifier},k,movefocus,u
      bind = ${modifier},j,movefocus,d
      bind = ${modifier},1,workspace,1
      bind = ${modifier},2,workspace,2
      bind = ${modifier},3,workspace,3
      bind = ${modifier},4,workspace,4
      bind = ${modifier},5,workspace,5
      bind = ${modifier},6,workspace,6
      bind = ${modifier},7,workspace,7
      bind = ${modifier},8,workspace,8
      bind = ${modifier},9,workspace,9
      bind = ${modifier},0,workspace,10
      bind = ${modifier}SHIFT,SPACE,movetoworkspace,special
      bind = ${modifier},SPACE,togglespecialworkspace
      bind = ${modifier}SHIFT,1,movetoworkspace,1
      bind = ${modifier}SHIFT,2,movetoworkspace,2
      bind = ${modifier}SHIFT,3,movetoworkspace,3
      bind = ${modifier}SHIFT,4,movetoworkspace,4
      bind = ${modifier}SHIFT,5,movetoworkspace,5
      bind = ${modifier}SHIFT,6,movetoworkspace,6
      bind = ${modifier}SHIFT,7,movetoworkspace,7
      bind = ${modifier}SHIFT,8,movetoworkspace,8
      bind = ${modifier}SHIFT,9,movetoworkspace,9
      bind = ${modifier}SHIFT,0,movetoworkspace,10
      bind = ${modifier}CONTROL,right,workspace,e+1
      bind = ${modifier}CONTROL,left,workspace,e-1
      bind = ${modifier},mouse_down,workspace, e+1
      bind = ${modifier},mouse_up,workspace, e-1
      bindm = ${modifier},mouse:272,movewindow
      bindm = ${modifier},mouse:273,resizewindow
      # bind = ALT,SHIFT,exec,hyprctl switchxkblayout at-translated-set-2-keyboard next
      bind = ALT,Tab,cyclenext
      bind = ALT,Tab,bringactivetotop
      bind = ,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind = ,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      binde = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bind = ,XF86AudioPlay, exec, playerctl play-pause
      bind = ,XF86AudioPause, exec, playerctl play-pause
      bind = ,XF86AudioNext, exec, playerctl next
      bind = ,XF86AudioPrev, exec, playerctl previous
      bind = ,XF86MonBrightnessDown,exec,brightnessctl set 5%-
      bind = ,XF86MonBrightnessUp,exec,brightnessctl set +5%
    '' ];
  };
}
