{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;

    enableZshIntegration = true;

    settings = {
      theme = "dark:vb-dark,light:vb-light";
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

      vb-light = {
	background = "FAFAFA";
	cursor-color = "2E2E2E";
	foreground = "2E2E2E";

	palette = [
	  "0=#E0E0E0"   # black - faint border
	  "1=#D32F2F"   # red
	  "2=#1E5631"   # green - matching string-fg
	  "3=#8B6914"   # yellow - matching comment-fg
	  "4=#1565C0"   # blue - matching func-fg
	  "5=#5E35B1"   # magenta - matching const-fg
	  "6=#0097A7"   # cyan
	  "7=#2E2E2E"   # white - matching fg
	  "8=#B0B0B0"   # bright black - matching faint
	  "9=#EF5350"   # bright red
	  "10=#388E3C"  # bright green - matching success
	  "11=#F57C00"  # bright yellow - matching warning
	  "12=#42A5F5"  # bright blue
	  "13=#BA68C8"  # bright magenta
	  "14=#26C6DA"  # bright cyan
	  "15=#6B6B6B"  # bright white - matching subtle
	];
      };

      vb-dark = {
	background = "1E1E1E";
	cursor-color = "D4D4D4";
	foreground = "D4D4D4";
 
	palette = [
	  "0=#2D2D2D"   # black - matching border
	  "1=#EF5350"   # red - matching error
	  "2=#81C784"   # green - matching string-fg
	  "3=#FFB74D"   # yellow - matching comment-fg
	  "4=#42A5F5"   # blue - matching func-fg
	  "5=#BA68C8"   # magenta - matching const-fg
	  "6=#4DB8A8"   # cyan
	  "7=#D4D4D4"   # white - matching fg
	  "8=#555555"   # bright black - matching faint
	  "9=#EF5350"   # bright red
	  "10=#66BB6A"  # bright green - matching success
	  "11=#FFA726"  # bright yellow - matching warning
	  "12=#90CAF9"  # bright blue
	  "13=#CE93D8"  # bright magenta
	  "14=#80DEEA"  # bright cyan
	  "15=#9D9D9D"  # bright white - matching subtle
	];
      };
    };
  };
}
