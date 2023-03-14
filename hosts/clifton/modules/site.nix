{ inputs, lib, pkgs, site, ... }:
{
  # virtualisation.oci-containers.backend = "podman";
  # virtualisation.oci-containers.containers = {
  #   site = {
  #     image = "bergsoe.net:latest";
  #     autoStart = true;
  #     ports = [ "8080:8080" ];
  #   };
  # };

  # systemd.services.site = {
  #     wantedBy = [ "multi-user.target" ]; 
  #     after = [ "network.target" ];
  #     description = "My site";
  #     serviceConfig = {
  #       Type = "forking";
  #       ExecStart = ''${pkgs.site}/bin/sb'';
  #     };
  # };
}
