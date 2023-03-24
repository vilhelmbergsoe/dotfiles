{...}: {
  imports = [./scripts.nix];

  # spectrwm config
  xsession.windowManager.spectrwm = {
    enable = true;

    bindings = {
      term = "Mod+Shift+Return";
      search = "Mod+p";
      browser = "Mod+w";
      gotop = "Mod+Shift+r";
      lf = "Mod+r";
      nmtui = "Mod+Shift+w";
      clipmenu = "Mod+Shift+i";
      powermenu = "Mod+BackSpace";
      emoji = "Mod+Shift+l";

      wind_del = "Mod+Shift+c";
      float_toggle = "Mod+Shift+space";
      maximize_toggle = "Mod+Shift+u";
      fullscreen_toggle = "Mod+f";
      restart = "Mod+q";
    };

    programs = rec {
      term = "kitty";
      search = "rofi -show run";
      lock = "slock";
      browser = "firefox";
      gotop = "${term} -e gotop";
      lf = "${term} -e lf";
      nmtui = "${term} -e nmtui";
      clipmenu = "sh -c 'CM_LAUNCHER=rofi clipmenu'";
      powermenu = "rofi -show power-menu -modi power-menu:rofi-power-menu";
      emoji = "rofi -show emoji -modi emoji";
    };

    settings = {
      modkey = "Mod4";
      workspace_limit = 9;
      focus_mode = "default";
      focus_close = "next";
      focus_close_wrap = 1;
      focus_default = "last";
      spawn_position = "first";
      workspace_clamp = 0;
      warp_focus = 1;
      warp_pointer = 0;

      # Window Decoration
      border_width = 2;
      color_focus = "rgb:ff/dd/33";
      color_focus_maximized = "rgb:a6/1f/69";
      color_unfocus = "rgb:88/88/88";
      color_unfocus_maximized = "rgb:88/88/88";
      region_padding = 0;
      tile_gap = 0;

      # Bar Settings
      bar_action = "bar_action";
      bar_action_expand = 1;
      bar_enabled = 1;
      bar_border_width = 1;
      "bar_border[1]" = "rgb:18/18/18";
      "bar_border_unfocus[1]" = "rgb:18/18/18";
      "bar_color[1]" = "rgb:18/18/18, rgb:00/80/80";
      "bar_color_selected[1]" = "rgb:00/80/80";
      bar_delay = 5;
      "bar_font_color[1]" = "rgb:ff/dd/33, rgb:e1/ac/ff, rgb:dd/ff/a7, rgb:ff/8b/92, rgb:ff/e5/85, rgb:89/dd/ff";
      bar_font_color_selected = "black";
      bar_font = "monospace:size=12";
      bar_justify = "right";
      bar_format = "+|L+1<+N:+I +S (+D) +W +|R+A %a %b %d [%R]";
      workspace_indicator = "listcurrent,listactive,markcurrent,printnames";
      bar_at_bottom = 0;
      stack_enabled = 1;
      clock_enabled = 1;
      clock_format = "%a %b %d %R %Z %Y";
      iconic_enabled = 0;
      maximize_hide_bar = 0;
      window_class_enabled = 1;
      window_instance_enabled = 1;
      window_name_enabled = 1;
      verbose_layout = 1;
      urgent_enabled = 1;

      autorun = "ws[1]:startup_action";
    };

    unbindings = [
      "MOD+e"
      "MOD+m"
      "MOD+t"
      "MOD+x"
      "MOD+Shift+e"
      "MOD+Shift+Delete"
      "MOD+Shift+q"
    ];
  };
}
