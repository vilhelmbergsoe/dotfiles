{ inputs, pkgs, ... }:
{
  systemd.services.site = {
    enable = true;

    description = "my site";
    wantedBy = [ "multi-user.target" ]; 
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.site.packages.x86_64-linux.default}/bin/site";
      Restart = "on-failure";
    };
  };
}
