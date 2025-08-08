{ inputs, pkgs, ... }: {
  nixpkgs.overlays = [ (inputs.emacs-overlay.overlays.package) ];

  home.packages = [
    pkgs.nixd
    pkgs.nixfmt-classic
    pkgs.libgccjit
    pkgs.cmake # needed for vterm module compilation

    # Yarn PnP support fix
    (pkgs.writers.writeBashBin "typescript-language-server" ''
          ${pkgs.nodePackages_latest.yarn}/bin/yarn node ${pkgs.typescript-language-server}/lib/node_modules/typescript-language-server/lib/cli.mjs "$@"
        '')
  ];

  # services.emacs.enable = true;
  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacsWithPackagesFromUsePackage {
    package = if pkgs.stdenv.isDarwin then
      # (pkgs.emacs.override {withNativeCompilation = false;})
      pkgs.emacs-pgtk 
      else pkgs.emacs-git-pgtk; # replace with pkgs.emacsPgtk, or another version if desired.

    config = ./config/init.el;

    alwaysEnsure = true;

    defaultInitFile = true;

    extraEmacsPackages = epkgs:
      with epkgs; [
        use-package
      ];

    # override = epkgs:
    #   epkgs // {
    #     somePackage = epkgs.melpaPackages.somePackage.overrideAttrs (old:
    #       {
    #         # Apply fixes here
    #       });
    #   };
  };
}
