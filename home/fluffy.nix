{pkgs, ...}: {
  imports = [
    ./features/cli
    ./features/desktop/common/rio.nix
    ./features/desktop/common/alacritty.nix
    ./features/emacs
  ];

  #nixpkgs = {
  #  overlays = [];
  #  config = {
  #    allowUnfree = true;
  #    allowUnfreePredicate = _: true;
  #  };
  #};

  home.packages = with pkgs; [gh bottom];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    initExtra = "export PROMPT='%n@%m:%~ $ '";
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # granted (assume)
  programs.granted.enable = true;
  programs.granted.enableZshIntegration = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
