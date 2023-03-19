{ config, lib, pkgs, ... }:

{
  imports = [
    ../../emacs

    ./lf.nix
    ./rofi.nix
    ./clipmenu.nix
    ./dunst.nix
    ./alacritty.nix
  ];

  home.packages = with pkgs; [
    # gui
    firefox
    libreoffice
    webcord
    spotify
    pcmanfm
    pavucontrol
    mpv
    sxiv
    zathura
    obs-studio

    # other
    gotop
    feh
    libnotify
    xclip
  ];
}
