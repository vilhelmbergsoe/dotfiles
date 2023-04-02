{
  pkgs,
  config,
  ...
}: let
  pinentry =
    if config.gtk.enable
    then {
      package = pkgs.pinentry-qt;
      name = "qt";
    }
    else {
      package = pkgs.pinentry-curses;
      name = "curses";
    };
in {
  services.gpg-agent = {
    enable = true;

    enableBashIntegration = true;
    enableSshSupport = true;
    pinentryFlavor = pinentry.name;
  };

  home.packages = [pkgs.gnupg];
}
