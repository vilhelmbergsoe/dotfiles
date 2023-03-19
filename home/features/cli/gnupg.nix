{ pkgs, config, lib, ... }:
let
  pinentry = if config.gtk.enable then {
    package = pkgs.pinentry-gnome;
    name = "qt";
  } else {
    package = pkgs.pinentry-curses;
    name = "curses";
  };
in {
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = pinentry.name;
  };
}
