{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # needed from conda-install for some reason
    # xorg.libxcb
    # xorg.libxcb.dev
    conda
  ];
}
