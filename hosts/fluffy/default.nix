{ inputs, pkgs, lib, config, ... }: {
  imports = [
    # ../common/global
  ];

  # No longer has any effect, nix-darwin manages nix-daemon unconditionally when nix.enable = true;
  # services.nix-daemon.enable = true;

  # fonts.packages = [ pkgs.ubuntu-sans-mono ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [ ];
    brews = [ ];
    casks = [ "alacritty" "rio" "zed" "ghostty" ];
  };

  system.primaryUser = "vilhelmbergsoe";

  services.tailscale.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs = {
    overlays = [ ];
    config = { allowUnfree = true; };
  };

  users.users.vilhelmbergsoe = {
    name = "vilhelmbergsoe";
    home = "/Users/vilhelmbergsoe";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    # false because: You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
    useGlobalPkgs = false;
    useUserPackages = true;
    users.vilhelmbergsoe = import ../../home/fluffy.nix;
  };

  determinateNix = {
    enable = true;

    distributedBuilds = true;
    buildMachines = [
      {
        protocol = "ssh-ng";
        sshUser = "builder";
        hostName = "46.62.250.242";
        systems = [ "aarch64-linux" ];
        maxJobs = 8;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      }
    ];

    customSettings = {
      trusted-users = [ "vilhelmbergsoe" ];
      cores = 2;
      eval-cores = 4;
      extra-experimental-features = [ "ca-derivations" ];
      extra-substituters = [ "https://nix-community.cachix.org" ];
      extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
  };

  # Conflicts with determinate nix daemon
  nix = {
    enable = false;

    #   package = pkgs.nixVersions.latest;

      ## for linux remote builds
      # linux-builder = {
      #   enable = true;
      #   ephemeral = true;
      #   maxJobs = 4;
      #   config = {
      #     virtualisation = {
      #       darwin-builder = {
      #         diskSize = 40 * 1024;
      #         memorySize = 8 * 1024;
      #       };
      #       cores = 6;
      #     };
      #   };
      # };

    #   settings = {
    #     # Enable flakes and new 'nix' command
    #     experimental-features = "nix-command flakes";
    #     # Deduplicate and optimize nix store
    #     # auto-optimise-store = true; # apparently corrupts the store?
    #     trusted-users = ["vilhelmbergsoe" "@admin"];
    #   };
    #   # Deduplicate and optimize nix store
    #   optimise.automatic = true;
    #   gc.automatic = true;
  };

  system.stateVersion = 5;
}
