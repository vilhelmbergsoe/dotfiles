{outputs, ...}: {
  imports = [./nix.nix ./podman.nix];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {allowUnfree = true;};
  };

  programs.bash.promptInit = ''
    PS1="[\u@\h:\w]\\$ \[$(tput sgr0)\]"
  '';
}
