{ inputs, pkgs, ... }: {
  imports = [
    ./minimal.nix

    ../modules/doom-emacs.nix
    ../modules/alacritty.nix

    inputs.hyprland.homeManagerModules.default
  ];

  home.packages = with pkgs; [ wofi alacritty lf gotop waybar ];

  programs.waybar.package = pkgs.waybar.overrideAttrs
    (oa: { mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ]; });

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = true;
    extraConfig = ''
      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor=,144,auto,auto

      # Execute your favorite apps at launch
      # exec-once = waybar & hyprpaper & firefox
      exec-once = waybar

      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf

      # Some default env vars.
      env = XCURSOR_SIZE,24
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1

      # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
      input {
          kb_layout = dk
          kb_variant =
          kb_model =
          kb_options =
          kb_rules =

          follow_mouse = 1

          touchpad {
              natural_scroll = yes
          }

          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }

      general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5
          gaps_out = 5
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = dwindle
      }

      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 0
          blur = no
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = on

          drop_shadow = yes
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      animations {
          enabled = no

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          # bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          # animation = windows, 1, 7, myBezier
          # animation = windowsOut, 1, 7, default, popin 80%
          # animation = border, 1, 10, default
          # animation = borderangle, 1, 8, default
          # animation = fade, 1, 7, default
          # animation = workspaces, 1, 6, default
      }

      dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = yes # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = yes
      }

      # Example windowrule v1
      # windowrule = float, ^(alacritty)$
      # Example windowrule v2
      # windowrulev2 = float,class:^(alacritty)$,title:^(kitty)$
      # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod SHIFT, Return, exec, alacritty
      bind = $mainMod SHIFT, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, W, exec, firefox
      bind = $mainMod, R, exec, alacritty -e lf
      bind = $mainMod SHIFT, R, exec, alacritty -e gotop
      bind = $mainMod SHIFT, Space, togglefloating,
      bind = $mainMod, P, exec, wofi --show run
      bind = $mainMod, T, pseudo, # dwindle
      bind = $mainMod, Y, togglesplit, # dwindle

      # Move focus with mainMod + arrow keys
      bind = $mainMod, H, movefocus, l
      bind = $mainMod, L, movefocus, r
      bind = $mainMod, K, movefocus, u
      bind = $mainMod, J, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
    '';
  };
}