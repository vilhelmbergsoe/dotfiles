{ inputs, pkgs, ... }: {
  imports = [ inputs.nixvim.homeModules.nixvim ];
  programs = {
    nixvim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      globals.mapleader = " ";
      keymaps = [{
        mode = "n";
        key = "<Space>";
        action = "<Nop>";
        options.silent = true;
      }];

      plugins = {
        lsp = {
          enable = true;
          servers = {
            rust_analyzer = {
              enable = true;

              installCargo = false;
              installRustc = false;
            };
          };
        };

        web-devicons.enable = true;

        telescope.enable = true;
        oil.enable = true;
        treesitter.enable = true;

        cmp = {
          enable = true;
          autoEnableSources = true;
        };
      };

      extraPlugins = with pkgs.vimPlugins;
        [
          # vim-nix
          direnv-vim
        ];

      opts = {
        number = true;
        relativenumber = true;

        shiftwidth = 2;

        # disable the swapfile
        swapfile = false;
      };
    };
    # neovim = {
    #   enable = true;

    #   defaultEditor = true;

    #   viAlias = true;
    #   vimAlias = true;

    #   extraConfig = ''
    #     set number relativenumber
    #   '';

    #   plugins = with pkgs.vimPlugins; [
    #     vim-nix
    #     vim-commentary
    #     rust-vim
    #     vim-go
    #     gotests-vim
    #     zig-vim
    #   ];
    # };
  };
}
# TODO
# Add vimrc to config

