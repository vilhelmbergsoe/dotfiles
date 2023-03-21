{ inputs, outputs, pkgs, ... }: {
  imports = [
    ./global

    ./features/cli
    ./features/desktop/common
    ./features/desktop/spectrwm
  ];
}
