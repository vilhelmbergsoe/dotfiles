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
    ../common/cachix.nix
    # ../common/virt-manager.nix
    ../common/ml.nix

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
    hostName = "buckbeak";
    networkmanager.enable = true;
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.vnstat.enable = true;

  services.tailscale.enable = true;

  programs.gamemode.enable = true;

  # Enable virtualisation
  virtualisation.libvirtd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Execute binaries as if native architecture/os
  boot.binfmt.emulatedSystems = ["riscv64-linux" "aarch64-linux" "wasm32-wasi" "wasm64-wasi"];

  boot.loader.systemd-boot.enable = true;
  boot.tmp.cleanOnBoot = true;

  boot.extraModulePackages = with config.boot.kernelPackages; [rtl88xxau-aircrack];

  # begin desktop

  services.displayManager.defaultSession = "none+spectrwm";
  services.xserver = {
    enable = true;

    displayManager.lightdm = {
      enable = true;
      background = "${pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath}";
    };

    windowManager.spectrwm = {
      enable = true;
    };

    xkb.layout = "dk";

    videoDrivers = ["nvidia"];
  };

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = true;

    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # This will run slock on loginctl lock-session
  programs.xss-lock.enable = true;
  programs.xss-lock.lockerCommand = "/run/wrappers/bin/slock";
  programs.slock.enable = true;

  # This is needed for pinentry to work properly
  programs.gnupg.agent.enable = true;

  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {keyMap = "dk";};

  services.printing.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      cascadia-code
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Source Han Serif"];
      sansSerif = ["Noto Sans" "Source Han Sans"];
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [pkgs.proton-ge-bin];
  };
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
      "steam-run"
    ];

  # Fixes some GTK programs
  programs.dconf.enable = true;

  # end desktop

  users.users = {
    vb = {
      initialPassword = "nixos";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCc4b92ckAOPfBiNga2vvCHSbVo6HliSkuqeYhPFxGFmrWoyCkKJsNMS8G4A2ri85SI11fx+pEK2eGMlRcDD2ly/cyWHqNzip6eOjAUxkeHne+0Pc25HNjU+1lGxkwEOXMrS20rcNxGLtbpQo8rfSpO8y4ZlbaSp7+ibv2uBkYEY5Qp8DYnyugFmladcPbw3MN9KP76E6oX0548Smtb1VWPvYeVX3/lvQPw8qfBkZWymbEHvX0CsUOAi7RGpmDCPQueC0nL9t+ZdFUghlVVNA/z4ZjLuoCCP1DHLpiD+s9Sm7ZS760NMOQqzYQDhN/zV45zPGQ/L2ESJuJg/PD555Ib6CITmc00lWu0y94MNb3DIW7/rsL1GMCD27YMAvZmgnsr639R9CSBUOV8CQPw0jklO89B2Cp9DpWzAnBF/ncke8h9+57zMRKIJGVreQTKa0+kAHxiFgIMxA3bGdK9ZQYtHSn9D308Y7mkPzj2Ij0NVKy/MYhdUTIvDIzczc+ozKM= vb"
      ];
      extraGroups = ["wheel" "networkmanager" "docker" "libvirtd"];

      shell = pkgs.bash;
    };
  };

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {vb = import ../../home/buckbeak.nix;};
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
