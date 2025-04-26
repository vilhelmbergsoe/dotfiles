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
    casks = [ "alacritty" "rio" "zed" ];
  };

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
    useGlobalPkgs = true;
    useUserPackages = true;
    users.vilhelmbergsoe = import ../../home/fluffy.nix;
  };

  # Conflicts with determinate nix daemon
  nix = {
    enable = false;

    #   package = pkgs.nixVersions.latest;

    #   # for linux remote builds
    #   linux-builder = {
    #     enable = true;
    #     ephemeral = true;
    #     maxJobs = 4;
    #     config = {
    #       virtualisation = {
    #         darwin-builder = {
    #           diskSize = 40 * 1024;
    #           memorySize = 8 * 1024;
    #         };
    #         cores = 6;
    #       };
    #     };
    #   };

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
