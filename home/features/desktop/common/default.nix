{pkgs, ...}: {
  imports = [
    ../../emacs

    ./lf.nix
    ./rofi.nix
    ./clipmenu.nix
    ./dunst.nix
    ./alacritty.nix
    ./kitty.nix
    ./rio.nix
    ./gtk.nix
    ./flameshot.nix
  ];

  home.packages = with pkgs; [
    # gui
    firefox
    libreoffice
    # webcord
    (discord.override {
      withVencord = true;
    })
    discord-screenaudio
    spotify
    pcmanfm
    pavucontrol
    pulsemixer
    mpv
    sxiv
    zathura
    obs-studio
    qbittorrent
    helvum

    # other
    feh
    libnotify
    xclip
  ];
}
