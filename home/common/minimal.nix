{ ... }: {
  imports = [
    ../modules/tmux.nix
    ../modules/git.nix
    ../modules/gnupg.nix
    ../modules/neovim.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      "EDITOR" = "nvim";
      "TERM" = "alacritty";
    };
  };

  home = {
    username = "vb";
    homeDirectory = "/home/vb";
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
