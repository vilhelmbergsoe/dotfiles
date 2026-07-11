{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv.overrideAttrs (_: { doCheck = false; });

    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
