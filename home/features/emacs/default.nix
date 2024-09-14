{
  inputs,
  pkgs,
  ...
}: {
  # imports = [inputs.doom-emacs.hmModule];

  # demacs - emacsclient wrapper script
  home.packages = [
    (pkgs.writeScriptBin "demacs" ''
      #!/usr/bin/env bash

      emacsclient -c -a 'emacs'
    '')
  ];

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];

  # services.emacs.enable = true;
  programs.emacs.enable = true;
  programs.emacs.package = (pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-gtk;  # replace with pkgs.emacsPgtk, or another version if desired.
      config = ./config/init.el;

      alwaysEnsure = true;

      defaultInitFile = true;

      # Optionally provide extra packages not in the configuration file.
      extraEmacsPackages = epkgs: [
        epkgs.use-package
      ];

      # Optionally override derivations.
      override = epkgs: epkgs // {
        somePackage = epkgs.melpaPackages.somePackage.overrideAttrs(old: {
           # Apply fixes here
        });
      };
    });

  # programs.doom-emacs = {
  #   enable = true;
  #   doomPrivateDir = ./doom.d; # Directory containing the config.el, init.el
  # };
}
