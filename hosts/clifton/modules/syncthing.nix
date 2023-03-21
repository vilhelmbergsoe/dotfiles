_: {
  services = {
    syncthing = {
      enable = true;
      user = "vb";
      dataDir = "/home/vb"; # Default folder for new synced folders
      configDir = "/home/vb/.config/syncthing"; # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      devices = {
        "vb-desktop" = {id = "64CM5XW-5VJ4WMW-EXQB5VF-FZFE2L5-3ZSJGHL-XUMNL4V-VW6GNGK-OJEQWAH";};
        "vb-laptop" = {id = "DY67224-SM5DWRX-4EEYXQB-53WGNUX-F6W7G3K-ZYVDOO7-VPOCHLB-TIBIDQO";};
      };
      folders = {
        "Sync" = {
          versioning = {
            type = "simple";
            params.keep = "10";
          };
          path = "/home/vb/Sync";
          devices = ["vb-desktop" "vb-laptop"];
        };
      };
    };
  };

  # Syncthing ports
  networking.firewall.allowedTCPPorts = [8384 22000];
  networking.firewall.allowedUDPPorts = [22000 21027];
}
