{ pkgs, inputs, config, lib, ... }: {
  nixpkgs.overlays = [ (inputs.emacs-overlay.overlays.default) ];

  home.packages = [
    pkgs.nixd
    pkgs.nixfmt
    pkgs.libgccjit
    pkgs.universal-ctags

    # Yarn PnP support fix
    (pkgs.writers.writeBashBin "typescript-language-server" ''
      ${pkgs.yarn}/bin/yarn node ${pkgs.typescript-language-server}/lib/node_modules/typescript-language-server/lib/cli.mjs "$@"
    '')
  ];

  # services.emacs.enable = true;
  programs.emacs.enable = true;
  programs.emacs.package = let
    inherit (inputs.emacs-overlay.packages.${pkgs.stdenv.hostPlatform.system})
      emacs-unstable emacs-git-pgtk;
  in pkgs.emacsWithPackagesFromUsePackage {
    package = if pkgs.stdenv.isDarwin then emacs-unstable else emacs-git-pgtk;

    config = ./config/init.el;

    # alwaysEnsure = true;

    defaultInitFile = true;

    extraEmacsPackages = epkgs:
      with epkgs; [
        use-package # Package management
        pdf-tools # PDF viewer

        # Core Editing
        undo-fu
        treesit-fold
        avy
        evil
        evil-collection
        evil-commentary

        # Completion / UI
        vertico
        orderless
        marginalia
        consult
        embark
        embark-consult
        # savehist
        corfu
        cape

        # Project & Version Control
        projectile
        magit
        majutsu
        plz
        vc-jj
        fl # magit-integrated forge interface (gh / rad)

        # Development Tools
        envrc
        hl-todo
        gptel
        ghostel
        evil-ghostel
        eldoc-box

        # Language Support (General)
        eglot
        flycheck
        dumb-jump

        # Language Specific Modes (Treesitter based)
        zig-ts-mode
        nix-ts-mode
        just-ts-mode

        # Language Specific Modes (Non-Treesitter / Custom)
        ocaml-eglot
        neocaml
        auctex # For tex mode

        # UI & Keybindings
        which-key
        general

        # Themes
        gruber-darker-theme
        ef-themes
        doom-themes
        vb-light-theme
        vb-dark-theme
      ];

    override = epkgs:
      let
        # Elisp-only ghostel (+ its evil extension) from the dakra/ghostel repo,
        # skipping the Zig module (src/build.zig) whose dep fetch fails; the
        # native module is auto-downloaded at runtime instead.  evil-ghostel's
        # `ghostel` dep is pinned to this build via the let, not the nixpkgs one.
        ghostelSrc = pkgs.fetchFromGitHub {
          owner = "dakra";
          repo = "ghostel";
          rev = "2191afe3049fc785c6fd2b1ab6b826daf500ffbe";
          hash = "sha256-vRGZoQtjsL42ga07fOfEjccKRidAhqgwHBoKs++62Ls=";
        };
        ghostel = epkgs.melpaBuild {
          pname = "ghostel";
          version = "0-unstable-2026-06-08";
          src = ghostelSrc;
          commit = "2191afe3049fc785c6fd2b1ab6b826daf500ffbe";
          packageRequires = [ epkgs.compat ];
          recipe = pkgs.writeText "recipe" ''
            (ghostel :fetcher github :repo "dakra/ghostel"
                     :files ("lisp/*.el" "etc"))
          '';
        };
      in
      epkgs // {
        inherit ghostel;

        evil-ghostel = epkgs.melpaBuild {
          pname = "evil-ghostel";
          version = "0-unstable-2026-06-08";
          src = ghostelSrc;
          commit = "2191afe3049fc785c6fd2b1ab6b826daf500ffbe";
          packageRequires = [ ghostel epkgs.evil epkgs.compat ];
          recipe = pkgs.writeText "recipe" ''
            (evil-ghostel :fetcher github :repo "dakra/ghostel"
                          :files ("extensions/evil-ghostel/*.el"))
          '';
        };

        fl = epkgs.trivialBuild {
          pname = "fl";
          version = "unstable";

          propagatedBuildInputs = with epkgs; [ magit transient with-editor ];

          src = pkgs.fetchgit {
            url = "https://tangled.org/bergsoe.net/fl";
            rev = "d36e1700c9d292d874f1c844956e823faae352bf";
            sha256 = "1qqmfnhq68w0kjd13s5zr31g02dsqazkmaqrsch9il3nwip13v7y";
          };
        };

        majutsu = epkgs.trivialBuild {
          pname = "majutsu";
          version = "unstable";

          propagatedBuildInputs = with epkgs; [
            magit
            transient
            with-editor
            compat
            consult
            plz
            evil
          ];

          src = pkgs.fetchFromGitHub {
            owner = "0WD0";
            repo = "majutsu";
            rev = "b1ba85b01e63efc3ff3aa3937cd0548440350fea";
            sha256 = "sha256-fkRKggcuySbPSLT8PnUlmw7Txbzv5PACZBLV9z4qcdQ=";
          };
        };

        neocaml = epkgs.trivialBuild {
          pname = "neocaml";
          version = "unstable";
          src = pkgs.fetchFromGitHub {
            owner = "bbatsov";
            repo = "neocaml";
            rev = "930e4aa9ad50977eefe296f35d0c5c1e6e112398";
            sha256 = "sha256-EQEe+HZY/3D1e3AUmy+FIO1KAZorvFvt1Bg7B7YVxDw=";
          };
        };

        vb-light-theme = epkgs.trivialBuild {
          pname = "vb-light-theme";
          version = "1.0";
          src = ./themes;
        };

        vb-dark-theme = epkgs.trivialBuild {
          pname = "vb-dark-theme";
          version = "1.0";
          src = ./themes;
        };
      };
  };
}
