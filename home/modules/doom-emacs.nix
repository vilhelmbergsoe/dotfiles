{ inputs, pkgs, ... }: {
  imports = [ inputs.doom-emacs.hmModule ];

  services.emacs.enable = true;

  home.packages = [
    (pkgs.writeScriptBin "demacs" ''
      #!/usr/bin/env bash

      emacsclient -c -a 'emacs'
    '')
  ];

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d; # Directory containing the config.el, init.el
  };
}
