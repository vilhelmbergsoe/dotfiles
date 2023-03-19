{ ... }:

{
  programs.bash = {
    enable = true;
    sessionVariables = {
      "EDITOR" = "nvim";
      "TERM" = "alacritty";
    };
  };
}
