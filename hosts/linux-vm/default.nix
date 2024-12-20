{pkgs, ...}: {
  virtualisation = {
    vmVariant = {
      config.virtualisation = {
        writableStoreUseTmpfs = false;

        # Make VM output to the terminal instead of a separate window
        graphics = false;
        diskSize = 40 * 1024;
        memorySize = 4 * 1024;
        cores = 4;

        qemu.options = ["-vga std" "-netdev user,id=net0" "-device virtio-net-device,netdev=net0"];
      };
    };
  };

  programs.direnv.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure networking
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  users.users.vm = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };
  services.getty.autologinUser = "vm";
  security.sudo.wheelNeedsPassword = false;

  nix = {
    package = pkgs.nixVersions.latest;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      # auto-optimise-store = true; # apparently corrupts the store?
      trusted-users = ["vm"];
    };
    # Deduplicate and optimize nix store
    optimise.automatic = true;
  };

  system.stateVersion = "24.05";
}
