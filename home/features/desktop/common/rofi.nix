{pkgs, ...}: {
  # power-menu is added this way because it doesn't work in rofi.plugins
  home.packages = [pkgs.rofi-power-menu];

  programs.rofi = {
    enable = true;

    pass.enable = true;

    extraConfig = {modi = "run,calc,ssh,drun";};

    plugins = [pkgs.rofi-calc pkgs.rofi-emoji];
    theme = "gruvbox-dark-soft";
  };
}
