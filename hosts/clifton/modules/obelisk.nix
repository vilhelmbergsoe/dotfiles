{ config, lib, pkgs, ... }:

let
  obeliskFlake = builtins.getFlake "github:obeli-sk/obelisk/latest";
  obeliskPackage = obeliskFlake.packages.${pkgs.system}.default;
  
  dataDir = "/var/lib/obelisk";
  cacheDir = "/var/cache/obelisk/wasm";
  
  settings = {
    webui.listening_addr = "127.0.0.1:8081";
    api.listening_addr = "127.0.0.1:5005";
    wasm.cache_directory = cacheDir;
  };
  
  configFile = (pkgs.formats.toml {}).generate "obelisk.toml" settings;
in
{
  users.users.obelisk = {
    isSystemUser = true;
    group = "obelisk";
    home = dataDir;
  };
  
  users.groups.obelisk = {};

  systemd.tmpfiles.rules = [
    "d '${dataDir}' 0750 obelisk obelisk - -"
    "d '${cacheDir}' 0750 obelisk obelisk - -"
  ];

  systemd.services.obelisk = {
    description = "Obelisk Workflow Engine";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      User = "obelisk";
      Group = "obelisk";
      WorkingDirectory = dataDir;
      ExecStart = "${obeliskPackage}/bin/obelisk server run --config ${configFile}";
      Restart = "on-failure";
      RestartSec = "5s";
      
      # Uncomment if you need to load environment variables from a file
      # EnvironmentFile = "/etc/obelisk/secrets.env";
      
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ReadWritePaths = [ dataDir cacheDir ];
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
      RestrictNamespaces = true;
      LockPersonality = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };
}
