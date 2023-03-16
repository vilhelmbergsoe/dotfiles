{ pkgs, ... }: {
  programs = {
    neovim = {
      enable = true;

      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [ vim-nix vim-commentary ];
    };
  };
}

# TODO
# Add vimrc to config
