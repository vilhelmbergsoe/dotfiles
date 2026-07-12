{ pkgs, inputs, config, lib, ... }: {
  nixpkgs.overlays = [
    (inputs.emacs-overlay.overlays.default)
  ];

  home.file.".emacs.d/gptel-agents".source = ./agents;

  home.packages = [
    pkgs.nixd
    pkgs.nixfmt-classic
    pkgs.libgccjit
    pkgs.cmake # needed for vterm module compilation
    pkgs.universal-ctags

    # Yarn PnP support fix
    (pkgs.writers.writeBashBin "typescript-language-server" ''
      ${pkgs.yarn}/bin/yarn node ${pkgs.typescript-language-server}/lib/node_modules/typescript-language-server/lib/cli.mjs "$@"
    '')
  ];

  # services.emacs.enable = true;
  programs.emacs.enable = true;
  programs.emacs.package =
    let
      inherit (inputs.emacs-overlay.packages.${pkgs.stdenv.hostPlatform.system})
        emacs-unstable emacs-git-pgtk;
    in
    pkgs.emacsWithPackagesFromUsePackage {
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
        origami
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
        forge # Code forge integration (github, etc.)
	vc-jj
        fl # magit-integrated forge interface (gh / rad)

        # Development Tools
        envrc
        hl-todo
        gptel
        vterm
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
      epkgs // {
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
