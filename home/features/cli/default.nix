{pkgs, ...}: {
  imports = [
    ./git.nix
    ./gnupg.nix
    ./neovim.nix
    ./tmux.nix
    ./bash.nix
    ./direnv.nix
    ./tiny.nix
    ./password-store.nix
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
    bat

    # dev
    gnumake
    gcc
    gdb
    pkg-config
    file
    httpie

    # nix tools
    nix-index
    alejandra
    deadnix
    statix
    comma
  ];
}
