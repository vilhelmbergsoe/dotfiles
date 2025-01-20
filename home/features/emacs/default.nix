{ inputs, pkgs, ... }: {
  # imports = [inputs.doom-emacs.hmModule];

  # demacs - emacsclient wrapper script
  home.packages = [
    # (pkgs.writeScriptBin "demacs" ''
    #   #!/usr/bin/env bash

    #   emacsclient -c -a 'emacs'
    # '')
    pkgs.nixd
    pkgs.nixfmt-classic
    pkgs.libgccjit

    pkgs.gvfs

    (pkgs.python3.withPackages (ps: with ps; [jsonlines anthropic]))
  ];

  nixpkgs.overlays = [ (import inputs.emacs-overlay.overlays.package) ];

  # services.emacs.enable = true;
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsWithPackagesFromUsePackage {
    package =
      pkgs.emacs30-pgtk; # replace with pkgs.emacsPgtk, or another version if desired.
    config = ./config/init.el;

    alwaysEnsure = true;

    defaultInitFile = true;

    extraEmacsPackages = epkgs: [ epkgs.use-package ];

    # override = epkgs:
    #   epkgs // {
    #     somePackage = epkgs.melpaPackages.somePackage.overrideAttrs (old:
    #       {
    #         # Apply fixes here
    #       });
    #   };
  };
}
