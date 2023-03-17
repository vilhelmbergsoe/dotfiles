{ pkgs, ... }: {
  imports = [
    ./minimal.nix

    ../modules/doom-emacs.nix
    ../modules/alacritty.nix
  ];

  home.packages = with pkgs; [
    # programs
    lf gotop feh

    # bar
    iproute2 gawk upower

    (pkgs.writeScriptBin "bar_action" ''
      #!/usr/bin/env bash

      ## LOCAL IP
      local_ip() {
        myip=`ip route get 1.1.1.1 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}'`
        echo -e "$myip"
      }

      ## RAM
      mem() {
        mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
        echo -e "$mem"
      }

      ## CPU
      cpu() {
        read cpu a b c previdle rest < /proc/stat
        prevtotal=$((a+b+c+previdle))
        sleep 0.5
        read cpu a b c idle rest < /proc/stat
        total=$((a+b+c+idle))
        cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
        echo -e "$cpu%"
      }

      # TODO: add battery and maybe also check if machine is desktop?
      ## BAT
      # bat() {
      #     bat=`amixer get Master | awk -F'[][]' 'END{ print $4":"$2 }' | sed 's/on://g'`
      #     echo -e "VOL: $vol"
      # }

      SLEEP_SEC=3
      #loops forever outputting a line every SLEEP_SEC secs

      # It seems that we are limited to how many characters can be displayed via
      # the baraction script output. And the the markup tags count in that limit.
      # So I would love to add more functions to this script but it makes the
      # echo output too long to display correctly.
      while :; do
          echo "$(local_ip) | cpu $(cpu) | mem $(mem) |"
        sleep $SLEEP_SEC
      done
    '')
  ];

  programs.rofi = {
    enable = true;

    plugins = [ pkgs.rofi-calc ];
    theme = "gruvbox-dark-soft";
  };

  xsession.windowManager.spectrwm = {
    enable = true;

    bindings = {
      term = "Mod+Shift+Return";
      search = "Mod+p";
      browser = "Mod+w";
      gotop = "Mod+Shift+r";
      lf = "Mod+r";
      lock = "Mod+Shift+l";
      wind_del = "Mod+Shift+c";
      float_toggle = "Mod+Shift+space";
      maximize_toggle = "Mod+Shift+u";
      fullscreen_toggle = "Mod+f";
      restart = "Mod+Shift+e";
      quit = "Mod+Shift+q";
    };

    programs = rec {
      term = "alacritty";
      search = "rofi -show run";
      lock = "slock";
      browser = "firefox";
      gotop = "${term} -e gotop";
      lf = "${term} -e lf";
    };

    settings = {
      modkey = "Mod4";
      workspace_limit = 9;
      focus_mode = "default";
      focus_close = "last";
      focus_close_wrap = 1;
      focus_default = "last";
      spawn_position = "last";
      workspace_clamp = 0;
      warp_focus = 1;
      warp_pointer = 0;

      # Window Decoration
      border_width = 2;
      color_focus = "rgb:ff/dd/33";
      color_focus_maximized = "red";
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
      bar_format = "+|L+1<+N:+I +S (+D) +W +|R+A+1< %a %b %d [%R]";
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

      autorun = "ws[1]:~/.fehbg";
    };

    unbindings = [
      "MOD+e"
      "MOD+m"
      "MOD+t"
    ];
  };

  gtk = {
    enable = true;


  };
}
