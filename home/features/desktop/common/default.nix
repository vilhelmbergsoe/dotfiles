{pkgs, ...}: {
  imports = [
    ../../emacs

    ./lf.nix
    ./rofi.nix
    ./clipmenu.nix
    ./dunst.nix
    ./alacritty.nix
    ./gtk.nix
  ];

  home.packages = with pkgs; [
    # gui
    firefox # TODO: fix picture-in-picture mode not working
    libreoffice
    webcord
    spotify
    pcmanfm
    pavucontrol
    mpv
    sxiv
    zathura
    obs-studio
    qbittorrent
    helvum

    # other
    gotop
    feh
    libnotify
    xclip
  ];
}
