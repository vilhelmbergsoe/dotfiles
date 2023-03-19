{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./gnupg.nix
    ./neovim.nix
    ./tmux.nix
    ./bash.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    # common tools
    ripgrep # better grep
    fd # better find
    ncdu # tui disk usage utility
    duf # better df
    libqalculate # calculator
    killall
    wget
    tree

    # dev
    gnumake
    gcc
    pkg-config

    # nix tools
    nix-index
    nixfmt
  ];
}