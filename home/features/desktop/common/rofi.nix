{pkgs, ...}: {
  # power-menu is added this way because it doesn't work in rofi.plugins
  home.packages = [pkgs.rofi-power-menu];

  programs.rofi = {
    enable = true;

    pass = {
      enable = true;

      stores = ["/home/vb/Sync/.password-store/"];

      extraConfig = ''
        # Fixes issue: https://github.com/carnager/rofi-pass/issues/226
        help_color="#4872FF"

        notify='true'

        # sane clipboard config
        default_do='copyPass'
        clip='clipboard'
      '';
    };

    extraConfig = {modi = "run,calc,ssh,drun";};

    plugins = [pkgs.rofi-calc pkgs.rofi-emoji];
    theme = "gruvbox-dark";
  };
}
