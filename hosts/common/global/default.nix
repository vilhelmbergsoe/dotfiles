{ outputs, pkgs, ... }:

{
  imports = [ ./nix.nix ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = { allowUnfree = true; };
  };

  programs.bash.promptInit = ''
    PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
  '';
}
