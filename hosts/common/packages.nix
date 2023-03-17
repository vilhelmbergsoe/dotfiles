{ pkgs, ... }:

{
  imports = [];

  environment.systemPackages = with pkgs; [
    # nix tools
    nix-index nixfmt

    # common tools
    ripgrep fd duf ncdu libqalculate

    # dev
    git gnupg gnumake
  ];
}
