{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./global

    ./features/cli
    ./features/games
    ./features/desktop/common
    ./features/desktop/spectrwm
  ];

  # use uutils coreutils instead of gnu coreutils
  # home.packages = with pkgs; [(pkgs.uutils-coreutils.override {prefix = "";})];
}
