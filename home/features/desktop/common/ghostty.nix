{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    enableZshIntegration = true;

    settings = {
      theme = "my-theme";
      cursor-style = "block";
      cursor-style-blink = true;
    };

    themes = {
      my-theme = {
        background = "181818";
        cursor-color = "F28E9B";
        foreground = "FFFFFF";
        palette = [
          "0=#4C4345" # black
          "1=#ED203D" # red
          "2=#0BA95B" # green
          "3=#FCBA28" # yellow
          "4=#006EE6" # blue
          "5=#7B5EA7" # magenta
          "6=#88DAF2" # cyan
          "7=#F1F1F1" # white
          "8=#4C4345" # bright black
          "9=#ED203D" # bright red
          "10=#0BA95B" # bright green
          "11=#FCBA28" # bright yellow
          "12=#006EE6" # bright blue
          "13=#7B5EA7" # bright magenta
          "14=#88DAF2" # bright cyan
          "15=#F1F1F1" # bright white
        ];
        selection-background = "353749"; # Optional selection colors
        selection-foreground = "F9F4DA"; # Optional selection colors
      };
    };
  };
}
