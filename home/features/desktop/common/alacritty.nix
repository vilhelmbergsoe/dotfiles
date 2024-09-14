{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        padding = {
          x = 2;
          y = 2;
        };
      };
      font = {
        size = 12;
        normal = {
          family = "Cascadia Mono";
          style = "Regular";
        };
      };
      colors = {
        primary = {
          background = "#020202";
          foreground = "#F9F4DA";
        };
        normal = {
          black = "#4C4345";
          red = "#ED203D";
          green = "#0BA95B";
          yellow = "#FCBA28";
          blue = "#006EE6";
          magenta = "#7B5EA7";
          cyan = "#88DAF2";
          white = "#F1F1F1";
        };
        bright = {
          black = "#4C4345";
          red = "#ED203D";
          green = "#0BA95B";
          yellow = "#FCBA28";
          blue = "#006EE6";
          magenta = "#7B5EA7";
          cyan = "#88DAF2";
          white = "#F1F1F1";
        };
        cursor = {
          text = "#020202";
          cursor = "#F38BA3";
        };
      };
    };
  };
}
