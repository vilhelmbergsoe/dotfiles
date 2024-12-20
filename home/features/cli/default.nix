{pkgs, ...}: {
  imports = [
    ./git.nix
    ./gnupg.nix
    ./neovim
    ./tmux.nix
    ./bash.nix
    ./direnv.nix
    ./tiny.nix
    ./password-store.nix
    ./zoxide.nix
    ./eza.nix
  ];

  home.packages = with pkgs; [
    # common tools
    ripgrep # better grep
    fd # better find
    # ncdu # tui disk usage utility
    duf # better df
    libqalculate # calculator
    killall
    wget
    tree
    bat
    # tailspin

    # dev
    gnumake
    gcc
    # gdb
    # gef # gdb enhanced features
    lldb
    pkg-config
    file
    httpie
    sshfs
    openssl
    jujutsu
    just

    # nix tools
    nix-index
    alejandra
    deadnix
    statix
    comma
    cachix
    devenv
  ];
}
