{ pkgs, ... }:

{
  imports = [ ./nix.nix ];

  programs.bash.promptInit = ''
    PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
  '';
}
