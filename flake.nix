{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-darwin = {
      url =
        "github:nix-giant/nix-darwin-emacs?rev=72cc570ea7cb986dd54757211c2d715d0febb0fd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Remote deployment
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware quirks
    hardware.url = "github:nixos/nixos-hardware";

    # Site
    site.url = "github:vilhelmbergsoe/site";

    # Minecraft Server
    nix-minecraft.url = "github:misterio77/nix-minecraft";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, comin, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
      inherit (self) outputs;
    in rec {
      overlays = import ./overlays { inherit inputs; };

      # Linux VM
      packages.aarch64-darwin.darwinVM =
        self.nixosConfigurations.darwinVM.config.system.build.vm;

      # Devshell for bootstrapping
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; });

      nixosConfigurations = {
        # Home Server
        clifton = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
	    ./hosts/clifton
	    comin.nixosModules.comin
	  ];
        };
        # Desktop Computer
        buckbeak = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/buckbeak ];
        };
        darwinVM = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/linux-vm
            {
              virtualisation.vmVariant.virtualisation.host.pkgs =
                nixpkgs.legacyPackages.aarch64-darwin;
            }
          ];
        };
      };

      darwinConfigurations."fluffy" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/fluffy
          home-manager.darwinModules.home-manager

          { nixpkgs.overlays = [ inputs.emacs-darwin.overlays.emacs ]; }
        ];
      };
    };
}
