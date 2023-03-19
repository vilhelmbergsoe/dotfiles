{ config, lib, pkgs, ... }:

{
  services = {
    syncthing = {
        enable = true;
        user = "vb";
        dataDir = "/home/vb";    # Default folder for new synced folders
        configDir = "/home/vb/.config/syncthing";   # Folder for Syncthing's settings and keys
        guiAddress = "0.0.0.0:8384";
        folders = {
          "Sync" = {
            versioning = {
              type = "simple";
              params.keep = "10";
            };
            path = "/home/vb/Sync";
          };
        };
    };
  };
}
