{ pkgs, ... }:

{
  imports = [];

  environment.systemPackages = with pkgs; [
    ripgrep fd duf ncdu git gnupg
  ];
}
