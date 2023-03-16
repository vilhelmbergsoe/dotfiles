{ inputs, lib, pkgs, ... }: {
  imports = [
    ./minimal.nix

    ../modules/doom-emacs.nix
    ../modules/alacritty.nix
  ];

  home.packages = with pkgs; [ rofi lf gotop ];

  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";
      menu = "rofi -show run";

      # lib.mkOptionDefault
      keybindings = lib.mkOptionDefault {
        "${modifier}+Shift+Return" = "exec ${terminal}";
        "${modifier}+Shift+c" = "kill";
        "${modifier}+p" = "exec ${menu}";
        "${modifier}+w" = "exec firefox";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+f" = "fullscreen toggle";

        # "${modifier}+Shift+r" = "restart";

        "${modifier}+Shift+r" = "exec ${terminal} -e gotop";
        "${modifier}+r" = "exec ${terminal} -e lf";
        "${modifier}+Shift+w" = "exec ${terminal} -e nmtui";

        "${modifier}+e" = "layout default";
        "${modifier}+t" = "layout tabbed";
        "${modifier}+d" = "layout stacking";

        "${modifier}+g" = "mode \"resize\"";

        "${modifier}+s" = "sticky toggle";

        "${modifier}+b" = "bar mode toggle";
      };

      bars = [
        {
          position = "top";
          fonts = {
            size = 11.0;
          };
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }
      ];
    };
  };
}
