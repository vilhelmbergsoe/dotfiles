{ pkgs, ... }: {
  programs = {
    git = {
      enable = true;
      # package = pkgs.gitAndTools.gitFull;
      package = pkgs.git;

      userName = "Vilhelm Bergsøe";
      userEmail = "vilhelmbergsoe@gmail.com";
      lfs = { enable = true; };
      extraConfig = {
        github.user = "vilhelmbergsoe";
        core = {
          commitgraph = true;
          fsmonitor = true;
          writeCommitGraph = true;
        };
        feature = {
          manyFiles = true;
        };
      };
    };
    lazygit.enable = true;
  };

  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "git-cmb" ''
      if [ -n "$(git status --porcelain)" ]; then
        read -p "You have uncommitted changes. Are you sure you want to continue? [y/N] " response
        if [[ ! $response =~ ^[Yy]$ ]]; then
          echo "Operation cancelled."
          exit 1
        fi
      fi
      git reset $(git merge-base master $(git branch --show-current))
    '')

    (pkgs.writeShellScriptBin "git-uncmb" ''
      git reset --hard @{1}
    '')

    mergiraf
  ];
  home.shellAliases = { lg = "lazygit"; };
}
