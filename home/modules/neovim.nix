{ pkgs, ... }: {
  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [ vim-nix vim-commentary ];
    };

    # For some reason this is needed and defaultEditor doesn't work
    bash = {
      enable = true;
      sessionVariables = { "EDITOR" = "nvim"; };
    };
  };
}

# TODO
# Add vimrc to config
