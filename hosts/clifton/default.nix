{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common/global
    ../common/syncthing.nix

    # TODO
    # ./modules/ddns.nix
    ./modules/site.nix
    # ./modules/minecraft-server

    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath =
      lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  networking = {
    hostName = "clifton";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 80];
    };

    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  services.vnstat.enable = true;
  services.tailscale.enable = true;

  boot.kernelPackages = pkgs.linuxPackages;

  # Execute binaries as if native architecture/os
  boot.binfmt.emulatedSystems = ["aarch64-linux" "wasm32-wasi" "wasm64-wasi"];

  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
  boot.tmp.cleanOnBoot = true;

  users.users = {
    vb = {
      initialPassword = "nixos";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCc4b92ckAOPfBiNga2vvCHSbVo6HliSkuqeYhPFxGFmrWoyCkKJsNMS8G4A2ri85SI11fx+pEK2eGMlRcDD2ly/cyWHqNzip6eOjAUxkeHne+0Pc25HNjU+1lGxkwEOXMrS20rcNxGLtbpQo8rfSpO8y4ZlbaSp7+ibv2uBkYEY5Qp8DYnyugFmladcPbw3MN9KP76E6oX0548Smtb1VWPvYeVX3/lvQPw8qfBkZWymbEHvX0CsUOAi7RGpmDCPQueC0nL9t+ZdFUghlVVNA/z4ZjLuoCCP1DHLpiD+s9Sm7ZS760NMOQqzYQDhN/zV45zPGQ/L2ESJuJg/PD555Ib6CITmc00lWu0y94MNb3DIW7/rsL1GMCD27YMAvZmgnsr639R9CSBUOV8CQPw0jklO89B2Cp9DpWzAnBF/ncke8h9+57zMRKIJGVreQTKa0+kAHxiFgIMxA3bGdK9ZQYtHSn9D308Y7mkPzj2Ij0NVKy/MYhdUTIvDIzczc+ozKM= vb"
      ];

      extraGroups = ["wheel" "networkmanager" "docker"];

      shell = pkgs.bash;
    };
  };

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {keyMap = "dk";};

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Power management
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "powersave";
      turbo = "auto";
    };
  };
  services.thermald.enable = true;

  # Home manager
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {vb = import ../../home/clifton.nix;};
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
