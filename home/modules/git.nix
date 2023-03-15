{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Vilhelm Bergsøe";
    userEmail = "vilhelmbergsoe@gmail.com";
    lfs = { enable = true; };
  };
}
