{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nixvim.homeManagerModules.nixvim];
  programs = {
    nixvim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      globals.mapleader = " ";
      keymaps = [
        {
          mode = "n";
          key = "<Space>";
          action = "<Nop>";
          options.silent = true;
        }
        # {
        #   mode = "i";
        #   key = "<C-BS>";
        #   action = "C-W";
        #   options.noremap = true;
        # }

        # Code action
        {
          mode = "n";
          key = "ca";
          action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          options.silent = true;
        }

        # Formatting
        {
          mode = "n";
          key = "gf";
          action = "<cmd>lua vim.lsp.buf.format()<CR>";
          options.silent = true;
        }

        # Jump to definition
        {
          mode = "n";
          key = "gd";
          action = "<cmd>lua vim.lsp.buf.definition()<CR>";
          options.silent = true;
        }

        # Show references
        {
          mode = "n";
          key = "gD";
          action = "<cmd>lua vim.lsp.buf.references()<CR>";
          options.silent = true;
        }

        # Implementation
        {
          mode = "n";
          key = "gi";
          action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
          options.silent = true;
        }

        # Telescope keybindings
        {
          action = "<cmd>Telescope live_grep<CR>";
          key = "<leader>/";
        }
        {
          action = "<cmd>Telescope find_files<CR>";
          key = "<leader>pf";
        }
        {
          action = "<cmd>Telescope git_commits<CR>";
          key = "<leader>fg";
        }
        {
          action = "<cmd>Telescope oldfiles<CR>";
          key = "<leader>fh";
        }
        {
          action = "<cmd>Telescope colorscheme<CR>";
          key = "<leader>ch";
        }
        {
          action = "<cmd>Telescope man_pages<CR>";
          key = "<leader>fm";
        }

        # Lazygit
        {
          mode = "n";
          key = "<leader>gg";
          action = "<cmd>LazyGit<CR>";
          options = {
            desc = "LazyGit (root dir)";
          };
        }

        # Neotree
        {
          action = "<cmd>Neotree toggle<CR>";
          key = "<leader>op";
        }
      ];

      plugins = {
        lsp = {
          enable = true;
          servers = {
            rust_analyzer = {
              enable = true;

              installCargo = false;
              installRustc = false;
            };
            ts_ls.enable = true;
            html.enable = true;
            nixd.enable = true;
            clangd.enable = true;
          };
        };

        telescope.enable = true;
        oil.enable = true;
        treesitter.enable = true;
        web-devicons.enable = true;
        lazygit.enable = true;
        commentary.enable = true;
        nix.enable = true;
        direnv.enable = true;

        neo-tree = {
          enable = true;
          enableDiagnostics = true;
          enableGitStatus = true;
          enableModifiedMarkers = true;
          enableRefreshOnWrite = true;
          closeIfLastWindow = true;
          popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
          buffers = {
            bindToCwd = false;
            followCurrentFile = {
              enabled = true;
            };
          };
          window = {
            width = 40;
            height = 15;
            autoExpandWidth = false;
            mappings = {
              "<space>" = "none";
              "<tab>" = "toggle_node";
            };
          };
        };

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            completion = {
              completeopt = "menu,menuone,noinsert";
            };
            autoEnableSources = true;
            experimental = {ghost_text = true;};
            performance = {
              debounce = 60;
              fetchingTimeout = 200;
              maxViewEntries = 30;
            };
            formatting = {fields = ["kind" "abbr" "menu"];};
            sources = [
              {name = "nvim_lsp";}
              {
                name = "buffer"; # text within current buffer
                option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                keywordLength = 3;
              }
              {
                name = "path"; # file system paths
                keywordLength = 3;
              }
            ];
            window = {
              completion = {border = "solid";};
              documentation = {border = "solid";};
            };

            mapping = {
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping.select_next_item()";
              "<C-k>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            };
          };
        };

        cmp-nvim-lsp = {
          enable = true; # LSP
        };
        cmp-buffer = {
          enable = true;
        };
        cmp-path = {
          enable = true; # file system paths
        };

        none-ls = {
          enable = true;
          settings = {
            cmd = ["bash -c nvim"];
            debug = true;
          };
          sources = {
            code_actions = {
              statix.enable = true;
              gitsigns.enable = true;
            };
            diagnostics = {
              statix.enable = true;
              deadnix.enable = true;
              pylint.enable = true;
              checkstyle.enable = true;
            };
            formatting = {
              alejandra.enable = true;
              nixpkgs_fmt.enable = true;
              prettier = {
                enable = true;
                disableTsServerFormatter = true;
              };
              black = {
                enable = true;
                settings = ''
                  {
                    extra_args = { "--fast" },
                  }
                '';
              };
            };
            completion = {
              spell.enable = true;
            };
          };
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        # vim-nix
        # direnv-vim
      ];

      opts = {
        number = true;
        relativenumber = true;

        shiftwidth = 2;

        # disable the swapfile
        swapfile = false;
      };
    };
  };
}
