{ inputs, ... }: {
  imports = [ inputs.doom-emacs.hmModule ];

  services.emacs.enable = true;

  home.shellAliases = {
    doomemacs = "emacsclient -c";
    demacs = "emacsclient -c";
  };

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d; # Directory containing the config.el, init.el
  };
}
