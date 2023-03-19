{ pkgs, ... }:

{
  imports = [ ];

  environment.systemPackages = with pkgs; [
    # nix tools
    nix-index
    nixfmt

    # common tools
    ripgrep
    fd
    duf
    ncdu
    killall
    wget
    libqalculate
    sshfs

    # dev
    git
    gnupg
    gnumake
    gcc
    pkg-config
  ];
}
