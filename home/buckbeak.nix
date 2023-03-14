{ inputs, pkgs, ... }: {
  imports = [
    ./modules/gnupg.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
  ];

  nixpkgs = {
    overlays = [];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "vb";
    homeDirectory = "/home/vb";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
