{ pkgs, ... }:

{
  imports = [ ./nix.nix ];


  # DON't KNOW WHERE TO PUT THIS CURRENTLY
  # This will run slock when loginctl lock-session
  programs.xss-lock.enable = true;
  programs.xss-lock.lockerCommand = "/run/wrappers/bin/slock";
  programs.slock.enable = true;
}
