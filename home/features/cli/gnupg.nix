{
  pkgs,
  config,
  ...
}: let
  pinentry =
    if config.gtk.enable
    then {
      package = pkgs.pinentry-gnome;
      name = "gnome3";
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

    # Doesn't do anything anymore
    # pinentryFlavor = pinentry.name;
  };

  home.packages = [pkgs.gnupg];
}
